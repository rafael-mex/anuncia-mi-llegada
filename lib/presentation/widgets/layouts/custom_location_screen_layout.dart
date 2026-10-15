import 'package:anuncia_mi_llegada/config/connectivity/connectivity_service.dart';
import 'package:anuncia_mi_llegada/presentation/widgets/shared/shared_buttons/history_button.dart';
import 'package:anuncia_mi_llegada/presentation/widgets/shared/shared_buttons/keyboard_return_button.dart';
import 'package:anuncia_mi_llegada/presentation/widgets/shared/shared_buttons/wifi_off_button.dart';
import 'package:flutter/material.dart';
import '../icons/map_icon.dart';
import '../shared/shared_buttons/settings_button.dart';

class CustomLocationScreenLayout extends StatelessWidget {
  final Widget keyboardReturnButton;
  final Widget customLocationOptions;

  const CustomLocationScreenLayout({
    super.key,
    required this.customLocationOptions,
    this.keyboardReturnButton = const KeyboardReturnButton(),
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [

                Stack(
                  children: [
                    //--- MapIcon ---
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: const Center(child: MapIcon()),
                    ),
                    //---------------

                    // ---- Keyboard Return Button ------
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 28, top: 35),
                        child: KeyboardReturnButton(),
                      ),
                    ),
                    //-----------------------------------

                //------- History Button y Wifi Off Button: --------
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
                            //----- History Button: -----
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        right: 38,
                                        top: 28,
                                        bottom: 4
                                      ),
                                      child: HistoryButton(),
                                    ),
                            //----- Wifi Off Icon: -----
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        right: 38,
                                      ),
                                      child: WifiOffButton(
                                        textContent: "Hola mi nombre es annie")
                                    ),
                                  ],
                                ),
                              )
                            else
                            //----- History Button: -----
                              Align(
                                alignment: Alignment.centerRight,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    right: 38,
                                    top: 45,
                                  ),
                                  child: HistoryButton(),
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                            //-----------------------
                  ],
                ),
                //--------------------------------------------------

                // ------- Custom Location Options View (customLocationOptions) : ---------
                Flexible(
                  flex: 14,
                  child: SizedBox(
                    width: 540,
                    height: 520,
                    child: customLocationOptions,
                  ),
                ),
                //---------------------------------------------------------------------------

                const Spacer(),

              //------ Settings Button -------
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [const SettingsButton()],
                ),
              //--------------------------------
                const Spacer(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
