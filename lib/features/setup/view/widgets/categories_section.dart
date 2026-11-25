import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ticboom/core/styles/app_colors.dart';
import 'package:ticboom/core/styles/app_text_styles.dart';
import 'package:ticboom/features/setup/view/controllers/setup_controller.dart';
import 'package:ticboom/features/setup/view/widgets/category_card.dart';
import 'package:ticboom/features/setup/view/widgets/pill_button.dart';
import 'package:ticboom/l10n/app_localizations.dart';

/// Sezione categorie: griglia 2 colonne con multi-selezione, estrazione
/// casuale e selezione/deselezione rapida.
class CategoriesSection extends StatelessWidget {
  const CategoriesSection({super.key, required this.controller});

  final SetupController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.scegliLeCategorie,
            style: AppTextStyles.titleCard.copyWith(color: AppColors.onSurface),
          ),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            mainAxisExtent: 104,
            children: controller.categorieBuiltIn
                .map(
                  (categoria) => CategoryCard(
                    categoria: categoria,
                    isSelected: controller.isSelected(categoria),
                    onTap: () => controller.toggleCategory(categoria),
                  ),
                )
                .toList(growable: false),
          ),
          const SizedBox(height: 16),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 12,
            runSpacing: 8,
            children: [
              PillButton(
                icon: Icons.shuffle,
                label: l10n.categoriaCasuale,
                onPressed: controller.selectRandomBuiltIn,
              ),
              PillButton(
                icon: Icons.done_all,
                label: controller.selectedCount == controller.totalCount
                    ? l10n.deselezionaTutte
                    : l10n.selezionaTutte,
                onPressed: controller.selectedCount == controller.totalCount
                    ? controller.deselectAll
                    : controller.selectAll,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
