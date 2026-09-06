import 'package:flutter/material.dart';
import '../icons/map_icon.dart';
import '../shared/buttons/history_button.dart';
import '../shared/buttons/return_button.dart';
import '../shared/buttons/settings_button.dart';

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
              //MapIcon
              const Center(child: MapIcon()),
              //-------

              //History Button
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 38),
                  child: HistoryButton()
                ),
              ),
              //--------------
            ],
          ),
          const Spacer(),

          //Selector Widget
          selector,
          //--------------

          const Spacer(),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              //Return Button
              IgnorePointer(
                ignoring: !showReturnButton,
                child: AnimatedOpacity(
                  opacity: showReturnButton ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  child: ReturnButton(onTap: onReturnTap),
                ),
              ),
              //--------------
              const SizedBox(height: 20),

              //Settings Button
              const SettingsButton(),
              //---------------
            ],
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
