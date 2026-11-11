import 'package:anuncia_mi_llegada/config/connectivity/connectivity_service.dart';
import 'package:anuncia_mi_llegada/config/preferences/preferences_service.dart';
import 'package:anuncia_mi_llegada/theme/app_theme.dart';
import 'package:anuncia_mi_llegada/utils/platform_dialog_helper.dart';
import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
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
  /*
    Las configuraciones están divididas según al organismo u
    organismos a los que afecta, es decir, si
    una configuración solo afecta al metro,
    entonces su grupo será: STC Metro. Si la configuración
    afecta globalmente (afecta a todos), entonces
    su grupo será: Movilidad Integrada y MOVIMEX

    En el caso de afectar a un elemento de la aplicación, el 
    nombre que recibirá su grupo va a ser el del elemento al que afecta.
  */

  //------ Sección: Aplicación ------
  MenuItem(
    title: Text("APLICACIÓN", style: AppTheme.metroStyle),
    subtitle: Text(
      "Modifica el aspecto y algunas de \nlas funciones de la app.",
      style: AppTheme.nunitoFamilySubtitle,
    ),
    icon: const AppIcon(),
    //Configuraciones de la sección:
    showedConfigurations: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Material(
        type: MaterialType.transparency,
        child: Builder(
          builder: (context) {
            final dynamicColor = Theme.of(context).textTheme.bodyMedium?.color;
            final dynamicStyle = AppTheme.nunitoFamilySubtitle.copyWith(
              color: dynamicColor,
            );
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Grupo: Apariencia
                Text("Apariencia", style: dynamicStyle),
                Divider(color: dynamicColor, thickness: 1, height: 8),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.center,
                  child: _ThemeSegmentedControl(),
                ),
                //------------------

                //Espacio entre grupos
                const SizedBox(height: 20),

                //Grupo: Icono de la sección
                Text("Icono de la sección", style: dynamicStyle),
                Divider(color: dynamicColor, thickness: 1, height: 8),

                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: _IconOption(
                        label: 'Dinámico',
                        icon: const AppearanceIcon(toggleOnTap: false),
                        isSelected: true,
                        onTap: () =>
                            PreferencesService.showDynamicIcon.value = true,
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Opción 2: Estático
                    Expanded(
                      child: _IconOption(
                        label: 'Estático',
                        icon: SvgPicture.asset(
                          'assets/icons/config_icons/aplicacion.svg',
                          width: 66,
                          height: 66,
                          fit: BoxFit.contain,
                        ),
                        isSelected: false,
                        onTap: () =>
                            PreferencesService.showDynamicIcon.value = false,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                //--------------------------------

                //Espacio entre grupos
                const SizedBox(height: 20),

                //Grupo: Localización
                Text("Localización", style: dynamicStyle),
                Divider(color: dynamicColor, thickness: 1, height: 8),
                ValueListenableBuilder<bool>(
                  valueListenable: PreferencesService.detectNearbyStation,
                  builder: (context, value, _) => _AdaptiveSwitchTile(
                    title: Text(
                      "Detectar estacion cercana al enviar\nla ubicacion",
                      style: dynamicStyle,
                    ),
                    value: value,
                    onChanged: PreferencesService.setDetectNearbyStation,
                  ),
                ),
                //--------------------------------
              ],
            );
          },
        ),
      ),
    ),
  ),
  //------

  // ------ Sección: Estaciones ------
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
    //Configuraciones de la sección:

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
            //------------------------------

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Grupo: Movilidad Integrada y MOVIMEX
                Text("Movilidad Integrada y MOVIMEX", style: dynamicStyle),
                Divider(color: dynamicColor, thickness: 1, height: 8),
                ValueListenableBuilder<bool>(
                  valueListenable:
                      PreferencesService.willBeShowedLineNamesInMessage,
                  builder: (context, value, _) => _AdaptiveSwitchTile(
                    title: Text(
                      "Mostrar sugerencia de nombrar \nsolo la línea escogida",
                      style: dynamicStyle,
                    ),

                    value: value,
                    onChanged: PreferencesService.showLineNamesInMessage,
                  ),
                ),
                /* Separación: */ const SizedBox(height: 12),
                //------------------------------

                //Espacio entre configuraciones
                SizedBox(height: 20),

                // Grupo: STC Metro
                Text("STC Metro", style: dynamicStyle),
                Divider(color: dynamicColor, thickness: 1, height: 8),
                ValueListenableBuilder<bool>(
                  valueListenable:
                      PreferencesService.willBeShowedInstitutionsName,
                  builder: (context, value, _) => _AdaptiveSwitchTile(
                    //Texto y estilo
                    title: Text(
                      "Mostrar instituciones\nacompañadas de nombres de estaciones",
                      style: dynamicStyle,
                    ),

                    value: value,
                    onChanged: PreferencesService.showInstitutionsName,
                  ),
                ),

                //------------------------------
              ],
            );
          },
        ),
      ),
    ),
  ),
  // ------

  // ------ Sección: Mensajes ------
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
    //--------

    //Configuraciones de la sección:
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
            //-------------------------

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Grupo: Movilidad Integrada y MOVIMEX

                // Switch Reactivo
                Text("Movilidad Integrada y MOVIMEX", style: dynamicStyle),
                Divider(color: dynamicColor, thickness: 1, height: 8),
                ValueListenableBuilder<bool>(
                  valueListenable: PreferencesService.willBeShowedTransportName,
                  builder: (context, value, _) => _AdaptiveSwitchTile(
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
                  ),
                ),
                //-------------------------------------

                //Espacio entre configuraciones
                SizedBox(height: 20),

                // Grupo: Cuerpo del mensaje

                // TextField Varchar
                Text("Cuerpo del Mensaje", style: dynamicStyle),
                Divider(color: dynamicColor, thickness: 1, height: 8),
                SizedBox(height: 2),
                _MessageBodyField(style: dynamicStyle),
                //------------------------------

                //Espacio entre configuraciones
                SizedBox(height: 20),

                //Grupo: Aplicación usada para el envío del mensaje

                //Menú de selección de la app de mensajería.
                Text(
                  "Aplicación usada para el envío del mensaje",
                  style: dynamicStyle,
                ),
                Divider(color: dynamicColor, thickness: 1, height: 8),
                _MessagingAppSelector(style: dynamicStyle),

                //---------------------------------------

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
                        PlatformDialogAction(text: 'Rechazar', isCancel: true),
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

                //------------------------------------
              ],
            );
          },
        ),
      ),
    ),
  ),
  //------

  // ------ Sección: Información y Contacto ------
  MenuItem(
    title: Text(
      'INFORMACIÓN Y CONTACTO',
      style: AppTheme.metroStyle.copyWith(fontSize: 19),
    ),
    subtitle: Text(
      'Da sugerencias, reporta errores o \nconoce el código de la aplicación',
      style: AppTheme.nunitoFamilySubtitle,
    ),
    icon: SvgPicture.asset(
      'assets/icons/config_icons/contacto.svg',
      fit: BoxFit.contain,
    ),

    //Configuraciones de la sección:
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
            //------------------------------

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Grupo: Aplicación
                Text("Aplicación", style: dynamicStyle),
                Divider(color: dynamicColor, thickness: 1, height: 8),
                //------------------------------

                //Mandar correo
                ValueListenableBuilder<bool>(
                  valueListenable: ConnectivityService.isOnline,
                  builder: (context, isOnline, _) {
                    final disabled = !isOnline;
                    return InkWell(
                      onTap: disabled
                          ? null
                          : () async {
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
                      child: Opacity(
                        opacity: disabled ? 0.4 : 1.0,
                        child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(
                            "Contactar por correo",
                            style: dynamicStyle,
                          ),
                          leading: Icon(
                            Icons.mail_outline_rounded,
                            color: dynamicColor,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                //---------------------

                //Mandar a la página de github
                ValueListenableBuilder<bool>(
                  valueListenable: ConnectivityService.isOnline,
                  builder: (context, isOnline, _) {
                    final disabled = !isOnline;
                    return InkWell(
                      onTap: disabled
                          ? null
                          : () async {
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
                                      content: Text(
                                        'No se pudo abrir el enlace.',
                                      ),
                                    ),
                                  );
                                }
                              }
                            },
                      child: Opacity(
                        opacity: disabled ? 0.4 : 1.0,
                        child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(
                            "Ir al Github de la app",
                            style: dynamicStyle,
                          ),
                          leading: Icon(
                            Icons.code_outlined,
                            color: dynamicColor,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                //------------------------------

                //Sección del creador :D :
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                  'Creador de la aplicación: \nMex Lozano Rafael Emilio',
                  style: dynamicStyle.copyWith(color: Color(0xFFF69346)),
                  ),
                  leading: SvgPicture.asset(
                    'assets/icons/config_icons/mi_pfp.svg',
                    width: 40,
                  ),                
                )

                //------------------------
              ],
            );
          },
        ),
      ),
    ),
  ),
];
//------------------------------

