import 'package:flutter/material.dart';
import 'package:flutter_inner_shadow/flutter_inner_shadow.dart';
import 'package:go_router/go_router.dart';

class ReturnButton extends StatelessWidget {
  const ReturnButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      top: 690,
      child: Center(
        child: Opacity(
          opacity: 0.87,
          child: InnerShadow(
            shadows: const [
              Shadow(
                color: Color.fromRGBO(255, 255, 255, 40),
                blurRadius: 2,                  offset: Offset(1, 1),
              ),
            ],
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Material(
                color: Color.fromRGBO(113, 203, 248, 100),
                child: InkWell(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onTap: context.pop,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    child: InnerShadow(
                      shadows: const [
                          Shadow(
                            color: Color.fromRGBO(255, 255, 255, 44),
                            blurRadius: 10,
                            offset: Offset(1, 1),
                          ),
                        ],
                      child: const Text(
                        'Retroceder',
                        style: TextStyle(
                          color: Color.fromRGBO(255, 255, 255, 83),
                          height: 1.3,
                          fontFamily: 'Nunito',
                          fontSize: 17,
                          letterSpacing: 0,
                          fontWeight: FontWeight.w700,
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
    );
  }
}
