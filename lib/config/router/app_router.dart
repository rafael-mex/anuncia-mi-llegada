import 'package:go_router/go_router.dart';
import 'package:anuncia_mi_llegada/features/splash/presentation/pages/splash_page.dart';
import 'package:anuncia_mi_llegada/features/transports/presentation/pages/transports_screen.dart';
import 'package:anuncia_mi_llegada/views/configuration/settings_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      name: 'splash',
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: '/',
      name: TransportsScreen.name,
      builder: (context, state) => const TransportsScreen(),
    ),
    GoRoute(
      path: '/settings',
      name: SettingsScreen.name,
      builder: (context, state) => const SettingsScreen(),
    ),
  ],
);
