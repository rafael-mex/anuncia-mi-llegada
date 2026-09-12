import 'package:anuncia_mi_llegada/presentation/screens/screens.dart';
import 'package:anuncia_mi_llegada/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class HistoryButton extends StatelessWidget {
  const HistoryButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isTrueDarkMode,
      builder: (context, isDark, _) {
        final assetPath = isDark
            ? 'assets/icons/history_icons/history_button_dark.svg'
            : 'assets/icons/history_icons/history_button.svg';
        return AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: isDark
                ? Colors.transparent
                : Colors.white.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              focusColor: Colors.transparent,
              hoverColor: Colors.transparent,
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                context.pushNamed(HistoryScreen.name);
              },
              child: Center(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  child: SvgPicture.asset(
                    assetPath,
                    key: ValueKey<String>(assetPath),
                    width: 24,
                    height: 24,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
