import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:flutter/material.dart';

class PlatformDialogAction {
  final String text;
  final bool isDestructive;
  final bool isCancel;
  final VoidCallback? onPressed;

  const PlatformDialogAction({
    required this.text,
    this.isDestructive = false,
    this.isCancel = false,
    this.onPressed,
  });
}

Future<void> showPlatformDialog({
  required BuildContext context,
  required String title,
  required String content,
  required List<PlatformDialogAction> actions,
  bool barrierDismissible = true,
}) {
  final isIOS = Theme.of(context).platform == TargetPlatform.iOS;

  if (isIOS) {
    // Usa el alert nativo en iOS 26+ y CupertinoAlertDialog en versiones
    // anteriores. El paquete cierra el diálogo antes de invocar onPressed.
    return AdaptiveAlertDialog.show(
      context: context,
      barrierDismissible: barrierDismissible,
      title: title,
      message: content,
      actions: actions
          .map(
            (action) => AlertAction(
              title: action.text,
              style: action.isDestructive
                  ? AlertActionStyle.destructive
                  : action.isCancel
                  ? AlertActionStyle.cancel
                  : AlertActionStyle.defaultAction,
              onPressed: () => action.onPressed?.call(),
            ),
          )
          .toList(),
    );
  }

  return showDialog<void>(
    context: context,
    barrierDismissible: barrierDismissible,
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