//--------------- Cuerpo del mensaje ---------------
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
//------------------------------

//---- Selector de la app de mensajería ----
class _MessagingAppSelector extends StatefulWidget {
  final TextStyle style;

  const _MessagingAppSelector({required this.style});

  @override
  State<_MessagingAppSelector> createState() => _MessagingAppSelectorState();
}

//Opción del selector: Valor y el icono que lo representa.
class _MessagingAppOption {
  final String value;
  final IconData icon;

  const _MessagingAppOption(this.value, this.icon);
}
//------------------------------

class _MessagingAppSelectorState extends State<_MessagingAppSelector> {
  static const _apps = <_MessagingAppOption>[
    _MessagingAppOption(
      PreferencesService.messagingAppSms,
      Icons.chat_bubble_outline,
    ),
    _MessagingAppOption(PreferencesService.messagingAppWhatsApp, Icons.phone),
    _MessagingAppOption(PreferencesService.messagingAppAny, Icons.ios_share),
  ];

  static final Color _metroColor = AppTheme.metroStyle.color!;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: PreferencesService.whatMessagingAppYouWillUse,
      builder: (context, value, _) {
        return ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text('Enviar mensaje por', style: widget.style),
          trailing: AdaptivePopupMenuButton.widget<String>(
            items: [
              for (final app in _apps)
                AdaptivePopupMenuItem<String>(
                  label: app.value,
                  icon: app.icon,
                  selected: value == app.value,
                  value: app.value,
                ),
            ],
            onSelected: (_, item) {
              final selectedApp = item.value;
              if (selectedApp != null) {
                PreferencesService.setDefaultMessagingApp(selectedApp);
              }
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Text(
                      value,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: widget.style.copyWith(color: _metroColor),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 18,
                    color: _metroColor,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
//------------------------------

// Fila de ajuste con el interruptor nativo de cada plataforma:
// iOS 26+ usa UISwitch nativo; iOS antiguo, CupertinoSwitch; Android, Material.
class _AdaptiveSwitchTile extends StatelessWidget {
  const _AdaptiveSwitchTile({
    required this.title,
    required this.value,
    required this.onChanged,
    this.subtitle,
  });

  final Widget title;
  final Widget? subtitle;
  final bool value;
  final ValueChanged<bool>? onChanged;

  static const Color _accentColor = Color(0xFFF26400);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: title,
      subtitle: subtitle,
      trailing: AdaptiveSwitch(
        value: value,
        onChanged: onChanged,
        activeColor: _accentColor,
      ),
      // Conserva el mismo comportamiento que SwitchListTile: toda la fila
      // responde al toque, no solo el interruptor.
      onTap: onChanged == null ? null : () => onChanged!(!value),
    );
  }
}

//Icono de la sección de apariencia y su animación al cambiar entre modos:
class AppearanceIcon extends StatelessWidget {

  final bool toggleOnTap;

  const AppearanceIcon({super.key,  this.toggleOnTap = true});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        //Icon
        SvgPicture.asset(
          'assets/icons/config_icons/apariencia.svg',
          width: 66,
          height: 66,
          fit: BoxFit.contain,
        ),

        ValueListenableBuilder<ThemeMode>(
          valueListenable: PreferencesService.isTrueDarkMode,
          builder: (context, themeMode, _) {
            final isDark = themeMode == ThemeMode.dark ||
                (themeMode == ThemeMode.system &&
                    Theme.of(context).brightness == Brightness.dark);
            return IgnorePointer(
              ignoring: !toggleOnTap,
              child: /* Animación del icono:*/
                  LightDarkThemeToggle(
                value: isDark,
                onChanged: (value) =>
                    (PreferencesService.isTrueDarkMode.value =
                        value ? ThemeMode.dark : ThemeMode.light),
                themeIconType: ThemeIconType.classic,
                color: Colors.white,
                size: 41,
              ),
            );
          },
        ),
        //------
      ],
    );
  }
}

