import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_inner_shadow/flutter_inner_shadow.dart';

class SelectorWidget extends StatelessWidget {
  final double orangeContainerWidth;
  final double orangeContainerHeight;
  final double glassContainerWidth;
  final double glassContainerHeight;
  final String selectorsTitle;
  final Widget? listContent; 

  const SelectorWidget({
    super.key,
    required this.selectorsTitle,
    this.orangeContainerWidth = 361, 
    this.orangeContainerHeight = 336,
    this.glassContainerWidth = 320,
    this.glassContainerHeight = 255,
    this.listContent,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      //--------- Orange Container ---------
      child: SizedBox(
        width: orangeContainerWidth, 
        height: orangeContainerHeight, 
        child: Stack(
          children: [
            Positioned.fill(
              child: Opacity(
                opacity: 0.87,
                child: InnerShadow(
                  shadows: const [
                    Shadow(
                      color: Color.fromRGBO(255, 255, 255, 40),
                      blurRadius: 10,
                      offset: Offset(1, 1),
                    ),
                  ],
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(40),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                      child: Container(
                        width: orangeContainerWidth,
                        height: orangeContainerHeight,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          gradient: const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color.fromRGBO(245, 146, 69, 88),
                              Color.fromRGBO(246, 147, 70, 100),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            //--------- Glass Container ---------
            Positioned(
              left: 0,
              right: 0,
              top: 66,
              child: Center(
                child: SizedBox(
                  width: glassContainerWidth,
                  height: glassContainerHeight, 
                  child: Opacity(
                    opacity: 0.38,
                    child: InnerShadow(
                      shadows: const [
                        Shadow(
                          color: Color.fromRGBO(255, 255, 255, 40),
                          blurRadius: 10,
                          offset: Offset(1, 1),
                        ),
                      ],
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                          child: Container(
                            width: glassContainerWidth,
                            height: glassContainerHeight,
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
                            // TODO: ListView
                            child: listContent, 
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            //--------- Selector's Title ---------
            Positioned(
              left: 0,
              right: 0,
              top: 14,
              child: Center(
                child: Text(
                  selectorsTitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    height: 1,
                    fontFamily: 'Nunito',
                    fontSize: 20,
                    letterSpacing: 0,
                    fontWeight: FontWeight.w800,
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