import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import '../../screens/screens.dart';

class SettingsButton extends StatelessWidget {
  const SettingsButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      top: 760,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            borderRadius: BorderRadius.circular(16),
            onTap: () {
              context.pushNamed(SettingsScreen.name);
            },
            child: Center(
              child: SvgPicture.asset(
                'assets/icons/config_icons/settings_Icon.svg',
                width: 24,
                height: 24,
              ),
            ),
          ),
        ),
      ),
    );
  }
}