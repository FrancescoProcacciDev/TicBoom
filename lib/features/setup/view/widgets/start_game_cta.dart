import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ticboom/core/styles/app_colors.dart';
import 'package:ticboom/core/styles/app_text_styles.dart';
import 'package:ticboom/features/setup/view/controllers/setup_controller.dart';
import 'package:ticboom/l10n/app_localizations.dart';

/// CTA "INIZIA PARTITA" (sticky, disabilitata senza categorie).
class StartGameCta extends StatelessWidget {
  const StartGameCta({super.key, required this.controller});

  final SetupController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Obx(() {
      final canStart = controller.canStart;
      return FilledButton(
        onPressed: canStart ? controller.startGame : null,
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primaryContainer,
          disabledBackgroundColor: AppColors.surfaceContainerHigh,
          foregroundColor: AppColors.onPrimary,
          disabledForegroundColor: AppColors.onSurfaceVariant,
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              l10n.iniziaPartita,
              style: AppTextStyles.labelAction.copyWith(
                color: canStart
                    ? AppColors.onPrimaryContainer
                    : AppColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(width: 5),
            Icon(
              Icons.local_fire_department,
              color: canStart
                  ? AppColors.onPrimaryContainer
                  : AppColors.onSurfaceVariant,
            ),
          ],
        ),
      );
    });
  }
}
