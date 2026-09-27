import 'package:anuncia_mi_llegada/config/menu/settings_items.dart';
import 'package:anuncia_mi_llegada/config/preferences/preferences_service.dart';
import 'package:anuncia_mi_llegada/theme/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

Widget _harness(Brightness brightness) {
  return MaterialApp(
    theme: brightness == Brightness.dark ? AppTheme.darkTheme : AppTheme.lightTheme,
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

void main() {
  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await PreferencesService.init();
  });

  for (final brightness in Brightness.values) {
    testWidgets('El selector abre el menú en modo $brightness', (tester) async {
      await tester.pumpWidget(_harness(brightness));
      await tester.pumpAndSettle();

      expect(find.byType(CupertinoMenuItem), findsNothing);

      await tester.tap(find.text('SMS').last);
      await tester.pumpAndSettle();

      expect(find.byType(CupertinoMenuItem), findsNWidgets(3));
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('Al elegir una opción se actualiza la preferencia', (tester) async {
    await tester.pumpWidget(_harness(Brightness.light));
    await tester.pumpAndSettle();

    await tester.tap(find.text('SMS').last);
    await tester.pumpAndSettle();

    await tester.tap(find.text('WhatsApp').last);
    await tester.pumpAndSettle();

    expect(PreferencesService.whatMessagingAppYouWillUse.value, 'WhatsApp');
    expect(find.byType(CupertinoMenuItem), findsNothing);
  });
}
