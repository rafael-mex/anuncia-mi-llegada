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
      body: ValueListenableBuilder<bool>(
        valueListenable: isTrueDarkMode,
        builder: (context, isDark, _) => AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            color: isDark ? null : AppTheme.backgroundColorLM,
            gradient: isDark ? AppTheme.backgroundColorDM : null,
          ),

          //-------------------------------------
          child: CustomLocationScreenLayout(
            customLocationOptions: const _CustomLocationItemsView(),
          ),
        ),
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
    return Column(
      children: [
        InkWell(
          onTap: menuItem.onTap == null ? null : () => menuItem.onTap!(context),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 14.0,
              vertical: 12.0,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(width: 70, height: 120, child: menuItem.icon),
                SizedBox(width: MediaQuery.sizeOf(context).width * 0.06),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [menuItem.title],
                  ),
                ),
              ],
            ),
          ),
        ),
        if (menuItem.manualUbication != null) menuItem.manualUbication!,
      ],
    );
  }
}
