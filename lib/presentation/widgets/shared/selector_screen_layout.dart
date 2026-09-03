import 'package:anuncia_mi_llegada/presentation/widgets/icons/map_icon.dart';
import 'package:flutter/material.dart';
import 'buttons/return_button.dart';
import 'buttons/record_button.dart';
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
    return Stack(
      children: [
        //MapIcon
        Positioned(
          left: 0,
          right: 0,
          top: 108,
          child: const Center(child: MapIcon()),
        ),
        //------------
        
        //RecordButton
        Positioned(
          right: 38,
          top: 136,
          child: const RecordButton(),
        ),
        //------------
        
        //SelectorWidget 
        Positioned.fill(
          child: SafeArea(
            child: Center(child: selector),
          ),
        ),
        //------------
        
        //ReturnButton
        Positioned(
          left: 0,
          right: 0,
          top: 690,
          child: Center(
            child: IgnorePointer(
              ignoring: !showReturnButton,
              child: AnimatedOpacity(
                opacity: showReturnButton ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: ReturnButton(onTap: onReturnTap),
              ),
            ),
          ),
        ),
        //------------
        
        //SettingsButton
        Positioned(
          left: 0,
          right: 0,
          top: 760,
          child: const Center(child: SettingsButton()),
        ),
        //------------
      ],
    );
  }
}
