import 'package:anuncia_mi_llegada/presentation/widgets/shared/buttons/confirm_ubication_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();
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
              return FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter: snapshot.data ?? _fallbackCenter,
                  initialZoom: 16.0,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.rmdeveloper.anunciaMiLlegada',
                  ),
                ],
              );
            },
          ),
          const Center(
            child: Icon(Icons.location_on, color: Color(0xFFF69346), size: 50),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 680.0),
            child: Center(
              child: ConfirmUbicationButton(
                onTap: () {
                  final center = _mapController.camera.center;
                  Navigator.pop(context, center);
                },
              ),
            ),
          ),
          Positioned(
            top: 50,
            left: 20,
            child: CircleAvatar(
              backgroundColor: Colors.black54,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
