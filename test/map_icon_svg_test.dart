import 'package:anuncia_mi_llegada/presentation/widgets/icons/map_icon.dart';
import 'package:anuncia_mi_llegada/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_svg/svg.dart';

Future<void> _renderGolden(
  WidgetTester tester,
  String asset,
  String goldenName,
) async {
  const width = 480.0;
  const height = width * 112 / 96; // 560 -> matches the 96:112 viewBox
  await tester.binding.setSurfaceSize(const Size(width, height));
  await tester.pumpWidget(
    RepaintBoundary(
      key: const ValueKey<String>('svg-golden'),
      child: SizedBox(
        width: width,
        height: height,
        child: SvgPicture.asset(
          asset,
          width: width,
          height: height,
        ),
      ),
    ),
  );
  // Vector graphics decode happens on a real async isolate/thread.
  await tester
      .runAsync(() => Future<void>.delayed(const Duration(milliseconds: 500)));
  await tester.pump();
  await expectLater(
    find.byKey(const ValueKey<String>('svg-golden')),
    matchesGoldenFile(goldenName),
  );
  await tester.binding.setSurfaceSize(null);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  for (final theme in ['w', 'dark']) {
    testWidgets('$theme: map_icon.svg renders the reference design',
        (tester) async {
      await _renderGolden(
        tester,
        'assets/icons/map_icon_$theme.svg',
        'goldens/map_icon_$theme.png',
      );
    });
  }

  testWidgets('MapIcon picks the theme asset and keeps 96:112 ratio',
      (tester) async {
    isTrueDarkMode.value = false;
    await tester.pumpWidget(const MaterialApp(home: MapIcon()));
    await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 300)));
    await tester.pump();
    final wLoader = tester
        .widget<SvgPicture>(find.byType(SvgPicture).first)
        .bytesLoader;
    expect((wLoader as dynamic).assetName, 'assets/icons/map_icon_w.svg');
    expect(
      tester.widget<SvgPicture>(find.byType(SvgPicture).first).width,
      92,
    );

    isTrueDarkMode.value = true;
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pump(const Duration(milliseconds: 600));
    final dLoader = tester
        .widget<SvgPicture>(find.byType(SvgPicture).first)
        .bytesLoader;
    expect((dLoader as dynamic).assetName, 'assets/icons/map_icon_dark.svg');
    isTrueDarkMode.value = false;
  });
}