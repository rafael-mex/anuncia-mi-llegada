import 'package:anuncia_mi_llegada/main.dart';
import 'package:anuncia_mi_llegada/presentation/screens/screens.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      name: 'splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/',
      name: SelectorScreen.name,
      builder: (context, state) => const SelectorScreen(),
    ),
    GoRoute(
      path: '/settings',
      name: SettingsScreen.name,
      builder: (context, state) => SettingsScreen(version: appVersion),
    ),
    GoRoute(
      path: '/history',
      name: HistoryScreen.name,
      builder: (context, state) => const HistoryScreen(),
    ),
  ],
);
