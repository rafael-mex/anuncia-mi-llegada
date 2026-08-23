import 'package:flutter/material.dart';

final ValueNotifier<bool> isTrueDarkMode = ValueNotifier(false);

class AppTheme {
  //---- Selector Widget ----

  //Orange Container (LM = Light Mode , DM = Dark Mode)
  static const LinearGradient colorsOfOrangeContianerLM = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color.fromRGBO(245, 146, 69, 88),
      Color.fromRGBO(246, 147, 70, 100),
    ],
  );

  static const LinearGradient colorsOfOrangeContainerDM = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color.fromRGBO(199, 113, 70, 100),
      Color.fromRGBO(255, 111, 0, 100),
    ],
  );

  //Glass Container (LM = Light Mode , DM = Dark Mode)
  static const LinearGradient colorOfGlassContainerLM = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color.fromRGBO(249, 217, 191, 100),
      Color.fromRGBO(249, 215, 173, 100),
    ],
  );

  static const Color colorOfGlassContainerDM = Color.fromRGBO(
    174,
    159,
    147,
    19,
  );
  //--------

  // --- Background Color ---
  //Light Mode
  static const Color backgroundColorLM = Colors.white;

  //Dark Mode
  static const LinearGradient backgroundColorDM = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomRight,
    colors: [Color.fromRGBO(0, 0, 0, 75), Color.fromRGBO(64, 28, 0, 75)],
  );
  //--------

  static ThemeData get lightTheme => ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: backgroundColorLM,
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: Color.fromRGBO(91, 79, 79, 100)),
    ),
  );

  static ThemeData get darkTheme => ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Colors.transparent,
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: Color.fromRGBO(204, 204, 204, 100)),
    ),
  );
}
