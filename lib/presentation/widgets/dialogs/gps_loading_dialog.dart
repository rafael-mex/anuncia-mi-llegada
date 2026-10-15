import 'package:anuncia_mi_llegada/theme/app_theme.dart';
import 'package:flutter/material.dart';

Future<void> showGpsLoadingDialog(
  BuildContext context, {
  required ValueNotifier<bool> cancelled,
}) async {
  await showDialog<void>(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.black.withValues(alpha: 0.7),
    builder: (dialogContext) => PopScope(
      canPop: false,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Obteniendo tu \nubicación...",
              style: AppTheme.metroStyle.copyWith(fontSize: 19),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            CircularProgressIndicator(color: const Color(0xFFF26400)),
            const SizedBox(height: 24),
            Text(
              "La tardanza de la obtención dependerá \nde la estabilidad de tu conexión",
              style: AppTheme.nunitoFamilySubtitle.copyWith(color: Colors.white),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            TextButton(
              onPressed: () {
                cancelled.value = true;
                Navigator.of(dialogContext).pop();
              },
              child: Text(
                "Cancelar",
                style: AppTheme.nunitoFamilyCustomButton.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),

      /* AlertDialog(
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
                "Obteniendo tu ubicación...",
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
      ), */
    )  
  );
}
