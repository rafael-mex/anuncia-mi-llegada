import 'package:anuncia_mi_llegada/presentation/widgets/shared/map_icon_white.dart';
import 'package:anuncia_mi_llegada/presentation/widgets/shared/selector_widget.dart';
import 'package:anuncia_mi_llegada/presentation/widgets/shared/settings_button_white.dart';
import 'package:flutter/material.dart';

class TransportsScreen extends StatelessWidget {
  static const name = 'transports_screen';

  const TransportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          //Transports Selector (selector de transportes)
          SelectorWidget(selectorsTitle: 'Selecciona un \n medio de transporte:'),
          //Map Icon for Light Mode (Map Icon para el modo claro)
          MapIconLight(),
          //Settings button
          SettingsButton(),
        ],
      ),
    );
  }
}


