import 'package:anuncia_mi_llegada/config/preferences/preferences_service.dart';
import 'package:anuncia_mi_llegada/data/models/history_items.dart';
import 'package:anuncia_mi_llegada/presentation/widgets/icons/history_icon.dart';
import 'package:anuncia_mi_llegada/presentation/widgets/shared/buttons/keyboard_return_button.dart';
import 'package:anuncia_mi_llegada/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';

class HistoryScreen extends StatefulWidget {
  static const name = 'history_screen';

  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String selectCategory = 'TODOS';

  final List<String> categories = [
    'TODOS',
    'LÍNEAS',
    'CABLEBÚS',
    'METRO',
    'METROBÚS',
    'MEXÍBUS',
    'MEXICABLE',
    'TREN LIGERO',
    'TRENES V.M',
    'TROLEBÚS',
    'UBI.PERSONALIZADA',
  ];

  Future<void> _resendMessage(HistoryItems record) async {
    final messageBody = PreferencesService.messageBody.value;
    final mensajeFinal = '$messageBody ${record.stationName}';
    final preferredApp = PreferencesService.whatMessagingAppYouWillUse.value;

    if (preferredApp == "WhatsApp") {
      final Uri whatsappUri = Uri.parse(
        "whatsapp://send?text=${Uri.encodeComponent(mensajeFinal)}",
      );
      if (await canLaunchUrl(whatsappUri)) {
        await launchUrl(whatsappUri);
      }
    } else if (preferredApp == "Otros") {
      await SharePlus.instance.share(ShareParams(text: mensajeFinal));
    } else {
      final Uri smsUri = Uri.parse(
        'sms:?body=${Uri.encodeComponent(mensajeFinal)}',
      );
      if (await canLaunchUrl(smsUri)) {
        await launchUrl(smsUri);
      }
    }
  }

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
          child: Stack(
            children: [
              //RecordIcon
              Positioned(
                left: 0,
                right: 0,
                top: 108,
                child: Center(child: HistoryIcon()),
              ),
              //------------
              //KeyoboardReturnButton
              Positioned(left: 28, top: 126, child: KeyboardReturnButton()),
              //---------------------

              //Barra de categorías
              Positioned(
                left: 0,
                right: 0,
                top: 240,
                bottom: 0,
                child: Column(
                  children: [
                    ValueListenableBuilder<List<HistoryItems>>(
                      valueListenable: PreferencesService.historyList,
                      builder: (context, historyItems, _) => SizedBox(
                        height: 40,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          itemCount: categories.length,
                          separatorBuilder: (context, index) => const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            child: Text('|', style: AppTheme.metroStyle),
                          ),
                          itemBuilder: (context, index) {
                            final category = categories[index];
                            final isSelected = category == selectCategory;
                            final label = category == 'TODOS'
                                ? 'TODOS (${historyItems.length})'
                                : category;
                            return GestureDetector(
                              onTap: () =>
                                  setState(() => selectCategory = category),
                              child: Center(
                                child: Text(
                                  label,
                                  style: isSelected
                                      ? AppTheme.metroStyle
                                      : AppTheme.metroStyle.copyWith(
                                          color: AppTheme.metroStyle.color
                                              ?.withValues(alpha: 0.66),
                                        ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Divider(color: Color(0xFFF69346), thickness: 1, height: 8, indent: 20, endIndent: 20,),
                    const SizedBox(height: 10),
                    //Historial
                    Expanded(
                      child: ValueListenableBuilder<List<HistoryItems>>(
                        valueListenable: PreferencesService.historyList,
                        builder: (context, historyItems, _) {
                          final filteredList = selectCategory == 'TODOS'
                              ? historyItems
                              : historyItems
                                    .where(
                                      (item) =>
                                          item.category == selectCategory,
                                    )
                                    .toList();

                          if (filteredList.isEmpty) {
                            return const Center(
                              child: Text(
                                'Aún no has anunciado tu llegada',
                                style: AppTheme.nunitoFamilySubtitle,
                              ),
                            );
                          }

                          return ListView.builder(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            itemCount: filteredList.length,
                            itemBuilder: (context, index) {
                              final history = filteredList[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 20),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(12),
                                    onTap: () => _resendMessage(history),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Icon(
                                          Icons.chat_bubble_outline_rounded,
                                          color: Color(0xFFF69346),
                                          size: 26,
                                        ),
                                        const SizedBox(width: 15),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                history.stationName[0]
                                                        .toUpperCase() +
                                                    history.stationName
                                                        .substring(1),
                                                style: AppTheme.nunitoFamily,
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                history.transportAndLineName,
                                                style: AppTheme
                                                    .nunitoFamilySubtitle,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
