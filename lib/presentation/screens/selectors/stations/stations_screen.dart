import 'package:anuncia_mi_llegada/data/models/mi_model.dart';
import 'package:anuncia_mi_llegada/presentation/widgets/shared/map_icon_white.dart';
import 'package:anuncia_mi_llegada/presentation/widgets/shared/return_button.dart';
import 'package:anuncia_mi_llegada/presentation/widgets/shared/selector_widget.dart';
import 'package:anuncia_mi_llegada/presentation/widgets/shared/settings_button_white.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class StationsScreen extends StatelessWidget {
  static const name = 'stations_screen';

  const StationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final line = GoRouterState.of(context).extra as LinesModel;
    final hasLineNameInMessage = line.lineNameInMessage.isNotEmpty;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
        //Stations Selector (selector de estanciones)
          SelectorWidget(
            selectorsTitle: 'Selecciona \n la estación:',
            listItems: [
              if (hasLineNameInMessage)
                ListTile(
                  title:
                      const Text(
                        style: TextStyle(
                          color: Colors.white,
                          height: 1,
                          fontFamily: 'Nunito',
                          fontSize: 17,
                          letterSpacing: 0,
                          fontWeight: FontWeight.w700,
                        ),
                        'Únicamente mencionar el nombre de la línea'),
                  onTap: () {
                    debugPrint('Ya estoy en la ${line.lineNameInMessage}');
                  },
                ),
              for (final station in line.stations)
                ListTile(
                  title: Text(
                    style: TextStyle(
                          color: Colors.white,
                          height: 1,
                          fontFamily: 'Nunito',
                          fontSize: 17,
                          letterSpacing: 0,
                          fontWeight: FontWeight.w700,
                        ),
                    station
                  ),
                  onTap: () {
                    debugPrint('Ya estoy en la estación $station');
                  },
                ),
            ],
          ),
        //Map Icon for Light Mode (Map Icon para el modo claro)
          MapIconLight(),
        //Settings button
          SettingsButton(),
        //Return Button
          ReturnButton(),
        ],
      ),
    );
  }
}
