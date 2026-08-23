import 'package:anuncia_mi_llegada/data/models/mi_model.dart';
import 'package:anuncia_mi_llegada/presentation/screens/selectors/stations/stations_screen.dart';
import 'package:anuncia_mi_llegada/presentation/widgets/shared/map_icon.dart';
import 'package:anuncia_mi_llegada/presentation/widgets/shared/return_button.dart';
import 'package:anuncia_mi_llegada/presentation/widgets/shared/selector_widget.dart';
import 'package:anuncia_mi_llegada/presentation/widgets/shared/settings_button_white.dart';
import 'package:anuncia_mi_llegada/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LinesScreen extends StatelessWidget {
  static const name = 'lines_screen';

  const LinesScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final transport = GoRouterState.of(context).extra as TransportsModel;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: ValueListenableBuilder<bool>(
        valueListenable: isTrueDarkMode,
        builder: (context, isDark, _) => AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            color: isDark ? null : AppTheme.backgroundColorLM,
            gradient: isDark ? AppTheme.backgroundColorDM : null,
          ),
          child: Stack(
            //Lines Selector (selector de líneas)
            children: [
              SelectorWidget(
                selectorsTitle: 'Selecciona \n la línea:',
                listItems: [
                  for (final line in transport.lines)
                    ListTile(
                      title: Text(
                        style: TextStyle(
                          color: Colors.white,
                          height: 1,
                          fontFamily: 'Nunito',
                          fontSize: 17,
                          letterSpacing: 0.1,
                          fontWeight: FontWeight.w700,
                        ),
                        line.name,
                      ),
                      onTap: () {
                        context.pushNamed(StationsScreen.name, extra: line);
                      },
                    ),
                ],
              ),
              //Map Icon (cambia según el modo)
              MapIcon(),
              //Settings button
              SettingsButton(),
              //Return Button
              ReturnButton(),
            ],
          ),
        ),
      ),
    );
  }
}
