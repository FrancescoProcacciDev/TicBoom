import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ticboom/core/styles/app_colors.dart';
import 'package:ticboom/core/styles/app_text_styles.dart';
import 'package:ticboom/core/view/widgets/app_bottom_nav.dart';
import 'package:ticboom/features/setup/view/controllers/setup_controller.dart';
import 'package:ticboom/features/setup/view/widgets/categories_section.dart';
import 'package:ticboom/features/setup/view/widgets/custom_categories_section.dart';
import 'package:ticboom/features/setup/view/widgets/custom_category_card.dart';
import 'package:ticboom/features/setup/view/widgets/detonator_row.dart';
import 'package:ticboom/features/setup/view/widgets/setup_header.dart';
import 'package:ticboom/features/setup/view/widgets/start_game_cta.dart';
import 'package:ticboom/l10n/app_localizations.dart';

/// Schermata di configurazione della partita: numero di giocatori,
/// categorie attive e detonatore casuale, con CTA "Inizia partita".
class SetupPage extends StatelessWidget {
  const SetupPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final controller = Get.find<SetupController>();

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SetupHeader(),
              const SizedBox(height: 20),
              Text(
                l10n.setupEyebrow,
                style: AppTextStyles.labelMono.copyWith(
                  color: AppColors.primaryContainer,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                l10n.setupTitle,
                style: AppTextStyles.headline.copyWith(
                  color: AppColors.onSurface,
                ),
              ),
              // const SizedBox(height: 6),
              // Text(
              //   l10n.setupSubtitle,
              //   style: AppTextStyles.body.copyWith(
              //     color: AppColors.onSurfaceVariant,
              //   ),
              // ),
              const SizedBox(height: 24),
              // TODO(ripristino): nascondere il selettore giocatori finché non serve.
              // PlayersCard(controller: controller),
              // const SizedBox(height: 24),
              CategoriesSection(controller: controller),
              const SizedBox(height: 16),
              CustomCategoriesSection(controller: controller),
              const SizedBox(height: 16),
              const CustomCategoryCard(),
              const SizedBox(height: 24),
              DetonatorRow(controller: controller),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
            child: StartGameCta(controller: controller),
          ),
          const AppBottomNav(),
        ],
      ),
    );
  }
}
