import 'package:anuncia_mi_llegada/config/preferences/preferences_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class KeyboardReturnButton extends StatelessWidget {
  const KeyboardReturnButton({super.key, 
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: PreferencesService.isTrueDarkMode,
      builder: (context, themeMode, _) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return IconButton(
          onPressed: () {
            context.pop();
          },
          style: ButtonStyle(
            iconSize: WidgetStatePropertyAll(24),
            iconColor: WidgetStatePropertyAll(
              isDark
                  ? Color(0xFFBD7E52)
                  : Color(0xFFF8AC72),
            ),
          ),
          icon: Icon(Icons.arrow_back_ios_new_outlined, size: 38),
        );
      },
    );
  }
}