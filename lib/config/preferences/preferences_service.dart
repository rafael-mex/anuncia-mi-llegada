import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static late SharedPreferences _preferences;
  static bool _initialized = false;

  //Configuraciones de fábrica:
  static const bool defaultIsTrueDarkMode = false;
  static const String defaultMessageBody = "Ya estoy en";
  static const bool defaultWillBeShowedTransportName = true;
  static const bool defaultWillBeShowedLineNamesInMessage = true;
  static const bool defaultWillBeShowedInstitutionsName = true;

  //Variables
  static final isTrueDarkMode =
      ValueNotifier<bool>(defaultIsTrueDarkMode);
  static final messageBody = ValueNotifier<String>(defaultMessageBody);

  static final willBeShowedTransportName =
      ValueNotifier<bool>(defaultWillBeShowedTransportName);
  static final willBeShowedLineNamesInMessage =
      ValueNotifier<bool>(defaultWillBeShowedLineNamesInMessage);
  static final willBeShowedInstitutionsName =
      ValueNotifier<bool>(defaultWillBeShowedInstitutionsName);

  ///Indica si alguna configuración difiere de su valor de fábrica.
  static bool get hasModifiedSettings =>
      isTrueDarkMode.value != defaultIsTrueDarkMode ||
      messageBody.value != defaultMessageBody ||
      willBeShowedTransportName.value != defaultWillBeShowedTransportName ||
      willBeShowedLineNamesInMessage.value !=
          defaultWillBeShowedLineNamesInMessage ||
      willBeShowedInstitutionsName.value !=
          defaultWillBeShowedInstitutionsName;

  static Future<void> init() async {
    if (_initialized) return;
    _initialized = true;
    _preferences = await SharedPreferences.getInstance();

    // Lectura de las preferencias
    isTrueDarkMode.value =
        _preferences.getBool('isTrueDarkMode') ?? defaultIsTrueDarkMode;
    messageBody.value =
        _preferences.getString('messageBody') ?? defaultMessageBody;

    willBeShowedTransportName.value =
        _preferences.getBool('willBeShowedTransportName') ??
        defaultWillBeShowedTransportName;
    willBeShowedLineNamesInMessage.value =
        _preferences.getBool('willBeShowedLineNamesInMessage') ??
        defaultWillBeShowedLineNamesInMessage;
    willBeShowedInstitutionsName.value =
        _preferences.getBool('willBeShowedInstitutionsName') ??
        defaultWillBeShowedInstitutionsName;

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

  // Restablecimiento de todas las configuraciones a su estado original
  static Future<void> resetAll() async {
    isTrueDarkMode.value = defaultIsTrueDarkMode;
    messageBody.value = defaultMessageBody;
    willBeShowedTransportName.value = defaultWillBeShowedTransportName;
    willBeShowedLineNamesInMessage.value =
        defaultWillBeShowedLineNamesInMessage;
    willBeShowedInstitutionsName.value = defaultWillBeShowedInstitutionsName;

    await _preferences.setBool('isTrueDarkMode', defaultIsTrueDarkMode);
    await _preferences.setString('messageBody', defaultMessageBody);
    await _preferences.setBool(
      'willBeShowedTransportName',
      defaultWillBeShowedTransportName,
    );
    await _preferences.setBool(
      'willBeShowedLineNamesInMessage',
      defaultWillBeShowedLineNamesInMessage,
    );
    await _preferences.setBool(
      'willBeShowedInstitutionsName',
      defaultWillBeShowedInstitutionsName,
    );
  }
}