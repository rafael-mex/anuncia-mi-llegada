import 'package:anuncia_mi_llegada/data/models/mi_model.dart';
import 'package:anuncia_mi_llegada/presentation/widgets/shared/selector_widget.dart';
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
      body: SelectorWidget(
        selectorsTitle: 'Selecciona una \n estación:',
        listContent: ListView.separated(
          itemCount: hasLineNameInMessage
              ? line.stations.length + 1
              : line.stations.length,
          separatorBuilder: (context, index) => const Divider(height: 1),
          itemBuilder: (context, index) {
            if (hasLineNameInMessage && index == 0) {
              return ListTile(
                title: const Text('Únicamente mencionar el nombre de la línea'),
                onTap: () {
                  debugPrint('Ya estoy en la ${line.lineNameInMessage}');
                },
              );
            }

            final stationIndex = hasLineNameInMessage ? index - 1 : index;
            final station = line.stations[stationIndex];

            return ListTile(
              title: Text(station),
              onTap: () {
                debugPrint('Ya estoy en la estación $station');
              },
            );
          },
        ),
      ),
    );
  }
}
