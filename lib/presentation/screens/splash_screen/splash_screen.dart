import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:anuncia_mi_llegada/presentation/screens/selectors/selector_screen/selector_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;

  static const _cardSize = Size(250, 121);

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(milliseconds: 500), () {
      if (mounted) {
        context.goNamed(SelectorScreen.name);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF26400),
      body: Center(
        child: SvgPicture.asset(
          'assets/images/appcard.svg',
          width: _cardSize.width,
          height: _cardSize.height,
        ),
      ),
    );
  }
}
