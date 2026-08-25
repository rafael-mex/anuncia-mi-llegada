import 'package:anuncia_mi_llegada/config/menu/settings_items.dart';
import 'package:anuncia_mi_llegada/config/preferences/preferences_service.dart';
import 'package:anuncia_mi_llegada/presentation/widgets/shared/buttons/reset_button.dart';
import 'package:anuncia_mi_llegada/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SettingsScreen extends StatelessWidget {
  static const name = 'settings_screen';

  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: ValueListenableBuilder<bool>(
        valueListenable: isTrueDarkMode,
        builder: (context, isDark, _) => AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            color: isDark ? null : AppTheme.backgroundColorLM,
            gradient: isDark ? AppTheme.backgroundColorDM : null,
          ),
          child: Stack(
            children: [
              Positioned(
                left: 0,
                right: 0,
                top: 108,
                child: Center(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    child: Image(
                      key: ValueKey<String>(
                        isDark
                            ? 'assets/icons/config_icons/gear_dark.png'
                            : 'assets/icons/config_icons/gear_white.png',
                      ),
                      image: AssetImage(
                        isDark
                            ? 'assets/icons/config_icons/gear_dark.png'
                            : 'assets/icons/config_icons/gear_white.png',
                      ),
                      width: 104,
                      height: 104,
                    ),
                  ),
                ),
              ),
              //Keyboard Return button
              Positioned(
                left: 28,
                top: 126,
                child: IconButton(
                  onPressed: () {
                    context.pop();
                  },
                  style: ButtonStyle(
                    iconSize: WidgetStatePropertyAll(24),
                    iconColor: WidgetStatePropertyAll(
                      Color.fromRGBO(224, 114, 45, 100),
                    ),
                  ),
                  icon: Icon(Icons.keyboard_return_outlined, size: 38),
                ),
              ),
              //Options
              _SettingsView(),
            ],
          ),
        ),
      ),
    );
  }
}

class _ApplicationVersion extends StatelessWidget {
  const _ApplicationVersion();

  @override
  Widget build(BuildContext context) {
    return Text('Versión 0.9.0',);
  }
}

class _ResetSettingsButton extends StatelessWidget {
  const _ResetSettingsButton();

  @override
  Widget build(BuildContext context) {
    //Se reconstruye cuando cualquiera de las configuraciones cambia:
    return ListenableBuilder(
      listenable: Listenable.merge([
        PreferencesService.isTrueDarkMode,
        PreferencesService.messageBody,
        PreferencesService.willBeShowedTransportName,
        PreferencesService.willBeShowedLineNamesInMessage,
        PreferencesService.willBeShowedInstitutionsName,
      ]),
      builder: (context, _) {
        final showButton = PreferencesService.hasModifiedSettings;
        return IgnorePointer(
          ignoring: !showButton,
          child: AnimatedOpacity(
            opacity: showButton ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: const ResetButton(),
          ),
        );
      },
    );
  }
}

class _SettingsView extends StatelessWidget {
  const _SettingsView();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      top: 230,
      bottom: 0,
      child: SafeArea(
        top: false,
        //Resguardo extra para la barra de navegación del dispositivo:
        minimum: const EdgeInsets.only(bottom: 50),
        child: ListView.builder(
          padding: EdgeInsets.zero,
          //+1 para el botón de restablecer configuraciones:
          itemCount: appSettingsItems.length + 1,
          itemBuilder: (BuildContext context, int index) {
            //Botón fijo debajo de la última opción (Apariencia):
            if (index == appSettingsItems.length) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Center(child: _ResetSettingsButton()),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Center(child: _ApplicationVersion()),
                  ),
                ],
              );
            }

            final menuItem = appSettingsItems[index];
            return _CustomListTitle(menuItem: menuItem);
          },
        ),
      ),
    );
  }
}

class _CustomListTitle extends StatefulWidget {
  const _CustomListTitle({required this.menuItem});

  final MenuItem menuItem;

  @override
  State<_CustomListTitle> createState() => _CustomListTitleState();
}

class _CustomListTitleState extends State<_CustomListTitle> {
  bool _areShowedThePreferences = false;

  Widget _withColor(Widget widget, Color color) {
    if (widget is Text && widget.data != null) {
      final baseStyle = widget.style ?? const TextStyle();
      return TweenAnimationBuilder<Color?>(
        tween: ColorTween(begin: color, end: color),
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        builder: (context, animatedColor, _) => Text(
          widget.data!,
          style: baseStyle.copyWith(color: animatedColor ?? color),
        ),
      );
    }
    return widget;
  }

  @override
  Widget build(BuildContext context) {
    final theWidthOfYourScreen = MediaQuery.of(context).size.width;

    return ValueListenableBuilder<bool>(
      valueListenable: isTrueDarkMode,
      builder: (context, isDark, _) {
        final titleColor = isDark
            ? const Color.fromRGBO(204, 204, 204, 100)
            : Colors.black;
        final subtitleColor = isDark
            ? const Color.fromRGBO(151, 145, 145, 100)
            : const Color.fromRGBO(91, 79, 79, 100);

        return Column(
          children: [
            InkWell(
              onTap: () {
                if (widget.menuItem.icon is AppearanceIcon) {
                  isTrueDarkMode.value = !isTrueDarkMode.value;
                } else if (widget.menuItem.showedConfigurations != null) {
                  setState(() {
                    _areShowedThePreferences = !_areShowedThePreferences;
                  });
                }
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 12.0,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 76,
                      height: 120,
                      child: widget.menuItem.icon,
                    ),
                    SizedBox(width: theWidthOfYourScreen * 0.08),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _withColor(widget.menuItem.title, titleColor),
                          _withColor(widget.menuItem.subtitle, subtitleColor),
                        ],
                      ),
                    ),
                    if (widget.menuItem.icon is! AppearanceIcon)
                      AnimatedRotation(
                        turns: _areShowedThePreferences ? 0.25 : 0.0,
                        duration: const Duration(milliseconds: 300),
                        child: Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                  ],
                ),
              ),
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child:
                  _areShowedThePreferences &&
                      widget.menuItem.showedConfigurations != null
                  ? widget.menuItem.showedConfigurations!
                  : const SizedBox.shrink(),
            ),
          ],
        );
      },
    );
  }
}
