import 'package:anuncia_mi_llegada/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class RecordIcon extends StatelessWidget {
  const RecordIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isTrueDarkMode,
      builder: (context, isDark, _) {
        final assetPath = isDark
            ? 'assets/icons/record_icons/record_icon_dark.svg'
            : 'assets/icons/record_icons/record_icon.svg';
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          child: SvgPicture.asset(
            assetPath,
            key: ValueKey<String>(assetPath),
            width: 104,
            height: 104,
          ),
        );
      },
    );
  }
}
