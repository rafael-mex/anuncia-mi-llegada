import 'package:anuncia_mi_llegada/config/preferences/preferences_service.dart';
import 'package:anuncia_mi_llegada/data/models/history_items.dart';
import 'package:anuncia_mi_llegada/presentation/widgets/layouts/custom_location_screen_layout.dart';
import 'package:anuncia_mi_llegada/theme/app_theme.dart';
import 'package:anuncia_mi_llegada/utils/send_message_helper.dart';
import 'package:flutter/material.dart';

class CustomLocationScreen extends StatelessWidget {
  static const name = 'custom_location_screen';

  const CustomLocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Implementación del backgroundColor
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

          //-------------------------------------
          child: CustomLocationScreenLayout(
            customLocationOptions: CustomLocationOptions(),
          ),
        ),
      ),
    );
  }
}

class CustomLocationOptions extends StatefulWidget {
  const CustomLocationOptions({super.key});

  @override
  State<CustomLocationOptions> createState() => _CustomLocationOptionsState();
}

class _CustomLocationOptionsState extends State<CustomLocationOptions> {
  final TextEditingController _manualUbicationController =
      TextEditingController();

  static const TextStyle _nunitoFamily = TextStyle(
    color: Color(0xFFF69346),
    fontFamily: 'Nunito',
    fontSize: 20,
    letterSpacing: 0,
    fontWeight: FontWeight.w800,
  );

  @override
  void dispose() {
    _manualUbicationController.dispose();
    super.dispose();
  }

  Future<void> _categorizingLocation(String locationText, String type) async {
    if (locationText.trim().isEmpty) return;

    final messageBody = PreferencesService.messageBody.value;
    final sendedMessage = "$messageBody ${locationText.trim()}";
    final succes = await SendMessageHelper.sendMessage(sendedMessage);

    if (succes) {
      final newHistoryItem = HistoryItems(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        category: "UBI.PERSONALIZADA",
        stationName: "${locationText.trim()}",
        transportAndLineName: 'Tipo: $type',
        messageTime: DateTime.now(),
      );
      await PreferencesService.saveToHistoryItems(newHistoryItem);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 360,
      height: 386,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //Manual
          const SizedBox(height: 25),
          Text(
            'Escribir la ubicación manualmente',
            style: _nunitoFamily,
            textAlign: TextAlign.left,
          ),
          Divider(
            color: Color(0xFFF69346),
            thickness: 1,
            height: 8,
            indent: 2,
            endIndent: 2,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ValueListenableBuilder<String>(
              valueListenable: PreferencesService.messageBody,
              builder: (context, messageBody, _) {
                return TextField(
                  controller: _manualUbicationController,
                  style: AppTheme.nunitoFamilySubtitle,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (value) =>
                      _categorizingLocation(value, 'Ubicación manual'),
                  decoration: InputDecoration(
                    prefixText: '$messageBody ',
                    prefixStyle: const TextStyle(
                      fontFamily: 'Nunito',
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                    hintStyle: const TextStyle(color: Colors.white30),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFF69346)),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFFB6A3A3),
                        width: 2,
                      ),
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(
                        Icons.send_rounded,
                        color: Color(0xFFB6A3A3),
                      ),
                      onPressed: () => _categorizingLocation(
                        _manualUbicationController.text,
                        'Ubicación manual',
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          //-----------
          SizedBox(height: 40),
          Text(
            'Buscar en el mapa',
            style: _nunitoFamily,
            textAlign: TextAlign.left,
          ),
          Divider(
            color: Color(0xFFF69346),
            thickness: 1,
            height: 8,
            indent: 2,
            endIndent: 2,
          ),
          SizedBox(height: 40),
          Text(
            'Usar ubicación actual',
            style: _nunitoFamily,
            textAlign: TextAlign.left,
          ),
          Divider(
            color: Color(0xFFF69346),
            thickness: 1,
            height: 8,
            indent: 2,
            endIndent: 2,
          ),
        ],
      ),
    );
  }
}
