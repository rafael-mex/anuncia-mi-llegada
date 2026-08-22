import 'package:anuncia_mi_llegada/config/menu/settings_items.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SettingsScreen extends StatelessWidget {
  static const name = 'settings_screen';

  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          //Gear Icon for Light Mode
          Positioned(
            left: 0,
            right: 0,
            top: 100,
            child: Center(
              child: Image(
                image: AssetImage('assets/icons/config_icons/gear_white.png'),
                width: 104,
                height: 104,
              ),
            ),
          ),
          //Keyboard Return button
          Positioned(
            left: 19,
            top: 128,
            child: IconButton(
              onPressed: () {
                context.pop();
              },
              style: ButtonStyle(
                iconSize: WidgetStatePropertyAll(24),
                iconColor: WidgetStatePropertyAll(
                  Color.fromRGBO(224, 114, 45, 100),
                ),
              ),
              icon: Icon(Icons.keyboard_return_outlined),
            ),
          ),
          //Options
          _SettingsView(),
        ],
      ),
    );
  }
}

class _SettingsView extends StatelessWidget {
  const _SettingsView();

  @override
  Widget build(BuildContext context) {
    appSettingsItems;

    return Positioned.fill(
      child: Center(
        child: ListView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          itemCount: appSettingsItems.length,
          itemBuilder: (BuildContext context, int index) {
            final menuItem = appSettingsItems[index];

            return _CustomListTitle(menuItem: menuItem);
          },
        ),
      ),
    );
  }
}

class _CustomListTitle extends StatelessWidget {
  const _CustomListTitle({required this.menuItem});

  final MenuItem menuItem;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return InkWell(
      onTap: () {
        if (menuItem.icon is AppearanceIcon) {
          appearanceMode.value = !appearanceMode.value;
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Row(
          children: [
            SizedBox(
              width: 70,
              height: 100,
              child: menuItem.icon,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  menuItem.title,
                  menuItem.subtitle,
                ],
              ),
            ),
            if (menuItem.icon is! AppearanceIcon)
              Icon(Icons.arrow_forward_ios_rounded, color: colors.primary),
          ],
        ),
      ),
    );
  }
}
