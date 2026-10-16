import 'package:anuncia_mi_llegada/config/preferences/preferences_service.dart';
import 'package:anuncia_mi_llegada/utils/platform_dialog_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class WifiOffButton extends StatelessWidget {
  final String textContent;

  void showOfflineDialog(BuildContext context) {
    showPlatformDialog(
      context: context,
      title: 'No tienes conexión',
      content: textContent,
      actions: [PlatformDialogAction(text: 'Aceptar')],
    );
  }

  const WifiOffButton({
    super.key, 
    required this.textContent
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: PreferencesService.isTrueDarkMode,
      builder: (context, themeMode, _) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final assetPath = isDark
            ? 'assets/icons/wifi_off/wifi_off_dark.svg'
            : 'assets/icons/wifi_off/wifi_off.svg';
        return AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          width: 48,
          height: 30,
          decoration: BoxDecoration(
            color: isDark
                ? Colors.transparent
                : Colors.white.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              focusColor: Colors.transparent,
              hoverColor: Colors.transparent,
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                showOfflineDialog(context);
              },
              child: Center(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  child: SvgPicture.asset(
                    assetPath,
                    key: ValueKey<String>(assetPath),
                    width: 25,
                    height: 28,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
