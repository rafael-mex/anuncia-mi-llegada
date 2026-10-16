import 'package:anuncia_mi_llegada/config/preferences/preferences_service.dart';
import 'package:flutter/material.dart';

class HistoryIcon extends StatelessWidget {
  const HistoryIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: PreferencesService.isTrueDarkMode,
      builder: (context, themeMode, _) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final assetPath = isDark
            ? 'assets/icons/history_icons/history_icon_dark.png'
            : 'assets/icons/history_icons/history_icon.png';
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
