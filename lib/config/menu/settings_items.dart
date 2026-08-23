import 'package:anuncia_mi_llegada/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:light_dark_theme_toggle/light_dark_theme_toggle.dart';

class MenuItem {
  final Widget title;
  final Widget subtitle;
  final Widget icon;

  MenuItem({required this.title, required this.subtitle, required this.icon});
}

final appSettingsItems = <MenuItem>[
  //Option: Estaciones
  MenuItem(
    title: Text(
      "Estaciones",
      style: TextStyle(fontFamily: 'METRO-DF', fontSize: 24),
    ),
    subtitle: Text(
      "Configura el como aparecen las \nestaciones en la aplicación.",
      style: TextStyle(
        color: Color.fromRGBO(91, 79, 79, 100),
        height: 0,
        fontFamily: 'Nunito',
        fontSize: 12,
        letterSpacing: 0,
        fontWeight: FontWeight.w700,
      ),
    ),
    icon: Image.asset(
      'assets/icons/config_icons/estaciones.png',
      fit: BoxFit.contain,
    ),
  ),

  //Option: Mensajes
  MenuItem(
    title: Text(
      "Mensajes",
      style: TextStyle(fontFamily: 'METRO-DF', fontSize: 24),
    ),
    subtitle: Text(
      "Personaliza el mensaje que \nenviarás a tus contactos.",
      style: TextStyle(
        color: Color.fromRGBO(91, 79, 79, 100),
        height: 1,
        fontFamily: 'Nunito',
        fontSize: 12,
        letterSpacing: 0,
        fontWeight: FontWeight.w700,
      ),
    ),
    icon: Image.asset(
      'assets/icons/config_icons/mensajes.png',
      fit: BoxFit.contain,
    ),
  ),

  //Option: Apariencia
  MenuItem(
    title: Text(
      "Apariencia",
      style: TextStyle(fontFamily: 'METRO-DF', fontSize: 24),
    ),
    subtitle: Text(
      "Cambia entre el modo claro y \nobscuro.",
      style: TextStyle(
        color: Color.fromRGBO(91, 79, 79, 100),
        height: 0,
        fontFamily: 'Nunito',
        fontSize: 12,
        letterSpacing: 0,
        fontWeight: FontWeight.w700,
      ),
    ),
    icon: const AppearanceIcon(),
  ),
];

class AppearanceIcon extends StatelessWidget {
  const AppearanceIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        //Imagen
        Image.asset(
          'assets/icons/config_icons/apariencia.png',
          width: 100,
          height: 100,
          fit: BoxFit.contain,
        ),

        ValueListenableBuilder<bool>(
          valueListenable: isTrueDarkMode,
          builder: (context, isTrueDark, _) => LightDarkThemeToggle(
            value: !isTrueDark,
            onChanged: (value) => isTrueDarkMode.value = !value,
            themeIconType: ThemeIconType.expand,
            color: Colors.white,
            size: 41,
          ),
        ),
      ],
    );
  }
}
