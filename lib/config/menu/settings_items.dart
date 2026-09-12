import 'package:anuncia_mi_llegada/config/preferences/preferences_service.dart';
import 'package:anuncia_mi_llegada/theme/app_theme.dart';
import 'package:anuncia_mi_llegada/utils/platform_dialog_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:light_dark_theme_toggle/light_dark_theme_toggle.dart';
import 'package:url_launcher/url_launcher.dart';

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
  //Las configuraciones están divididas según al organismo u
  //organismos a los que afecta, es decir, si
  //una configuración solo afecta al metro,
  //entonces su grupo será: STC Metro. Si la configuración
  //afecta globalmente, es decir, afecta a todos, entonces
  //su grupo será: Movilidad Integrada y MOVIMEX

  //------ Opción: Apariencia ------
  MenuItem(
    title: Text("APARIENCIA", style: AppTheme.metroStyle),
    subtitle: Text(
      "Cambia entre el modo claro y \nobscuro.",
      style: AppTheme.nunitoFamilySubtitle,
    ),
    icon: const AppearanceIcon(),
  ),
  //------
  // ------ Opción: Estaciones ------
  MenuItem(
    title: Text("ESTACIONES", style: AppTheme.metroStyle),
    subtitle: Text(
      "Configura el como aparecen las \nestaciones en la aplicación.",
      style: AppTheme.nunitoFamilySubtitle,
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
            final dynamicStyle = AppTheme.nunitoFamilySubtitle.copyWith(
              color: dynamicColor,
            );

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Grupo: Movilidad Integrada y MOVIMEX
                Text("Movilidad Integrada y MOVIMEX", style: dynamicStyle),
                Divider(color: dynamicColor, thickness: 1, height: 8),
                ValueListenableBuilder<bool>(
                  valueListenable:
                      PreferencesService.willBeShowedLineNamesInMessage,
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

                //Espacio entre configuraciones
                SizedBox(height: 20),

                // Grupo: STC Metro
                Text("STC Metro", style: dynamicStyle),
                Divider(color: dynamicColor, thickness: 1, height: 8),
                ValueListenableBuilder<bool>(
                  valueListenable:
                      PreferencesService.willBeShowedInstitutionsName,
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
          },
        ),
      ),
    ),
  ),
  // ------
  // ------ Opción: Mensajes ------
  MenuItem(
    title: Text("MENSAJES", style: AppTheme.metroStyle),
    subtitle: Text(
      "Personaliza el mensaje que \nenviarás a tus contactos.",
      style: AppTheme.nunitoFamilySubtitle,
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
            final dynamicStyle = AppTheme.nunitoFamilySubtitle.copyWith(
              color: dynamicColor,
            );

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Grupo: Movilidad Integrada y MOVIMEX
                // Switch Reactivo
                Text("Movilidad Integrada y MOVIMEX", style: dynamicStyle),
                Divider(color: dynamicColor, thickness: 1, height: 8),
                ValueListenableBuilder<bool>(
                  valueListenable: PreferencesService.willBeShowedTransportName,
                  builder: (context, value, _) => SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      "Mostrar nombre del transporte",
                      style: dynamicStyle,
                    ),
                    subtitle: Text(
                      "P.ej.: Ya estoy en la estación del Metro: Velódromo",
                      style: dynamicStyle.copyWith(fontSize: 12),
                    ),
                    value: value,
                    onChanged: PreferencesService.showTransportName,
                    activeThumbColor: const Color(0xFFF26400),
                  ),
                ),

                //Espacio entre configuraciones
                SizedBox(height: 20),

                // Grupo: Cuerpo del mensaje
                // TextField Varchar
                Text("Cuerpo del Mensaje", style: dynamicStyle),
                Divider(color: dynamicColor, thickness: 1, height: 8),
                SizedBox(height: 2),
                _MessageBodyField(style: dynamicStyle),

                //Espacio entre configuraciones
                SizedBox(height: 20),

                //Grupo: Aplicación usada para el envío del mensaje
                Text(
                  "Aplicación usada para el envío del mensaje",
                  style: dynamicStyle,
                ),
                Divider(color: dynamicColor, thickness: 1, height: 8),
                ValueListenableBuilder<String>(
                  valueListenable:
                      PreferencesService.whatMessagingAppYouWillUse,
                  builder: (context, value, _) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text('Enviar mensaje por', style: dynamicStyle),
                    trailing: DropdownButton<String>(
                      value: value,
                      dropdownColor:
                          Theme.of(context).brightness == Brightness.dark
                          ? const Color(0xFF1E1E1E)
                          : Colors.white,
                      style: dynamicStyle.copyWith(color: Color(0xFFF26400)),
                      underline: const SizedBox(),
                      icon: Icon(
                        Icons.keyboard_arrow_down,
                        color: dynamicColor,
                      ),
                      items: const [
                        DropdownMenuItem(value: "SMS", child: Text("SMS")),
                        DropdownMenuItem(
                          value: "WhatsApp",
                          child: Text("WhatsApp"),
                        ),
                        DropdownMenuItem(value: "Otros", child: Text("Otros")),
                      ],
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          PreferencesService.setDefaultMessagingApp(newValue);
                        }
                      },
                    ),
                  ),
                ),

                //Espacio entre configuraciones
                SizedBox(height: 20),

                // Grupo: Historial
                Text('Historial', style: dynamicStyle),
                Divider(color: dynamicColor, thickness: 1, height: 8),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text("Borrar el historial", style: dynamicStyle),
                  leading: Icon(Icons.delete_outline, color: dynamicColor),
                  onTap: () async {
                    if (PreferencesService.historyList.value.isEmpty) {
                      showPlatformDialog(
                        context: context,
                        title: 'No puedes borrar el historial',
                        content: 'Aún no has anunciado tu llegada',
                        actions: [PlatformDialogAction(text: 'Aceptar')],
                      );
                      return;
                    }
                    showPlatformDialog(
                      context: context,
                      title: '¿Borrarás el historial de tus mensajes?',
                      content: 'Si lo haces no podrás recuperarlos',
                      actions: [
                        PlatformDialogAction(text: 'Rechazar'),
                        PlatformDialogAction(
                          text: 'Continuar',
                          onPressed: () {
                            PreferencesService.deleteHistory();
                          },
                        ),
                      ],
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    ),
  ),
  //------
  // ------ Opción: Contacto y código ------
  MenuItem(
    title: Text('CONTACTO', style: AppTheme.metroStyle),
    subtitle: Text(
      'Manda sugerencias y reporta \nerrores, o conoce el código \nde la aplicación',
      style: AppTheme.nunitoFamilySubtitle,
    ),
    icon: SvgPicture.asset(
      'assets/icons/config_icons/contacto.svg',
      fit: BoxFit.contain,
    ),
    showedConfigurations: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Material(
        type: MaterialType.transparency,
        child: Builder(
          builder: (context) {
            // Colores del app Theme.
            final dynamicColor = Theme.of(context).textTheme.bodyMedium?.color;
            final dynamicStyle = AppTheme.nunitoFamilySubtitle.copyWith(
              color: dynamicColor,
            );

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Grupo: Aplicación
                Text("Aplicación", style: dynamicStyle),
                Divider(color: dynamicColor, thickness: 1, height: 8),

                //Mandar correo
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    "Contactar por correo para sugerir o reportar errores",
                    style: dynamicStyle,
                  ),
                  leading: Icon(
                    Icons.mail_outline_rounded,
                    color: dynamicColor,
                  ),
                  onTap: () async {
                    final Uri emailLaunchUri = Uri(
                      scheme: 'mailto',
                      path: 'rmdeveloper08@gmail.com',
                      query:
                          'subject=${Uri.encodeComponent('Sugerencia/Reporte - Anuncia Mi Llegada')}',
                    );

                    if (await canLaunchUrl(emailLaunchUri)) {
                      await launchUrl(emailLaunchUri);
                    } else {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'No se encontró una aplicación de correo instalada.',
                            ),
                          ),
                        );
                      }
                    }
                  },
                ),
                //---------------------

                //Mandar a la página de github
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    "Ir al Github de la app",
                    style: dynamicStyle,
                  ),
                  leading: Icon(Icons.code_outlined, color: dynamicColor),
                  onTap: () async {
                    final Uri webUri = Uri.parse(
                      'https://github.com/rafael-mex/anuncia-mi-llegada',
                    );

                    if (await canLaunchUrl(webUri)) {
                      await launchUrl(
                        webUri,
                        mode: LaunchMode.externalApplication,
                      );
                    } else {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('No se pudo abrir el enlace.'),
                          ),
                        );
                      }
                    }
                  },
                ),
                //------------------------------
              ],
            );
          },
        ),
      ),
    ),
  ),
];

