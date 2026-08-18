import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:anuncia_mi_llegada/main.dart';

void main() {
  testWidgets('SplashPage renders image and progress indicator', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const AnunciaMiLlegadaApp());

    expect(
      find.byType(CircularProgressIndicator),
      findsOneWidget,
    );
  });
}
