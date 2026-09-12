import 'package:anuncia_mi_llegada/config/preferences/preferences_service.dart';
import 'package:anuncia_mi_llegada/data/models/history_items.dart';
import 'package:anuncia_mi_llegada/presentation/screens/selectors/custom_location/map_screen.dart';
import 'package:anuncia_mi_llegada/theme/app_theme.dart';
import 'package:anuncia_mi_llegada/utils/send_message_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
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

Future<void> _openMapAndSend(BuildContext context) async {
  final selectedPoint = await Navigator.of(
    context,
  ).push<LatLng>(MaterialPageRoute(builder: (_) => const MapScreen()));
  if (selectedPoint == null) return;

  String locationText = '${selectedPoint.latitude}, ${selectedPoint.longitude}';

  try {
    final geocoder = Geocoding();
    final placemarks = await geocoder.placemarkFromCoordinates(
      selectedPoint.latitude,
      selectedPoint.longitude,
    );

    if (placemarks.isNotEmpty) {
      final place = placemarks.first;
      final street = place.street ?? place.thoroughfare ?? '';
      final neighborhood = place.subLocality ?? place.locality ?? '';

      final formattedAddress = '$street, $neighborhood'.trim().replaceAll(
        RegExp(r'^,\s*|,\s*$'),
        '',
      );

      if (formattedAddress.isNotEmpty) {
        locationText = formattedAddress;
      }
    }
  } catch (e) {
    debugPrint(
      "Parece que hubo un error al sacar tu ubicación en el mapa ;( : $e",
    );
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

    try {
      final geocoder = Geocoding();
      final placemarks = await geocoder.placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        final street =
            place.street ?? place.thoroughfare ?? place.subThoroughfare ?? '';
        final neighborhood = place.subLocality ?? place.locality ?? '';

        final formattedAddress = '$street, $neighborhood'.trim().replaceAll(
          RegExp(r'^,\s*|,\s*$'),
          '',
        );

        if (formattedAddress.isNotEmpty) {
          locationText = formattedAddress;
        }
      }
    } catch (e) {
      debugPrint("Parece que hubo un error al obtener tu dirección :( : $e");
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
