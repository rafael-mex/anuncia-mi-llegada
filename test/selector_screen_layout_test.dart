import 'package:anuncia_mi_llegada/presentation/widgets/icons/map_icon.dart';
import 'package:anuncia_mi_llegada/presentation/widgets/layouts/selector_screen_layout.dart';
import 'package:anuncia_mi_llegada/presentation/widgets/selector/selector_widget.dart';
import 'package:anuncia_mi_llegada/presentation/widgets/shared/shared_buttons/custom_button.dart';
import 'package:anuncia_mi_llegada/presentation/widgets/shared/shared_buttons/settings_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Dispositivos usados para verificar el layout de la pantalla de selección.
/// Cada entrada tiene el tamaño lógico de la pantalla y las medidas seguras
/// (status bar / barra de gestos) de ese dispositivo.
const _devices = <String, (Size, EdgeInsets)>{
  'iPhone SE (3ra gen)': (Size(375, 667), EdgeInsets.only(top: 20)),
  'iPhone 15 Pro': (Size(393, 852), EdgeInsets.only(top: 59, bottom: 34)),
  'Pixel 10 Pro': (Size(427, 952), EdgeInsets.only(top: 30, bottom: 24)),
  'iPhone SE (1ra gen)': (Size(320, 568), EdgeInsets.only(top: 20)),
};

//Separaciones fijas del layout
const _returnButtonSpacing = 40;
const _selectorSpacing = 16;
const _settingsButtonSpacing = 30;
//Alto de diseño del selector (contenedor naranja); en pantallas más cortas
//se reduce, pero nunca debe desaparecer la lista de opciones
const _designSelectorHeight = 386;

void main() {
  for (final device in _devices.entries) {
    final (screen, insets) = device.value;

    testWidgets('El layout de la pantalla de selección se adapta a ${device.key}', (
      WidgetTester tester,
    ) async {
      tester.view
        ..physicalSize = screen * 3
        ..devicePixelRatio = 3
        ..padding = FakeViewPadding(
          top: insets.top * 3,
          bottom: insets.bottom * 3,
        );
      addTearDown(tester.view.reset);

      final errors = <String>[];
      final previousOnError = FlutterError.onError;
      FlutterError.onError = (details) => errors.add(
        details.exceptionAsString(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SelectorScreenLayout(
              selector: SelectorWidget(
                selectorsTitle: 'Selecciona un \n medio de transporte:',
                titleTopOffset: 16,
                listItems: const [SizedBox(height: 48), SizedBox(height: 48)],
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      FlutterError.onError = previousOnError;

      //Ningún RenderFlex puede desbordarse (pintaría las franjas amarillas)
      expect(errors, isEmpty);

      //El contenedor del selector es el único LayoutBuilder dentro de él
      final selector = tester.getRect(
        find.descendant(
          of: find.byType(SelectorWidget),
          matching: find.byType(LayoutBuilder),
        ),
      );
      final mapIcon = tester.getRect(find.byType(MapIcon));
      final returnButton = tester.getRect(find.byType(CustomButton));
      final settingsButton = tester.getRect(find.byType(SettingsButton));

      //El contenido vive dentro del área segura de la pantalla
      final contentBottom = screen.height - insets.bottom;
      expect(settingsButton.bottom, lessThanOrEqualTo(contentBottom));

      //El espacio elástico se reparte 50/50 entre el Spacer superior (entre el
      //ícono del mapa y el selector) y el Spacer inferior (bajo el botón de
      //ajustes). Ambos miden lo mismo, por lo que el selector queda centrado
      //entre el header y el footer.
      final double topSpacer =
          selector.top - mapIcon.bottom - _selectorSpacing;
      final double bottomSpacer =
          contentBottom - settingsButton.bottom - _settingsButtonSpacing;
      expect(bottomSpacer, closeTo(topSpacer, 2));

      //El botón de ajustes conserva su separación mínima con el borde inferior
      expect(
        contentBottom - settingsButton.bottom,
        greaterThanOrEqualTo(_settingsButtonSpacing),
      );

      //El botón de retroceder mantiene 40px de separación arriba y 40px abajo
      expect(
        settingsButton.top - returnButton.bottom,
        _returnButtonSpacing,
      );
      expect(
        returnButton.top - selector.bottom,
        greaterThanOrEqualTo(_selectorSpacing),
      );

      //El selector nunca supera su tamaño de diseño y conserva un alto útil
      expect(selector.height, lessThanOrEqualTo(_designSelectorHeight));
      expect(selector.height, greaterThanOrEqualTo(_selectorSpacing * 2 + 100));

      //El selector queda horizontalmente centrado
      expect(selector.center.dx, closeTo(screen.width / 2, 1));
    });
  }
}
