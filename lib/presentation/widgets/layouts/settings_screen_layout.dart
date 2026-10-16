import 'package:anuncia_mi_llegada/config/connectivity/connectivity_service.dart';
import 'package:anuncia_mi_llegada/presentation/widgets/icons/gear_icon.dart';
import 'package:anuncia_mi_llegada/presentation/widgets/shared/shared_buttons/keyboard_return_button.dart';
import 'package:anuncia_mi_llegada/presentation/widgets/shared/shared_buttons/wifi_off_button.dart';
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
      bottom: false,
      child: Column(
        children: [
          Stack(
            children: [
              // ----- Gear Icon ------
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Center(child: GearIcon()),
              ),
              //-----------------------

              // ----------- Keyboard Return Button ----------------
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 28, top: 36),
                  child: KeyboardReturnButton(),
                ),
              ),
              //---------------------------------------------------

              // ---------------- Wifi Off Button -------------------------
              ValueListenableBuilder<bool>(
                valueListenable: ConnectivityService.isOnline,
                builder: (context, isOnline, _) {
                  return Stack(
                    alignment: Alignment.centerRight,
                    children: [
                      if (!isOnline)
                        Align(
                          alignment: Alignment.centerRight,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  right: 38,
                                  top: 45,
                                ),
                                child: WifiOffButton(
                                  textContent: "Las opciones de la sección \"Información y Contacto\" no estarán disponibles",
                                ),
                              ),
                            ],
                          ),
                        )
                      else
                        const SizedBox.shrink(),
                    ],
                  );
                },
              ),
              //-----------------------------------------------------------
            ],
          ),
          const SizedBox(height: 10),

          // ------ Settings View ------
          Expanded(child: settingsView),
          //----------------------------
        ],
      ),
    );
  }
}
