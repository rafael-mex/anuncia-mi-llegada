import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static late SharedPreferences _preferences;
  static bool _initialized = false;

  static final isTrueDarkMode = ValueNotifier<bool>(false);
  static final messageBody = ValueNotifier<String>("Ya estoy en");
  static final showTransportName = ValueNotifier<bool>(true);

  static Future<void> init() async {
    if (_initialized) return;
    _initialized = true;
    _preferences = await SharedPreferences.getInstance();

    isTrueDarkMode.value = _preferences.getBool('isTrueDarkMode') ?? false;
    messageBody.value = _preferences.getString('messageBody') ?? "Ya estoy en";
    showTransportName.value = _preferences.getBool('showTransportName') ?? true;

    // Persiste el tema ante CUALQUIER escritura (interruptor o fila).
    isTrueDarkMode.addListener(() {
      _preferences.setBool('isTrueDarkMode', isTrueDarkMode.value);
    });
  } 

  static Future<void> setYourCustomMessage(String value) async {
    messageBody.value = value;
    await _preferences.setString('messageBody', value);
  }

  static Future<void> willBeShowedTransportName(bool value) async {
    showTransportName.value = value;
    await _preferences.setBool('showTransportName', value);
  }
}