import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:ticboom/core/routing/app_route.dart';
import 'package:ticboom/core/styles/app_colors.dart';
import 'package:ticboom/core/styles/app_text_styles.dart';
import 'package:ticboom/core/view/widgets/app_snack_bar.dart';
import 'package:ticboom/features/setup/view/controllers/setup_controller.dart';
import 'package:ticboom/features/setup/view/widgets/custom_category_row.dart';
import 'package:ticboom/l10n/app_localizations.dart';

/// Sezione "Categorie personalizzate": righe selezionabili con azioni di
/// modifica ed eliminazione. Nascosta finché non esiste almeno una custom.
class CustomCategoriesSection extends StatelessWidget {
  const CustomCategoriesSection({super.key, required this.controller});

  final SetupController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Obx(() {
      final personalizzate = controller.categorieCustom;
      if (personalizzate.isEmpty) {
        return const SizedBox.shrink();
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.categoriePersonalizzate,
            style: AppTextStyles.titleCard.copyWith(color: AppColors.onSurface),
          ),
          const SizedBox(height: 12),
          for (final categoria in personalizzate)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: CustomCategoryRow(
                categoria: categoria,
                domande: controller.questionCount(categoria),
                isSelected: controller.isSelected(categoria),
                onTap: () => controller.toggleCategory(categoria),
                onEdit: () => Get.find<GoRouter>().push(
                  AppRoute.customCategory.path,
                  extra: categoria,
                ),
                onDelete: () =>
                    _confermaEliminazione(context, controller, categoria),
              ),
            ),
        ],
      );
    });
  }

  /// Dialog di conferma eliminazione di una categoria personalizzata:
  /// annulla → nessun cambiamento; conferma → rimozione definitiva.
  Future<void> _confermaEliminazione(
    BuildContext context,
    SetupController controller,
    String categoria,
  ) async {
    final l10n = AppLocalizations.of(context);
    final elimina = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.surfaceContainer,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          l10n.eliminaCategoriaTitolo,
          style: AppTextStyles.titleCard.copyWith(color: AppColors.onSurface),
        ),
        content: Text(
          l10n.eliminaCategoriaTesto(categoria),
          style: AppTextStyles.body.copyWith(color: AppColors.onSurfaceVariant),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(
              l10n.eliminaCategoriaAnnulla,
              style: AppTextStyles.labelAction.copyWith(
                color: AppColors.primaryContainer,
                fontSize: 13,
              ),
            ),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.secondaryContainer,
              foregroundColor: AppColors.onSecondaryContainer,
            ),
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l10n.eliminaCategoriaConferma),
          ),
        ],
      ),
    );
    if (elimina ?? false) {
      await controller.deleteCustomCategory(categoria);
      if (context.mounted) {
        showAppSnackBar(context, l10n.categoriaEliminata);
      }
    }
  }
}
