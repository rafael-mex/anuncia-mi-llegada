import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

const mapboxGeocodingBaseUrl = 'https://api.mapbox.com/geocoding/v5/mapbox.places';

const _envAccessToken = String.fromEnvironment('ACCESS_TOKEN');
String _resolvedAccessToken = _envAccessToken;

String get mapboxAccessToken => _resolvedAccessToken;

const _mapboxTokenChannel = MethodChannel('rmdeveloper/mapbox_access_token');

const mapboxStyleLightUri = 'mapbox://styles/rm-mapbox/cmu81z3lr003r01sm3utw3mxt';

const mapboxStyleDarkUri = 'mapbox://styles/rm-mapbox/cmu827uvu003b01rhfwpdbiji';


/// Expone el token a Dart. Prioriza --dart-define (ACCESS_TOKEN) y,
/// si no vino, lo toma del side nativo (recurso mapbox_access_token de Android).
Future<void> ensureMapboxAccessToken() async {
  if (_resolvedAccessToken.isNotEmpty) return;

  try {
    final nativeToken = await _mapboxTokenChannel.invokeMethod<String>(
      'getAccessToken',
    );
    if (nativeToken != null && nativeToken.isNotEmpty) {
      _resolvedAccessToken = nativeToken;
    }
  } on PlatformException {
    debugPrint('No se pudo leer el token de Mapbox del canal nativo');
  }
}