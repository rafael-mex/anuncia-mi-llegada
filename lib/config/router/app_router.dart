import 'package:anuncia_mi_llegada/main.dart';
import 'package:anuncia_mi_llegada/presentation/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

Page<void> _fadeSlidePage(Widget child) {
  return CustomTransitionPage<void>(
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curvedAnimation = CurvedAnimation(
        parent: animation,
        curve: Curves.easeInOut,
      );
      return FadeTransition(
        opacity: curvedAnimation,
        child: SlideTransition(
          position:
              Tween<Offset>(
                begin: const Offset(0, 0.015),
                end: Offset.zero,
              ).animate(curvedAnimation),
          child: child,
        ),
      );
    },
    transitionDuration: const Duration(milliseconds: 300),
  );
}


final appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      name: 'splash',
      pageBuilder: (context, state) => _fadeSlidePage(const SplashScreen()),
    ),
    GoRoute(
      path: '/',
      name: SelectorScreen.name,
      pageBuilder: (context, state) => _fadeSlidePage(const SelectorScreen()),
    ),
    GoRoute(
      path: '/settings',
      name: SettingsScreen.name,
      pageBuilder: (context, state) =>
          _fadeSlidePage(SettingsScreen(version: appVersion)),
    ),
    GoRoute(
      path: '/history',
      name: HistoryScreen.name,
      pageBuilder: (context, state) => _fadeSlidePage(const HistoryScreen()),
    ),
    GoRoute(
      path: '/custom_location',
      name: CustomLocationScreen.name,
      pageBuilder: (context, state) =>
          _fadeSlidePage(const CustomLocationScreen()),
    ),
  ],
);