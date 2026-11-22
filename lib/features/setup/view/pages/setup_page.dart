import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ticboom/core/game/timer_range.dart';
import 'package:ticboom/core/styles/app_colors.dart';
import 'package:ticboom/core/styles/app_text_styles.dart';
import 'package:ticboom/core/view/widgets/app_bottom_nav.dart';
import 'package:ticboom/data/questions.dart';
import 'package:ticboom/features/setup/view/controllers/setup_controller.dart';
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
              const _SetupHeader(),
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
              const SizedBox(height: 6),
              Text(
                l10n.setupSubtitle,
                style: AppTextStyles.body.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 24),
              _PlayersCard(controller: controller),
              const SizedBox(height: 24),
              _CategoriesSection(controller: controller),
              const SizedBox(height: 16),
              _CustomCategoryCard(l10n: l10n),
              const SizedBox(height: 24),
              _DetonatorRow(controller: controller),
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
            child: _StartGameCta(controller: controller),
          ),
          const AppBottomNav(),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Header con logo e badge Edition
// ─────────────────────────────────────────────────────────────────────────────

class _SetupHeader extends StatelessWidget {
  const _SetupHeader();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Row(
      children: [
        Text(
          'TICBOOM',
          style: AppTextStyles.headlineMd.copyWith(
            color: AppColors.primaryContainer,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            l10n.edition.toUpperCase(),
            style: AppTextStyles.labelMono.copyWith(
              fontSize: 9,
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Card numero di giocatori (stepper 2-20, default 4)
// ─────────────────────────────────────────────────────────────────────────────

class _PlayersCard extends StatelessWidget {
  const _PlayersCard({required this.controller});

  final SetupController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Obx(
      () => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainer,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.outlineVariant),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.giocatoriAlTavolo,
                  style: AppTextStyles.titleCard.copyWith(
                    color: AppColors.onSurface,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerHigh,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    '${controller.playerCount.value} ${l10n.partecipanti}',
                    style: AppTextStyles.labelMono.copyWith(
                      color: AppColors.primaryContainer,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              l10n.rangeAmmissibile,
              style: AppTextStyles.body.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _StepperButton(
                  icon: Icons.remove,
                  semanticLabel: l10n.riduciGiocatori,
                  onPressed: controller.decrementPlayers,
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        '${controller.playerCount.value}',
                        style: AppTextStyles.displayHero.copyWith(
                          color: AppColors.primaryContainer,
                          fontSize: 44,
                          height: 1.0,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        l10n.giocatoriAlTavolo,
                        style: AppTextStyles.labelMono.copyWith(
                          color: AppColors.onSurfaceVariant,
                          fontSize: 9,
                        ),
                      ),
                    ],
                  ),
                ),
                _StepperButton(
                  icon: Icons.add,
                  semanticLabel: l10n.aumentaGiocatori,
                  onPressed: controller.incrementPlayers,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StepperButton extends StatelessWidget {
  const _StepperButton({
    required this.icon,
    required this.semanticLabel,
    required this.onPressed,
  });

  final IconData icon;
  final String semanticLabel;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel,
      button: true,
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon),
        style: IconButton.styleFrom(
          backgroundColor: AppColors.surfaceContainerHigh,
          foregroundColor: AppColors.primaryContainer,
          shape: const CircleBorder(),
          padding: const EdgeInsets.all(14),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Sezione categorie (griglia 2 colonne, multi-selezione)
// ─────────────────────────────────────────────────────────────────────────────

class _CategoriesSection extends StatelessWidget {
  const _CategoriesSection({required this.controller});

  final SetupController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.scegliLeCategorie,
                style: AppTextStyles.titleCard.copyWith(
                  color: AppColors.onSurface,
                ),
              ),
              Text(
                '${controller.selectedCount}/${controller.totalCount}',
                style: AppTextStyles.labelAction.copyWith(
                  color: AppColors.primaryContainer,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.45,
            children: SetupController.categorie
                .map(
                  (categoria) => _CategoryCard(
                    categoria: categoria,
                    isSelected: controller.isSelected(categoria),
                    onTap: () => controller.toggleCategory(categoria),
                  ),
                )
                .toList(growable: false),
          ),
          const SizedBox(height: 8),
          Center(
            child: TextButton(
              onPressed: controller.selectedCount == controller.totalCount
                  ? controller.deselectAll
                  : controller.selectAll,
              child: Text(
                controller.selectedCount == controller.totalCount
                    ? l10n.deselezionaTutte
                    : l10n.selezionaTutte,
                style: AppTextStyles.labelAction.copyWith(
                  color: AppColors.primaryContainer,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({
    required this.categoria,
    required this.isSelected,
    required this.onTap,
  });

  final String categoria;
  final bool isSelected;
  final VoidCallback onTap;

  static const Map<String, (IconData, Color)> _visuals = {
    'ANIMALI': (Icons.pets, AppColors.primaryContainer),
    'CIBO E BEVANDE': (Icons.restaurant, AppColors.secondaryContainer),
    'CALCIO': (Icons.sports_soccer, AppColors.tertiaryContainer),
    'ANIME': (Icons.auto_awesome, AppColors.primaryFixed),
  };

  String _label(AppLocalizations l10n) {
    return switch (categoria) {
      'ANIMALI' => l10n.categoriaAnimali,
      'CIBO E BEVANDE' => l10n.categoriaCiboBevande,
      'CALCIO' => l10n.categoriaCalcio,
      'ANIME' => l10n.categoriaAnime,
      _ => categoria,
    };
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final (icon, color) = _visuals[categoria] ?? (Icons.category, AppColors.onSurfaceVariant);
    final domande = gameQuestions[categoria]?.length ?? 0;

    return Material(
      color: isSelected
          ? AppColors.surfaceContainerHigh
          : AppColors.surfaceContainer,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? color : AppColors.outlineVariant,
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(icon, size: 20, color: color),
                  if (isSelected)
                    Icon(Icons.check_circle, size: 18, color: color),
                ],
              ),
              Text(
                _label(l10n).toUpperCase(),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.labelPill.copyWith(
                  color: isSelected
                      ? AppColors.onSurface
                      : AppColors.onSurfaceVariant,
                ),
              ),
              Text(
                l10n.domandeDisponibili(domande),
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Card "+ Categoria Personalizzata": visibile ma completamente disabilitata
// ─────────────────────────────────────────────────────────────────────────────

class _CustomCategoryCard extends StatelessWidget {
  const _CustomCategoryCard({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      // Visibile ma inerte: la funzionalità non è disponibile in questa
      // versione (richiesta esplicita: nessuna categoria personalizzata).
      opacity: 0.4,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainer,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.outlineVariant),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: AppColors.surfaceContainerHigh,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.add,
                size: 18,
                color: AppColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.categoriaPersonalizzata,
                    style: AppTextStyles.titleSmall.copyWith(
                      color: AppColors.onSurface,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    l10n.categoriaPersonalizzataDesc,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward,
              size: 18,
              color: AppColors.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Riga "Detonatore Casuale" con scelta tra i range disponibili
// ─────────────────────────────────────────────────────────────────────────────

class _DetonatorRow extends StatelessWidget {
  const _DetonatorRow({required this.controller});

  final SetupController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primaryFixedDim.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.timer,
              size: 20,
              color: AppColors.primaryContainer,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.detonatoreCasuale,
                  style: AppTextStyles.titleSmall.copyWith(
                    color: AppColors.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  l10n.detonatoreDescrizione,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Range selezionabili: scelta mutuamente esclusiva; la durata
          // estratta resta comunque segreta ai giocatori.
          Obx(
            () => Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (final range in TimerRange.disponibili)
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: _RangeChip(
                      range: range,
                      isSelected: controller.isSelectedTimerRange(range),
                      onTap: () => controller.selectTimerRange(range),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RangeChip extends StatelessWidget {
  const _RangeChip({
    required this.range,
    required this.isSelected,
    required this.onTap,
  });

  final TimerRange range;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isSelected
          ? AppColors.surfaceContainerHigh
          : Colors.transparent,
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: isSelected
                  ? AppColors.primaryContainer
                  : AppColors.outlineVariant,
            ),
          ),
          child: Text(
            range.label,
            style: AppTextStyles.labelAction.copyWith(
              fontSize: 12,
              color: isSelected
                  ? AppColors.primaryContainer
                  : AppColors.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// CTA "INIZIA PARTITA" (sticky, disabilitata senza categorie)
// ─────────────────────────────────────────────────────────────────────────────

class _StartGameCta extends StatelessWidget {
  const _StartGameCta({required this.controller});

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
          children: [
            Icon(
              Icons.local_fire_department,
              color: canStart
                  ? AppColors.onPrimaryContainer
                  : AppColors.onSurfaceVariant,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                l10n.iniziaPartita,
                textAlign: TextAlign.center,
                style: AppTextStyles.labelAction.copyWith(
                  color: canStart
                      ? AppColors.onPrimaryContainer
                      : AppColors.onSurfaceVariant,
                ),
              ),
            ),
            Text(
              '${controller.selectedCount}/${controller.totalCount} '
              '${l10n.attive}',
              style: AppTextStyles.labelMono.copyWith(
                color: canStart
                    ? AppColors.onPrimaryContainer
                    : AppColors.onSurfaceVariant,
                fontSize: 10,
              ),
            ),
          ],
        ),
      );
    });
  }
}
