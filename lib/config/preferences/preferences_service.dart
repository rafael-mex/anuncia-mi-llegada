import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static late SharedPreferences _preferences;
  static bool _initialized = false;

  //Variables
  static final isTrueDarkMode = ValueNotifier<bool>(false);
  static final messageBody = ValueNotifier<String>("Ya estoy en");

  static final willBeShowedTransportName = ValueNotifier<bool>(true);
  static final willBeShowedLineNamesInMessage = ValueNotifier<bool>(true);
  static final willBeShowedInstitutionsName = ValueNotifier<bool>(true);

  static Future<void> init() async {
    if (_initialized) return;
    _initialized = true;
    _preferences = await SharedPreferences.getInstance();

    // Lectura de las preferencias
    isTrueDarkMode.value = _preferences.getBool('isTrueDarkMode') ?? false;
    messageBody.value = _preferences.getString('messageBody') ?? "Ya estoy en";

    willBeShowedTransportName.value =
        _preferences.getBool('willBeShowedTransportName') ?? true;
    willBeShowedLineNamesInMessage.value =
        _preferences.getBool('willBeShowedLineNamesInMessage') ?? true;
    willBeShowedInstitutionsName.value =
        _preferences.getBool('willBeShowedInstitutionsName') ?? true;

    isTrueDarkMode.addListener(() {
      _preferences.setBool('isTrueDarkMode', isTrueDarkMode.value);
    });
  }

  // Escritura de las preferencias
  static Future<void> setYourCustomMessage(String value) async {
    messageBody.value = value;
    await _preferences.setString('messageBody', value);
  }

  static Future<void> showTransportName(bool value) async {
    willBeShowedTransportName.value = value;
    await _preferences.setBool('willBeShowedTransportName', value);
  }

  static Future<void> showLineNamesInMessage(bool value) async {
    willBeShowedLineNamesInMessage.value = value;
    await _preferences.setBool('willBeShowedLineNamesInMessage', value);
  }

  static Future<void> showInstitutionsName(bool value) async {
    willBeShowedInstitutionsName.value = value;
    await _preferences.setBool('willBeShowedInstitutionsName', value);
  }
}
