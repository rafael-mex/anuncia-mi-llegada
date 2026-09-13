import 'dart:convert';

import 'package:anuncia_mi_llegada/config/mapbox_config.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class MapboxPlace {
  const MapboxPlace({
    required this.name,
    required this.latitude,
    required this.longitude,
  });

  final String name;
  final double latitude;
  final double longitude;
}

String _formatMapboxPlace(Map<String, dynamic> feature) {
  final text = feature['text'] as String? ?? '';
  final context = feature['context'] as List? ?? const [];

  String? neighborhood;
  for (final entry in context) {
    if (entry is! Map<String, dynamic>) continue;
    final id = (entry['id'] as String?) ?? '';
    if (id.startsWith('neighborhood') || id.startsWith('locality')) {
      neighborhood = entry['text'] as String?;
      break;
    }
  }

  final parts = [text, neighborhood]
      .where((p) => p != null && p.toString().trim().isNotEmpty)
      .toList();
  return parts.join(', ');
}

Future<String> reverseGeocode(double latitude, double longitude) async {
  if (mapboxAccessToken.isEmpty) return '';

  final uri = Uri.parse(
    '$mapboxGeocodingBaseUrl/$longitude,$latitude.json'
    '?access_token=$mapboxAccessToken&language=es&limit=1',
  );

  try {
    final response = await http.get(uri);
    if (response.statusCode != 200) {
      debugPrint(
        'Mapbox geocoding devolvió ${response.statusCode}: ${response.body}',
      );
      return '';
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final features = json['features'] as List? ?? const [];
    if (features.isEmpty) return '';

    final feature = features.first as Map<String, dynamic>;
    final formatted = _formatMapboxPlace(feature);
    if (formatted.isNotEmpty) return formatted;

    return (feature['place_name'] as String?) ?? '';
  } catch (e) {
    debugPrint(
      "Parece que hubo un error al obtener tu dirección ;( : $e",
    );
    return '';
  }
}

Future<List<MapboxPlace>> forwardGeocode(
  String query, {
  LatLng? proximity,
}) async {
  if (mapboxAccessToken.isEmpty) return const [];
  if (query.trim().isEmpty) return const [];

  final encodedQuery = Uri.encodeQueryComponent(query.trim());
  final proximityQuery =
      proximity != null ? '&proximity=${proximity.longitude},${proximity.latitude}' : '';

  final uri = Uri.parse(
    '$mapboxGeocodingBaseUrl/$encodedQuery.json'
    '?access_token=$mapboxAccessToken&language=es&limit=5$proximityQuery',
  );

  try {
    final response = await http.get(uri);
    if (response.statusCode != 200) {
      debugPrint(
        'Mapbox búsqueda devolvió ${response.statusCode}: ${response.body}',
      );
      return const [];
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final features = json['features'] as List? ?? const [];

    final places = <MapboxPlace>[];
    for (final feature in features) {
      if (feature is! Map<String, dynamic>) continue;
      final geometry = feature['geometry'] as Map<String, dynamic>?;
      final coordinates = geometry?['coordinates'] as List? ?? const [];
      if (coordinates.length < 2) continue;

      final placeName = (feature['place_name'] as String?) ?? '';
      if (placeName.isEmpty) continue;

      places.add(
        MapboxPlace(
          name: placeName,
          latitude: (coordinates[1] as num).toDouble(),
          longitude: (coordinates[0] as num).toDouble(),
        ),
      );
    }
    return places;
  } catch (e) {
    debugPrint("Parece que hubo un error al buscar lugares ;( : $e");
    return const [];
  }
}