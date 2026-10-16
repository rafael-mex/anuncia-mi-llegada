// import 'dart:async';
import 'package:anuncia_mi_llegada/theme/app_theme.dart';
import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';

class NewScreenTemplate extends StatelessWidget {

  static const name = '';

  const NewScreenTemplate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Implementación del backgroundColor
      backgroundColor: Colors.transparent,
      body: ValueListenableBuilder<ThemeMode>(
        valueListenable: isTrueDarkMode,
        builder: (context, themeMode, _) {
          final isDark = Theme.of(context).brightness == Brightness.dark;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            decoration: BoxDecoration(
              color: isDark ? null : AppTheme.backgroundColorLM,
              gradient: isDark ? AppTheme.backgroundColorDM : null,
            ),
            //-------------------------------------
          );
        },
      ),
    );
  }
}