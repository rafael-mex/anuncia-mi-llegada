import 'package:anuncia_mi_llegada/presentation/widgets/shared/shared_buttons/custom_button.dart';
import 'package:anuncia_mi_llegada/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as mapbox;

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  mapbox.MapboxMap? _mapboxMap;
  late Future<LatLng> _locationFuture;

  static const LatLng _fallbackCenter = LatLng(19.4326, -99.1332);

  @override
  void initState() {
    super.initState();
    _locationFuture = _getCurrentLocation();
  }

  Future<LatLng> _getCurrentLocation() async {
    try {
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied ||
            permission == LocationPermission.deniedForever) {
          return _fallbackCenter;
        }
      }

      if (!await Geolocator.isLocationServiceEnabled()) {
        return _fallbackCenter;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 15),
        ),
      );

      return LatLng(position.latitude, position.longitude);
    } catch (e) {
      debugPrint('No se pudo obtener la ubicación actual: $e');
      return _fallbackCenter;
    }
  }

  void _onMapCreated(mapbox.MapboxMap mapboxMap) {
    _mapboxMap = mapboxMap;
  }

  Future<void> _confirmSelection() async {
    final currentCamera = await _mapboxMap?.getCameraState();
    final center = currentCamera?.center;
    final lat = (center?.coordinates.lat ?? _fallbackCenter.latitude).toDouble();
    final lng =
        (center?.coordinates.lng ?? _fallbackCenter.longitude).toDouble();
    if (!mounted) return;
    Navigator.pop(context, LatLng(lat, lng));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FutureBuilder<LatLng>(
            future: _locationFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const Center(child: CircularProgressIndicator());
              }
              final center = snapshot.data ?? _fallbackCenter;
              return mapbox.MapWidget(
                viewport: mapbox.CameraViewportState(
                  center: mapbox.Point(
                    coordinates: mapbox.Position(
                      center.longitude,
                      center.latitude,
                    ),
                  ),
                  zoom: 16.0,
                ),
                styleUri: mapbox.MapboxStyles.STANDARD,
                onMapCreated: _onMapCreated,
                onMapLoadErrorListener: (error) {
                  debugPrint(
                    'Error cargando el mapa de Mapbox '
                    '(tipo: ${error.type}, mensaje: ${error.message})',
                  );
                },
              );
            },
          ),
          const Center(
            child: Icon(Icons.location_on, color: Color(0xFFF69346), size: 50),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 680.0),
            child: Center(
              child: CustomButton(
                forcedColor: const Color(0xFFF69346),
                textOfButton: Text(
                  'Confirmar ubicación',
                  style: AppTheme.nunitoFamilyCustomButton.copyWith(
                    fontSize: 17,
                  ),
                ),
                buttonAction: _confirmSelection,
              ),
            ),
          ),
          Positioned(
            top: 100,
            left: 20,
            child: CircleAvatar(
              radius: 26,
              backgroundColor: Colors.black54,
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 30),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}