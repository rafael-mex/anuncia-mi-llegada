import 'package:anuncia_mi_llegada/config/preferences/preferences_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Migración de la app de mensajería', () {
    test('"Otros" se traspasa a "Cualquier app de mensajería"', () {
      expect(
        PreferencesService.resolveMessagingApp("Otros"),
        "Cualquier app de mensajería",
      );
    });

    test('los valores vigentes se conservan sin cambios', () {
      for (final option in PreferencesService.messagingAppOptions) {
        expect(PreferencesService.resolveMessagingApp(option), option);
      }
    });

    test('un valor desconocido cae al predeterminado', () {
      expect(
        PreferencesService.resolveMessagingApp("Telegram"),
        PreferencesService.defaultWhatMessagingAppYouWillUse,
      );
    });

    test('sin valor guardado se usa el predeterminado', () {
      expect(
        PreferencesService.resolveMessagingApp(null),
        PreferencesService.defaultWhatMessagingAppYouWillUse,
      );
    });
  });
}
