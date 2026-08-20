import 'package:anuncia_mi_llegada/data/models/mi_model.dart';
import 'package:anuncia_mi_llegada/presentation/screens/selectors/stations/stations_screen.dart';
import 'package:anuncia_mi_llegada/presentation/widgets/shared/map_icon_white.dart';
import 'package:anuncia_mi_llegada/presentation/widgets/shared/selector_widget.dart';
import 'package:anuncia_mi_llegada/presentation/widgets/shared/settings_button_white.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LinesScreen extends StatelessWidget {
  
  static const name = 'lines_screen';

  const LinesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final transport = GoRouterState.of(context).extra as TransportsModel;

    return Scaffold(
      backgroundColor: Colors.white,
      body: 
          //Lines Selector (Selector de líneas)
          SelectorWidget(
            selectorsTitle: 'Selecciona una \n línea:',
            listContent: ListView.separated(
              itemCount: transport.lines.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final line = transport.lines[index];
                return ListTile(
                  title: Text(line.name),
                  onTap: () {
                    context.pushNamed(StationsScreen.name, extra: line);
                  },
                );
              },
            ),
          ),
    );
  }
}
