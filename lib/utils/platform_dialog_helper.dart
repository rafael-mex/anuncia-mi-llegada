import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PlatformDialogAction {
  final String text;
  final bool isDestructive;
  final VoidCallback? onPressed;

  const PlatformDialogAction({
    required this.text,
    this.isDestructive = false,
    this.onPressed,
  });
}

Future<void> showPlatformDialog({
  required BuildContext context,
  required String title,
  required String content,
  required List<PlatformDialogAction> actions,
}) {
  final isIOS = Theme.of(context).platform == TargetPlatform.iOS;

  if (isIOS) {
    return showCupertinoDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(content),
        actions: actions
            .map(
              (action) => CupertinoDialogAction(
                isDestructiveAction: action.isDestructive,
                onPressed: () {
                  Navigator.pop(dialogContext);
                  action.onPressed?.call();
                },
                child: Text(action.text),
              ),
            )
            .toList(),
      ),
    );
  }

  return showDialog<void>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: actions
          .map(
            (action) => TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                action.onPressed?.call();
              },
              child: Text(action.text),
            ),
          )
          .toList(),
    ),
  );
}