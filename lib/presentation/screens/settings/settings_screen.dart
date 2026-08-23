import 'package:anuncia_mi_llegada/config/menu/settings_items.dart';
import 'package:anuncia_mi_llegada/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SettingsScreen extends StatelessWidget {
  static const name = 'settings_screen';

  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
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
          child: Stack(
            children: [
              Positioned(
                left: 0,
                right: 0,
                top: 100,
                child: Center(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    child: Image(
                      key: ValueKey<String>(
                        isDark
                            ? 'assets/icons/config_icons/gear_dark.png'
                            : 'assets/icons/config_icons/gear_white.png',
                      ),
                      image: AssetImage(
                        isDark
                            ? 'assets/icons/config_icons/gear_dark.png'
                            : 'assets/icons/config_icons/gear_white.png',
                      ),
                      width: 104,
                      height: 104,
                    ),
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
        ),
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
  Widget _withColor(Widget widget, Color color) {
    if (widget is Text && widget.data != null) {
      final baseStyle = widget.style ?? const TextStyle();
      return TweenAnimationBuilder<Color?>(
        tween: ColorTween(begin: color, end: color),
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        builder: (context, animatedColor, _) => Text(
          widget.data!,
          style: baseStyle.copyWith(color: animatedColor ?? color),
        ),
      );
    }
    return widget;
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return ValueListenableBuilder<bool>(
      valueListenable: isTrueDarkMode,
      builder: (context, isDark, _) {

        final titleColor = isDark
            ? const Color.fromRGBO(204, 204, 204, 100)
            : Colors.black;
        final subtitleColor = isDark
            ? const Color.fromRGBO(151, 145, 145, 100)
            : const Color.fromRGBO(91, 79, 79, 100);

        return InkWell(
          onTap: () {
            if (menuItem.icon is AppearanceIcon) {
              isTrueDarkMode.value = !isTrueDarkMode.value;
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 12.0,
            ),
            child: Row(
              children: [
                SizedBox(width: 70, height: 100, child: menuItem.icon),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _withColor(menuItem.title, titleColor),
                      _withColor(menuItem.subtitle, subtitleColor),
                    ],
                  ),
                ),
                if (menuItem.icon is! AppearanceIcon)
                  Icon(Icons.arrow_forward_ios_rounded, color: colors.primary),
              ],
            ),
          ),
        );
      },
    );
  }
}
