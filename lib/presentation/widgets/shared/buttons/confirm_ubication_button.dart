import 'package:anuncia_mi_llegada/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inner_shadow/flutter_inner_shadow.dart';
import 'package:go_router/go_router.dart';

class ConfirmUbicationButton extends StatelessWidget {
  const ConfirmUbicationButton({super.key, this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isTrueDarkMode,
      builder: (context, isDark, _) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: Opacity(
            opacity: 0.87,
            child: Material(
              color: Color(0xFFF69346),
              child: InkWell(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                onTap: onTap ?? context.pop,
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
                      'Confirmar ubicación',
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
        );
      },
    );
  }
}
