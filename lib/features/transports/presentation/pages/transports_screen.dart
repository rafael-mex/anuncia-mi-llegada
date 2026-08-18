import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:anuncia_mi_llegada/views/configuration/settings_screen.dart';

class TransportsScreen extends StatelessWidget {
  static const name = 'transports_screen';

  const TransportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          //Map Icon for Light Mode
          Positioned(
            left: 0,
            right: 0,
            top: 115,
            child: Center(
              child: Image(
                image: AssetImage('assets/icons/Map_Icon_W.png'),
                width: 92,
                height: 109,
              ),
            ),
          ),
          //Transports Selector (selector de transportes)
          Center(
            child: Image(
              image: AssetImage('assets/images/selector_de_transportes.png'),
              width: 361,
            ),
          ),
          //Settings button
          Positioned(
            left: 0,
            right: 0,
            top: 794,
            child: Center(
              child: IconButton(
                iconSize: 24,
                color: Colors.orangeAccent,
                onPressed: () {
                  context.pushNamed(SettingsScreen.name);
                },
                icon: Icon(Icons.settings),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
