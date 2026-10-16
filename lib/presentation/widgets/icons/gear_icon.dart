import 'package:anuncia_mi_llegada/config/preferences/preferences_service.dart';
import 'package:flutter/material.dart';

class GearIcon extends StatelessWidget {
  const GearIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: PreferencesService.isTrueDarkMode,
      builder: (context, themeMode, _) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final assetPath = isDark
            ? 'assets/icons/config_icons/gear_dark.png'
            : 'assets/icons/config_icons/gear_white.png';
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          child: Image(
            key: ValueKey<String>(assetPath),
            image: AssetImage(assetPath),
            width: 80,
            height: 80,
          ),
        );
      },
    );
  }
}