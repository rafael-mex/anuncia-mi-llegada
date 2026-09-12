import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class KeyboardReturnButton extends StatelessWidget {
  const KeyboardReturnButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        context.pop();
      },
      style: ButtonStyle(
        iconSize: WidgetStatePropertyAll(24),
        iconColor: WidgetStatePropertyAll(
          Color.fromRGBO(224, 114, 45, 100),
        ),
      ),
      icon: Icon(Icons.arrow_back_ios_new_outlined, size: 38),
    );
  }
}