import 'package:anuncia_mi_llegada/presentation/screens/splash_screen/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_svg/svg.dart';

void main() {
  testWidgets('SplashScreen renderiza el appcard de bienvenida', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: SplashScreen()));

    expect(find.byType(SvgPicture), findsOneWidget);
  });
}
