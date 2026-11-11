import 'package:anuncia_mi_llegada/config/menu/settings_items.dart';
import 'package:anuncia_mi_llegada/config/preferences/preferences_service.dart';
import 'package:anuncia_mi_llegada/theme/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

Widget _harness(Brightness brightness) {
  return MaterialApp(
    theme: brightness == Brightness.dark
        ? AppTheme.darkTheme
        : AppTheme.lightTheme,
    builder: (context, child) => CupertinoTheme(
      data: CupertinoThemeData(brightness: brightness),
      child: child!,
    ),
    home: Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            for (final item in appSettingsItems)
              if (item.showedConfigurations != null) item.showedConfigurations!,
          ],
        ),
      ),
    ),
  );
}

Future<void> _pumpHarness(WidgetTester tester, Brightness brightness) async {
  // Todas las secciones se montan desplegadas; se necesita una superficie
  // alta para que el selector de mensajería quede dentro del viewport.
  await tester.binding.setSurfaceSize(const Size(800, 4000));
  addTearDown(() => tester.binding.setSurfaceSize(null));

  await tester.pumpWidget(_harness(brightness));
  await tester.pumpAndSettle();
}

void main() {
  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await PreferencesService.init();
  });

  setUp(() {
    // Cada prueba parte de la app de mensajería predeterminada.
    PreferencesService.whatMessagingAppYouWillUse.value =
        PreferencesService.defaultWhatMessagingAppYouWillUse;
  });

  for (final brightness in Brightness.values) {
    testWidgets('El selector abre el menú en modo $brightness', (tester) async {
      await _pumpHarness(tester, brightness);

      // El menú está cerrado: solo se ve la opción seleccionada.
      expect(find.text('WhatsApp'), findsNothing);
      expect(find.text('Cualquier app de mensajería'), findsNothing);

      await tester.tap(find.text('SMS').last);
      await tester.pumpAndSettle();

      // El menú muestra las tres opciones disponibles.
      expect(find.text('WhatsApp'), findsOneWidget);
      expect(find.text('Cualquier app de mensajería'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('Al elegir una opción se actualiza la preferencia', (
    tester,
  ) async {
    await _pumpHarness(tester, Brightness.light);

    await tester.tap(find.text('SMS').last);
    await tester.pumpAndSettle();

    await tester.tap(find.text('WhatsApp').last);
    await tester.pumpAndSettle();

    expect(PreferencesService.whatMessagingAppYouWillUse.value, 'WhatsApp');
    expect(find.text('Cualquier app de mensajería'), findsNothing);
  });
}
