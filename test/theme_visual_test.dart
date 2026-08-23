import 'package:anuncia_mi_llegada/config/router/app_router.dart';
import 'package:anuncia_mi_llegada/main.dart';
import 'package:anuncia_mi_llegada/presentation/widgets/shared/settings_button.dart';
import 'package:anuncia_mi_llegada/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:light_dark_theme_toggle/light_dark_theme_toggle.dart';

void main() {
  Future<void> advance(
    WidgetTester tester, [
    Duration duration = const Duration(milliseconds: 700),
  ]) async {
    await tester.pump();
    await tester.pump(duration);
  }

  BoxDecoration? backgroundOf(WidgetTester tester) {
    final containers = tester.widgetList<Container>(
      find.byWidgetPredicate(
        (w) =>
            w is Container &&
            w.decoration is BoxDecoration &&
            ((w.decoration as BoxDecoration).color ==
                    AppTheme.backgroundColorLM ||
                (w.decoration as BoxDecoration).gradient ==
                    AppTheme.backgroundColorDM),
      ),
    );
    return containers.isEmpty
        ? null
        : containers.first.decoration as BoxDecoration?;
  }

  String? gearAsset(WidgetTester tester) {
    final images = tester.widgetList<Image>(
      find.byWidgetPredicate(
        (w) =>
            w is Image &&
            w.image is AssetImage &&
            (w.image as AssetImage).assetName.contains('gear'),
      ),
    );
    return images.isEmpty ? null : (images.first.image as AssetImage).assetName;
  }

  void resetGlobalState(WidgetTester tester) {
    addTearDown(() {
      isTrueDarkMode.value = false;
      appRouter.go('/splash');
    });

    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.reset);
  }

  Future<void> reachTransportsScreen(WidgetTester tester) async {
    appRouter.go('/');
    await tester.runAsync(() async {
      await tester.pumpWidget(const AnunciaMiLlegadaApp());
      await Future<void>.delayed(const Duration(milliseconds: 200));
    });
    await advance(tester, const Duration(seconds: 1));
    await advance(tester, const Duration(seconds: 1));
  }

  testWidgets('Ruta real: botón de configuración -> toggle -> visuales', (
    tester,
  ) async {
    isTrueDarkMode.value = false;
    resetGlobalState(tester);

    await reachTransportsScreen(tester);

    expect(backgroundOf(tester)?.color, AppTheme.backgroundColorLM);
    expect(backgroundOf(tester)?.gradient, isNull);

    await tester.tap(find.byType(SettingsButton));
    await advance(tester, const Duration(seconds: 1));

    expect(find.text('Apariencia'), findsOneWidget);

    expect(gearAsset(tester), 'assets/icons/config_icons/gear_white.png');
    expect(
      tester.widget<Text>(find.text('Apariencia')).style?.color,
      Colors.black,
    );
    expect(
      tester
          .widget<Text>(find.text('Cambia entre el modo claro y \nobscuro.'))
          .style
          ?.color,
      const Color.fromRGBO(91, 79, 79, 100),
    );

    await tester.tap(find.byType(LightDarkThemeToggle));
    await advance(tester);

    expect(gearAsset(tester), 'assets/icons/config_icons/gear_dark.png');
    expect(backgroundOf(tester)?.gradient, AppTheme.backgroundColorDM);
    expect(backgroundOf(tester)?.color, isNull);
    expect(
      tester.widget<Text>(find.text('Apariencia')).style?.color,
      const Color.fromRGBO(204, 204, 204, 100),
    );
    expect(
      tester
          .widget<Text>(find.text('Cambia entre el modo claro y \nobscuro.'))
          .style
          ?.color,
      const Color.fromRGBO(151, 145, 145, 100),
    );
  });

  testWidgets('ReturnButton alterna azul claro <-> azul oscuro', (
    tester,
  ) async {
    const lightBlue = Color.fromRGBO(113, 203, 248, 100);
    const darkBlue = Color.fromRGBO(13, 97, 255, 30);

    bool hasMaterialColor(Color color) => tester
        .widgetList<Material>(
          find.byWidgetPredicate((w) => w is Material && w.color == color),
        )
        .isNotEmpty;

    isTrueDarkMode.value = false;
    resetGlobalState(tester);

    await reachTransportsScreen(tester);

    await tester.tap(find.byType(ListTile).first);
    await advance(tester, const Duration(seconds: 1));

    expect(hasMaterialColor(lightBlue), isTrue);

    isTrueDarkMode.value = true;
    await advance(tester);
    expect(hasMaterialColor(darkBlue), isTrue);

    isTrueDarkMode.value = false;
    await advance(tester);
    expect(hasMaterialColor(lightBlue), isTrue);
  });

  testWidgets('SettingsButton alterna ícono y fondo transparente', (
    tester,
  ) async {
    bool hasIcon(String assetPath) =>
        tester.widgetList(find.byKey(ValueKey<String>(assetPath))).isNotEmpty;

    bool hasTileBackground(Color color) => tester
        .widgetList<AnimatedContainer>(
          find.byWidgetPredicate(
            (w) =>
                w is AnimatedContainer &&
                w.decoration is BoxDecoration &&
                (w.decoration as BoxDecoration).color == color,
          ),
        )
        .isNotEmpty;

    isTrueDarkMode.value = false;
    resetGlobalState(tester);

    await reachTransportsScreen(tester);

    expect(hasIcon('assets/icons/config_icons/settings_Icon.svg'), isTrue);
    expect(hasTileBackground(Colors.white.withValues(alpha: 0.15)), isTrue);

    isTrueDarkMode.value = true;
    await advance(tester);

    expect(hasIcon('assets/icons/config_icons/settings_Icon_dark.svg'), isTrue);
    expect(hasTileBackground(Colors.transparent), isTrue);
  });
}
