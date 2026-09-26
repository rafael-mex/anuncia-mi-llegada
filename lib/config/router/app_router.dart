import 'package:anuncia_mi_llegada/config/router/fade_slide_page.dart';
import 'package:anuncia_mi_llegada/main.dart';
import 'package:anuncia_mi_llegada/presentation/screens/screens.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      name: 'splash',
      pageBuilder: (context, state) =>
          const FadeSlidePage<void>(child: SplashScreen()),
    ),
    GoRoute(
      path: '/',
      name: SelectorScreen.name,
      pageBuilder: (context, state) =>
          const FadeSlidePage<void>(child: SelectorScreen()),
    ),
    GoRoute(
      path: '/settings',
      name: SettingsScreen.name,
      pageBuilder: (context, state) =>
          FadeSlidePage<void>(child: SettingsScreen(version: appVersion)),
    ),
    GoRoute(
      path: '/history',
      name: HistoryScreen.name,
      pageBuilder: (context, state) =>
          const FadeSlidePage<void>(child: HistoryScreen()),
    ),
    GoRoute(
      path: '/custom_location',
      name: CustomLocationScreen.name,
      pageBuilder: (context, state) =>
          const FadeSlidePage<void>(child: CustomLocationScreen()),
    ),
  ],
);
