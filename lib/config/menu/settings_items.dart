import 'package:anuncia_mi_llegada/config/preferences/preferences_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:light_dark_theme_toggle/light_dark_theme_toggle.dart';

class MenuItem {
  final Widget title;
  final Widget subtitle;
  final Widget icon;
  final Widget? showedConfigurations;

  MenuItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    this.showedConfigurations,
  });
}

final appSettingsItems = <MenuItem>[
  //------ Option: Estaciones ------
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
    //Icon
    icon: SvgPicture.asset(
      'assets/icons/config_icons/estaciones.svg',
      fit: BoxFit.contain,
    ),
  ),
  //------
  // ------ Option: Mensajes ------
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
    //Icon
    icon: SvgPicture.asset(
      'assets/icons/config_icons/mensajes.svg',
      fit: BoxFit.contain,
    ),
    showedConfigurations: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
          // Reactive switch
          ValueListenableBuilder<bool>(
            valueListenable: PreferencesService.showTransportName,
            builder: (context, value, _) => SwitchListTile(
              title: const Text(
                "Mostrar nombre del transporte",
                style: TextStyle(fontFamily: 'Nunito', fontSize: 14),
              ),
              value: value,
              onChanged: PreferencesService.willBeShowedTransportName ,
              activeThumbColor: const Color(0xFFF26400),
            ),
          ),
          // TextField Varchar
          TextField(
            maxLength: 60,
            controller: TextEditingController(
              text: PreferencesService.messageBody.value,
            ),
            onChanged: PreferencesService.setYourCustomMessage,
            decoration: const InputDecoration(
              hintText: 'Cuerpo del mensaje',
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFF26400)),
              ),
            ),
          ),
        ],
        ),
      ),
    ),
  ),
  //------

  //------ Option: Apariencia ------
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
        //Icon
        SvgPicture.asset(
          'assets/icons/config_icons/apariencia.svg',
          width: 100,
          height: 100,
          fit: BoxFit.contain,
        ),

        ValueListenableBuilder<bool>(
          valueListenable: PreferencesService.isTrueDarkMode,
          builder: (context, isTrueDark, _) => LightDarkThemeToggle(
            value: !isTrueDark,
            onChanged: (value) => (PreferencesService.isTrueDarkMode.value = !value),
            themeIconType: ThemeIconType.expand,
            color: Colors.white,
            size: 41,
          ),
        ),
        //------
      ],
    );
  }
}
