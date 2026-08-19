import 'package:anuncia_mi_llegada/presentation/screens/settings/settings_screen.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_inner_shadow/flutter_inner_shadow.dart';
import 'package:google_fonts/google_fonts.dart';

class TransportsScreen extends StatelessWidget {
  static const name = 'transports_screen';

  const TransportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          //Transports Selector (selector de transportes)
          _TransportSelector(),
          //Map Icon for Light Mode (MAp Icon para el modo claro)
          Positioned(
            left: 0,
            right: 0,
            top: 115,
            child: Center(
              child: Image(
                image: AssetImage('assets/icons/Map_Icon_W.png'),
                width: 92,
                height: 109,
              ),
            ),
          ),
          //Settings button 
          Positioned(
            left: 0,
            right: 0,
            top: 794,
            child: Center(
              child: IconButton(
                iconSize: 24,
                color: Colors.orangeAccent,
                onPressed: () {
                  context.pushNamed(SettingsScreen.name);
                },
                icon: Icon(Icons.settings),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TransportSelector extends StatelessWidget {
  const _TransportSelector();

  @override
  Widget build(BuildContext context) {
    return Center(
      //--------- Contenedor naranja ---------
      child: SizedBox(
        width: 361,
        height: 336,
        child: Stack(
          children: [
            Positioned.fill(
              child: InnerShadow(
                shadows: [
                  Shadow(
                    color: const Color.fromRGBO(255, 255, 255, 40),
                    blurRadius: 10,
                    offset: const Offset(1, 1),
                  ),
                ],
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                    child: Container(
                      width: 361,
                      height: 336,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color.fromRGBO(234, 163, 103, 88),
                            Color.fromRGBO(232, 152, 86, 100),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
      //TODO: --------- Título del selector ---------
      //--------- Contenedor claro ---------
            Positioned(
              left: 0,
              right: 0,
              top: 66,
              child: Center(
                child: SizedBox(
                  width: 320,
                  height: 255,
                  child: Opacity(
                    opacity: 0.38,
                    child: InnerShadow(
                      shadows: [
                        Shadow(
                          color: const Color.fromRGBO(255, 255, 255, 40),
                          blurRadius: 10,
                          offset: const Offset(1, 1),
                        ),
                      ],
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                          child: Container(
                            width: 320,
                            height: 255,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24),
                              gradient: const LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Color.fromRGBO(249, 217, 191, 100),
                                  Color.fromRGBO(249, 215, 173, 100),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
