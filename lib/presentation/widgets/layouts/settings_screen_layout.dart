import 'package:anuncia_mi_llegada/presentation/widgets/icons/gear_icon.dart';
import 'package:anuncia_mi_llegada/presentation/widgets/shared/shared_buttons/keyboard_return_button.dart';
import 'package:flutter/material.dart';

class SettingsScreenLayout extends StatelessWidget {
  const SettingsScreenLayout({
    super.key,
    required this.version, 
    required this.settingsView,
  });

  final String version;
  final Widget settingsView;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
    child: Column(
      children: [
        const SizedBox(height: 40),
        Stack(
          children: [
            Center(child: GearIcon()),
            //Keyboard Return Button
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 28, top: 20),
              child: KeyboardReturnButton(),
            ),
          ),
          ],
        ),
        const SizedBox(height: 20),
        //Opciones
          Expanded(child: settingsView),
      ],
    )
  );
  }
}