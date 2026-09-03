import 'package:flutter/material.dart';
import '../icons/map_icon.dart';
import 'buttons/record_button.dart';
import 'buttons/return_button.dart';
import 'buttons/settings_button.dart';

class SelectorScreenLayout extends StatelessWidget {
  final Widget selector;
  final bool showReturnButton;
  final VoidCallback? onReturnTap;

  const SelectorScreenLayout({
    super.key,
    required this.selector,
    this.showReturnButton = true,
    this.onReturnTap,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          const Spacer(),
          Stack(
            children: [
              const Center(child: MapIcon()),
              const Positioned(
                right: 38,
                top: 13,
                child: RecordButton(),
              ),
            ],
          ),
          const Spacer(),
          selector,
          const Spacer(),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              IgnorePointer(
                ignoring: !showReturnButton,
                child: AnimatedOpacity(
                  opacity: showReturnButton ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  child: ReturnButton(onTap: onReturnTap),
                ),
              ),
              const SizedBox(height: 20),
              const SettingsButton(),
            ],
          ),
          const Spacer(),
        ],
      ),
    );
  }
}