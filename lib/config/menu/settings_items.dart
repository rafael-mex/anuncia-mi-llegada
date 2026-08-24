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
//Estilos de texto
/* Font del Metro:*/ const metroStyle = TextStyle(fontFamily: 'METRO-DF', fontSize: 24);
/* Nunito:*/ const _nunitoFamily = TextStyle(
    height: 1.3,
    fontFamily: 'Nunito',
    fontSize: 14,
    letterSpacing: 0,
    fontWeight: FontWeight.w700,
  );

final appSettingsItems = <MenuItem>[
 // ------ Option: Estaciones ------
  MenuItem(
    title: Text("Estaciones", style: metroStyle),
    subtitle: Text(
      "Configura el como aparecen las \nestaciones en la aplicación.",
      style: _nunitoFamily
    ),
    icon: SvgPicture.asset(
      'assets/icons/config_icons/estaciones.svg',
      fit: BoxFit.contain,
    ),
    //Opciones del menú:
    showedConfigurations: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Material(
        type: MaterialType.transparency,
        child: Builder(
          builder: (context) {
            // Colores del app Theme.
            final dynamicColor = Theme.of(context).textTheme.bodyMedium?.color;
            final dynamicStyle = _nunitoFamily.copyWith(color: dynamicColor);

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start, 
              children: [
                // Grupo: Movilidad Integrada y MOVIMEX
                Text("Movilidad Integrada y Movimex", style: dynamicStyle),
                Divider(color: dynamicColor, thickness: 1, height: 8),
                ValueListenableBuilder<bool>(
                  valueListenable: PreferencesService.willBeShowedLineNamesInMessage, 
                  builder: (context, value, _) => SwitchListTile(
                    contentPadding: EdgeInsets.zero, 
                    //Texto y estilo
                    title: Text(
                      "Mostrar sugerencia de nombrar \nsolo la línea escogida",
                      style: dynamicStyle,
                    ),

                    value: value,
                    onChanged: PreferencesService.showLineNamesInMessage,
                    activeThumbColor: const Color(0xFFF26400),
                  ),
                ),
                
                /* Separación: */ const SizedBox(height: 12), 
                
                // Grupo: STC Metro
                Text("STC Metro", style: dynamicStyle),
                Divider(color: dynamicColor, thickness: 1, height: 8),
                ValueListenableBuilder<bool>(
                  valueListenable: PreferencesService.willBeShowedInstitutionsName, 
                  builder: (context, value, _) => SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    //Texto y estilo
                    title: Text(
                      "Mostrar instituciones\nacompañadas de nombres de estaciones",
                      style: dynamicStyle,
                    ),

                    value: value,
                    onChanged: PreferencesService.showInstitutionsName,
                    activeThumbColor: const Color(0xFFF26400),
                  ),
                ),
              ],
            );
          }
        ),
      ),
    ),
  ),
  // ------
  // ------ Option: Mensajes ------
  MenuItem(
    title: Text(
      "Mensajes",
      style: metroStyle,
    ),
    subtitle: Text(
      "Personaliza el mensaje que \nenviarás a tus contactos.",
      style: _nunitoFamily
    ),
    //Icon
    icon: SvgPicture.asset(
      'assets/icons/config_icons/mensajes.svg',
      fit: BoxFit.contain,
    ),
    //Opciones del menú:
    showedConfigurations: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Material(
        type: MaterialType.transparency,
        child: Builder(
          builder: (context) {
            // Colores del app Theme.
            final dynamicColor = Theme.of(context).textTheme.bodyMedium?.color;
            final dynamicStyle = _nunitoFamily.copyWith(color: dynamicColor);

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start, 
              children: [
                // Grupo: Movilidad Integrada y MOVIMEX

                // Reactive switch
                Text("Movilidad Integrada y Movimex", style: dynamicStyle),
                Divider(color: dynamicColor, thickness: 1, height: 8),
                ValueListenableBuilder<bool>(
                  valueListenable: PreferencesService.willBeShowedTransportName,
                  builder: (context, value, _) => SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      "Mostrar nombre del transporte",
                      style: dynamicStyle,
                    ),
                    value: value,
                    onChanged: PreferencesService.showTransportName,
                    activeThumbColor: const Color(0xFFF26400),
                  ),
                ),
                
                // Cuerpo del mensaje
                // TextField Varchar
                Text("Cuerpo del Mensaje", style: dynamicStyle),
                Divider(color: dynamicColor, thickness: 1, height: 8),
                TextField(
                  maxLength: 60,
                  controller: TextEditingController(
                    text: PreferencesService.messageBody.value,
                  ),
                  onChanged: PreferencesService.setYourCustomMessage,
                  style: dynamicStyle,
                  decoration: InputDecoration(
                    hintText: 'Cuerpo del mensaje',
                    hintStyle: dynamicStyle,
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFF26400)),
                    ),
                  ),
                ),
              ],
            );
          }
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
      style: _nunitoFamily,
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
          builder: (context, isTrueDark, _) => /* Animación del icono:*/ LightDarkThemeToggle(
            value: !isTrueDark,
            onChanged: (value) =>
                (PreferencesService.isTrueDarkMode.value = !value),
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
