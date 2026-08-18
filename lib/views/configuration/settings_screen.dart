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
            top: 115,
            child: Center(
              child: Image(
                image: AssetImage('assets/icons/config_icons/gear_white.png'),
                width: 104,
                height: 104,
              ),
            ),
          ),
          //Back button
          Positioned(
            left: 19,
            top: 150,
            child: IconButton(
              onPressed: () {
                context.pop();
              },
              style: ButtonStyle(
                iconSize: WidgetStatePropertyAll(24),
                iconColor: WidgetStatePropertyAll(Color.fromRGBO(224, 114, 45, 100)),
              ),
              icon: Icon(Icons.keyboard_return_outlined),
            ),
          ),
        ],
      ),
    );
  }
}