//------------------------------

// Selector de icono de la sección de Aplicación:
class _IconOption extends StatelessWidget {
  final String label;
  final Widget icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _IconOption({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: PreferencesService.showDynamicIcon,
      builder: (context, showDynamic, _) {
        final selected = isSelected ? showDynamic : !showDynamic;
        return InkWell(
          onTap: onTap,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: selected
                      ? const Color(0xFFF26400).withValues(alpha: 0.15)
                      : null,
                  border: Border.all(
                    color: selected
                        ? const Color(0xFFF26400)
                        : Colors.transparent,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: icon,
              ),
              const SizedBox(height: 6),
              Text(
                label,
                style: TextStyle(
                  color: selected ? const Color(0xFFF26400) : null,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
//---------------------------------

// ------ Ícono de la sección Aplicación ------
class AppIcon extends StatelessWidget {
  const AppIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: PreferencesService.showDynamicIcon,
      builder: (context, showDynamic, _) {
        return showDynamic
            ? const AppearanceIcon(toggleOnTap: true)
            : SvgPicture.asset(
                'assets/icons/config_icons/aplicacion.svg',
                width: 66,
                height: 66,
                fit: BoxFit.contain,
              );
      },
    );
  }
}
//---------------------------------------------

//Selector de tema: Claro | Oscuro | Sistema
class _ThemeSegmentedControl extends StatelessWidget {
  const _ThemeSegmentedControl();

  static const Map<int, ThemeMode> _options = {
    0: ThemeMode.light,
    1: ThemeMode.dark,
    2: ThemeMode.system,
  };

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: PreferencesService.isTrueDarkMode,
      builder: (context, currentMode, _) {
        final isDark =
            currentMode == ThemeMode.dark ||
            (currentMode == ThemeMode.system &&
                Theme.of(context).brightness == Brightness.dark);
        final int selected = _options.entries
            .firstWhere(
              (e) => e.value == currentMode,
              orElse: () => const MapEntry(2, ThemeMode.system),
            )
            .key;

        return AdaptiveSegmentedControl(
          labels: const ['Claro', 'Oscuro', 'Sistema'],
          selectedIndex: selected,
          onValueChanged: (index) {
            PreferencesService.isTrueDarkMode.value = _options[index]!;
          },
          color: isDark ? const Color(0xFFF26400) : const Color(0xFFF69346),
          selectedTextColor: Colors.white,
          height: 36,
          shrinkWrap: true,
        );
      },
    );
  }
}
//------------------------------
