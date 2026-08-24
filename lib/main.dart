import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'config/router/app_router.dart';
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const AnunciaMiLlegadaApp());
}

class AnunciaMiLlegadaApp extends StatelessWidget {
  const AnunciaMiLlegadaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isTrueDarkMode,
      builder: (context, isDark, _) {
        return MaterialApp.router(
          title: 'Anuncia Mi Llegada',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
          themeAnimationDuration: const Duration(milliseconds: 500), 
          routerConfig: appRouter,
        );
      },
    );
  }
}
