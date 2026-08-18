import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:anuncia_mi_llegada/presentation/screens/selectors/transports/transports_screen.dart';


class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  Timer? _timer;

  static const _cardSize = Size(250, 121);

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(seconds: 2), () {
      if (mounted) {
        context.goNamed(TransportsScreen.name);
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
        child: Image.asset(
          'assets/images/Appcard.png',
          width: _cardSize.width,
          height: _cardSize.height,
        ),
      ),
    );
  }
}
