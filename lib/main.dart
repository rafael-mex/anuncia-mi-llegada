import 'package:flutter/material.dart';

import 'config/router/app_router.dart';

void main() {
  runApp(const AnunciaMiLlegadaApp());
}

class AnunciaMiLlegadaApp extends StatelessWidget {
  const AnunciaMiLlegadaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Anuncia Mi Llegada',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFF26400)),
      ),
      routerConfig: appRouter,
    );
  }
}
