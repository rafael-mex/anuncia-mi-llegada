import 'package:anuncia_mi_llegada/config/connectivity/connectivity_service.dart';
import 'package:anuncia_mi_llegada/config/menu/custom_location_items.dart';
import 'package:anuncia_mi_llegada/presentation/widgets/layouts/custom_location_screen_layout.dart';
import 'package:anuncia_mi_llegada/theme/app_theme.dart';
import 'package:flutter/material.dart';

class CustomLocationScreen extends StatelessWidget {
  static const name = 'custom_location_screen';

  const CustomLocationScreen({super.key});

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
            child: CustomLocationScreenLayout(
              customLocationOptions: Center(child: const _CustomLocationItemsView()),
            ),
          );
        },
      ),
    );
  }
}

class _CustomLocationItemsView extends StatelessWidget {
  const _CustomLocationItemsView();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: appCustomLocationItems.length,
      itemBuilder: (BuildContext context, int index) {
        final menuItem = appCustomLocationItems[index];

        return _CustomListTitle(menuItem: menuItem);
      },
    );
  }
}

class _CustomListTitle extends StatelessWidget {
  const _CustomListTitle({required this.menuItem});

  final MenuItem menuItem;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: ConnectivityService.isOnline,
      builder: (context, isOnline, _) {
        final disabled = menuItem.requiresNetwork && !isOnline;
        final onTap = disabled
            ? null
            : menuItem.onTap == null
                ? null
                : () => menuItem.onTap!(context);

        return Column(
          children: [
            InkWell(
              onTap: onTap,
              child: Opacity(
                opacity: disabled ? 0.4 : 1.0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 12.0,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(width: 70, height: 90, child: menuItem.icon),
                      SizedBox(
                        width: MediaQuery.sizeOf(context).width * 0.08,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            menuItem.title, menuItem.widget,
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

