import 'package:anuncia_mi_llegada/config/connectivity/connectivity_service.dart';
import 'package:anuncia_mi_llegada/presentation/widgets/icons/history_icon.dart';
import 'package:anuncia_mi_llegada/presentation/widgets/shared/shared_buttons/keyboard_return_button.dart';
import 'package:anuncia_mi_llegada/presentation/widgets/shared/shared_buttons/settings_button.dart';
import 'package:anuncia_mi_llegada/presentation/widgets/shared/shared_buttons/wifi_off_button.dart';
import 'package:flutter/material.dart';

class HistoryScreenLayout extends StatelessWidget {
  final Widget historyWidget;

  const HistoryScreenLayout({required this.historyWidget, super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          Stack(
            children: [
              //----- History Icon ------
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: const Center(child: HistoryIcon()),
              ),
              //--------------------------

              //----- KeyoboardReturnButton --------
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 28, top: 35),
                  child: KeyboardReturnButton(),
                ),
              ),
              //----------------------------------------

              // -------- Settings Button y Wifi Off Button ----------
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
                              //----- Settings Button: -----
                              Padding(
                                padding: const EdgeInsets.only(
                                  right: 38,
                                  top: 26,
                                  bottom: 2,
                                  
                                ),
                                child: SettingsButton(),
                              ),
                              //----- Wifi Off Button: -----
                              Padding(
                                padding: const EdgeInsets.only(
                                  right: 38,
                                  top: 3
                                ),
                                child: WifiOffButton(
                                  textContent: "Hola mi nombre es annie",
                                ),
                              ),
                            ],
                          ),
                        )
                      else
                        //----- Settings Button: -----
                        Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              right: 38, 
                              top: 45),
                            child: SettingsButton(),
                          ),
                        ),
                    ],
                  );
                },
              ),
              //----------------------------------------------------
            ],
          ),
          const SizedBox(height: 20),

          // ------ History View Widget (HistoryWidget) : --------
          Expanded(child: historyWidget),
          //-------------------------------------------------------
        ],
      ),
    );
  }
}
