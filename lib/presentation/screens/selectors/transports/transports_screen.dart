import 'package:anuncia_mi_llegada/data/models/mi_model.dart';
import 'package:anuncia_mi_llegada/data/repositories/mi_repository.dart';
import 'package:anuncia_mi_llegada/presentation/screens/selectors/lines/lines_screen.dart';
import 'package:anuncia_mi_llegada/presentation/widgets/shared/map_icon_white.dart';
import 'package:anuncia_mi_llegada/presentation/widgets/shared/selector_widget.dart';
import 'package:anuncia_mi_llegada/presentation/widgets/shared/settings_button_white.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TransportsScreen extends StatelessWidget {
  static const name = 'transports_screen';

  const TransportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        //Transports Selector (selector de transportes)
        children: [
          FutureBuilder<List<TransportsModel>>(
            future: MiRepository().loadTransports(
              showLineNamesInMessage: true,
              showInstitutionsName: true,
            ),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('No se supone que debería de haber esto ;( : ${snapshot.error}'));
              }
              final transports = snapshot.data ?? [];
              return SelectorWidget(
                selectorsTitle: 'Selecciona un \n medio de transporte:',
                listItems: [
                  for (final transport in transports)
                    ListTile(
                      title: Text(
                        transport.name,
                        style: TextStyle(
                          color: Colors.white,
                          height: 1,
                          fontFamily: 'Nunito',
                          fontSize: 17,
                          letterSpacing: 0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      onTap: () {
                        context.pushNamed(LinesScreen.name, extra: transport);
                      },
                    ),
                ],
              );
            },
          ),
          //Map Icon for Light Mode (Map Icon para el modo claro)
          MapIconLight(),
          //Settings button
          SettingsButton(),
        ],
      ),
    );
  }
}
