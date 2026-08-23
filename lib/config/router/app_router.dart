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
      name: TransportsScreen.name,
      builder: (context, state) => const TransportsScreen(),
    ),
    GoRoute(
      path: '/lineas',
      name: LinesScreen.name,
      builder: (context, state) => const LinesScreen(),
    ),
    GoRoute(
      path: '/estaciones',
      name: StationsScreen.name,
      builder: (context, state) => const StationsScreen(),
    ),
    GoRoute(
      path: '/settings',
      name: SettingsScreen.name,
      builder: (context, state) => const SettingsScreen(),
    ),
  ],
);
