import 'dart:convert';

import 'package:anuncia_mi_llegada/config/mapbox_config.dart';
import 'package:anuncia_mi_llegada/config/preferences/preferences_service.dart';
import 'package:anuncia_mi_llegada/data/models/history_items.dart';
import 'package:anuncia_mi_llegada/presentation/screens/selectors/custom_location/map_screen.dart';
import 'package:anuncia_mi_llegada/theme/app_theme.dart';
import 'package:anuncia_mi_llegada/utils/send_message_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class MenuItem {
  final Widget title;
  final Widget icon;
  final Widget widget;
  final Future<void> Function(BuildContext context)? onTap;

  MenuItem({
    required this.title,
    required this.icon,
    required this.widget,
    this.onTap,
  });
}

final appCustomLocationItems = <MenuItem>[
  //------ Ubicación manual ------
  MenuItem(
    title: Column(
      children: [
        const SizedBox(height: 40),
        Text("UBICACIÓN \nMANUAL", style: AppTheme.metroStyle),
      ],
    ),
    icon: SvgPicture.asset(
      'assets/icons/custom_location_icons/ubicacion_manual.svg',
    ),
    widget: ManualLocationText(),
  ),

  MenuItem(
    title: Text("UBICAR EN EL \nMAPA", style: AppTheme.metroStyle),
    icon: SvgPicture.asset(
      'assets/icons/custom_location_icons/uso_del_mapa.svg',
    ),
    onTap: _openMapAndSend,
    widget: SizedBox(height: 0),
  ),

  MenuItem(
    title: Text("USAR UBICACIÓN ACTUAL", style: AppTheme.metroStyle),
    icon: SvgPicture.asset(
      'assets/icons/custom_location_icons/ubicacion_actual.svg',
    ),
    onTap: _getCurrentLocationAndSend,
    widget: SizedBox(height: 0),
  ),
];

Future<void> _sendLocation(String locationText, String type) async {
  if (locationText.trim().isEmpty) return;

  final messageBody = PreferencesService.messageBody.value;
  final sendedMessage = "$messageBody ${locationText.trim()}";
  final succes = await SendMessageHelper.sendMessage(sendedMessage);

  if (succes) {
    final newHistoryItem = HistoryItems(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      category: "UBI.PERSONALIZADA",
      stationName: locationText.trim(),
      transportAndLineName: 'Tipo: $type',
      messageTime: DateTime.now(),
    );
    await PreferencesService.saveToHistoryItems(newHistoryItem);
  }
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

Future<String> _reverseGeocode(double latitude, double longitude) async {
  if (mapboxAccessToken.isEmpty) return '';

  final uri = Uri.parse(
    '$mapboxReverseGeocodingBaseUrl/$longitude,$latitude.json'
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

Future<void> _openMapAndSend(BuildContext context) async {
  final selectedPoint = await Navigator.of(
    context,
  ).push<LatLng>(MaterialPageRoute(builder: (_) => const MapScreen()));
  if (selectedPoint == null) return;

  String locationText = '${selectedPoint.latitude}, ${selectedPoint.longitude}';

  final address = await _reverseGeocode(
    selectedPoint.latitude,
    selectedPoint.longitude,
  );
  if (address.isNotEmpty) {
    locationText = address;
  }

  await _sendLocation(locationText, 'Buscada en el mapa');
}

Future<void> _getCurrentLocationAndSend(BuildContext context) async {
  try {
    final isServiceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isServiceEnabled) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('El servicio de ubicación está desactivado'),
          ),
        );
      }
      return;
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return;
      }
    }
    if (permission == LocationPermission.deniedForever) return;

    final position = await Geolocator.getCurrentPosition(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 15),
      ),
    );

    String locationText =
        '${position.latitude.toStringAsFixed(6)}, '
        '${position.longitude.toStringAsFixed(6)}';

    final address = await _reverseGeocode(
      position.latitude,
      position.longitude,
    );
    if (address.isNotEmpty) {
      locationText = address;
    }

    await _sendLocation(locationText, 'Ubicación actual');
  } catch (e) {
    debugPrint("Parece que hubo un error con tu ubicación actual :( : $e");
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo obtener tu ubicación actual')),
      );
    }
  }
}

class ManualLocationText extends StatefulWidget {
  const ManualLocationText({super.key});

  @override
  State<ManualLocationText> createState() => _ManualLocationTextState();
}

class _ManualLocationTextState extends State<ManualLocationText> {
  final TextEditingController _manualUbicationController =
      TextEditingController();

  @override
  void dispose() {
    _manualUbicationController.dispose();
    super.dispose();
  }

  Future<void> _categorizingLocation(String locationText, String type) {
    if (locationText.trim().isEmpty) return Future.value();
    return _sendLocation(locationText, type);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 5),
        ValueListenableBuilder<String>(
          valueListenable: PreferencesService.messageBody,
          builder: (context, messageBody, _) {
            return SizedBox(
              height: 45,
              child: TextField(
                controller: _manualUbicationController,
                style: AppTheme.nunitoFamilySubtitle,
                textInputAction: TextInputAction.send,
                onSubmitted: (value) =>
                    _categorizingLocation(value, 'Ubicación manual'),
                decoration: InputDecoration(
                  prefixText: '$messageBody ',
                  prefixStyle: const TextStyle(
                    fontFamily: 'Nunito',
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                  hintStyle: const TextStyle(color: Colors.white30),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFF69346)),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xFFB6A3A3),
                      width: 2,
                    ),
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(
                      Icons.send_rounded,
                      color: Color(0xFFB6A3A3),
                    ),
                    onPressed: () => _categorizingLocation(
                      _manualUbicationController.text,
                      'Ubicación manual',
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
