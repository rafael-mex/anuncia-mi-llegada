import 'package:anuncia_mi_llegada/theme/app_theme.dart';
import 'package:flutter/material.dart';

Future<void> showGpsLoadingDialog(
  BuildContext context, {
    required ValueNotifier<bool> cancelled,
  }) async {
    await showDialog<void>(
      context: context, 
      barrierDismissible: false,
      barrierColor: Colors.black.withValues(alpha: 0.6),
      builder: (dialogContext) => PopScope(
        canPop: false,
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(24),
          ),
          content: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const SizedBox(height: 10),
              const CircularProgressIndicator(),
              const SizedBox(height: 24),
              Text(
                "Obteniedno tu ubicación...",
                style: AppTheme.nunitoFamilySubtitle,
              ),
              const SizedBox(height: 24),
              TextButton(
                onPressed: () {
                  cancelled.value = true;
                  Navigator.of(dialogContext).pop();
                }, child: const Text(
                  "Cancelar",
                  style: AppTheme.nunitoFamilyCustomButton
                ),
              ),
          ],
        ),
      ),
    ),  
  );
}