class _MessageBodyField extends StatefulWidget {
  const _MessageBodyField({required this.style});

  final TextStyle style;

  @override
  State<_MessageBodyField> createState() => _MessageBodyFieldState();
}

class _MessageBodyFieldState extends State<_MessageBodyField> {
  late final TextEditingController _controller = TextEditingController(
    text: PreferencesService.messageBody.value,
  );
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_rebuild);
    _focusNode.addListener(_rebuild);
    //Sincroniza el campo si la preferencia cambia desde fuera
    //(p.ej.: al restablecer configuraciones):
    PreferencesService.messageBody.addListener(_syncFromPreference);
  }

  void _syncFromPreference() {
    final value = PreferencesService.messageBody.value;
    if (_controller.text != value) {
      _controller.value = TextEditingValue(
        text: value,
        selection: TextSelection.collapsed(offset: value.length),
      );
    }
  }

  void _rebuild() {
    if (mounted) setState(() {});
  }

  //Ancho del texto actual (o de la pista si está vacío)
  double get _lineWidth {
    final text = _controller.text.isEmpty
        ? 'Cuerpo del mensaje'
        : _controller.text;
    final painter = TextPainter(
      text: TextSpan(text: text, style: widget.style),
      textDirection: Directionality.of(context),
    )..layout();
    return painter.width;
  }

  @override
  void dispose() {
    _controller.removeListener(_rebuild);
    _focusNode.removeListener(_rebuild);
    PreferencesService.messageBody.removeListener(_syncFromPreference);
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            maxLength: 60,
            controller: _controller,
            focusNode: _focusNode,
            onChanged: PreferencesService.setYourCustomMessage,
            style: widget.style,
            decoration: const InputDecoration(
              hintText: 'Cuerpo del mensaje',
              counterText: '',
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              isDense: true,
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            height: 1,
            width: _lineWidth,
            color: _focusNode.hasFocus ? const Color(0xFFF26400) : Colors.grey,
          ),
          //Contador por defecto de Flutter:
          const SizedBox(height: 2),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              '${_controller.text.length}/60',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}

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
          builder: (context, isTrueDark, _) => /* Animación del icono:*/
              LightDarkThemeToggle(
                value: !isTrueDark,
                onChanged: (value) =>
                    (PreferencesService.isTrueDarkMode.value = !value),
                themeIconType: ThemeIconType.classic,
                color: Colors.white,
                size: 41,
              ),
        ),
        //------
      ],
    );
  }
}
