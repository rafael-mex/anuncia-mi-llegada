import 'package:anuncia_mi_llegada/config/connectivity/connectivity_service.dart';
import 'package:anuncia_mi_llegada/theme/app_theme.dart';
import 'package:anuncia_mi_llegada/utils/platform_dialog_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import '../../../screens/screens.dart';

class SettingsButton extends StatelessWidget {
  const SettingsButton({super.key});

  void _showOfflineDialog(BuildContext context) {
    showPlatformDialog(
      context: context,
      title: 'Sin conexión a Internet',
      content: 'No hay conexión a red en este momento. Sin conexión no podrás: '
          'ubicar una estación en el mapa, usar tu ubicación actual, '
          'contactar por correo ni ir a GitHub. El resto de la aplicación '
          'sigue funcionando normalmente.',
      actions: [PlatformDialogAction(text: 'Aceptar')],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isTrueDarkMode,
      builder: (context, isDark, _) {
        final assetPath = isDark
            ? 'assets/icons/config_icons/settings_Icon_dark.svg'
            : 'assets/icons/config_icons/settings_Icon.svg';

        return Stack(
          clipBehavior: Clip.none,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.transparent
                    : Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () => context.pushNamed(SettingsScreen.name),
                  child: Center(
                    child: SvgPicture.asset(
                      assetPath,
                      key: ValueKey<String>(assetPath),
                      width: 25,
                      height: 25,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
