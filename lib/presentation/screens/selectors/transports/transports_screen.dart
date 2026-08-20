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
        children: [
      //Transports Selector (selector de transportes)
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
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              final transports = snapshot.data ?? [];
              return SelectorWidget(
                selectorsTitle: 'Selecciona un \n medio de transporte:',
                listContent: ListView.separated(
                  itemCount: transports.length,
                  separatorBuilder: (context, index) =>
                      const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final transport = transports[index];
                    return ListTile(
                      title: Text(transport.name),
                      onTap: () {
                        context.pushNamed(
                          LinesScreen.name,
                          extra: transport,
                        );
                      },
                    );
                  },
                ),
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




