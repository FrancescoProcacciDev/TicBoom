import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ticboom/core/game/timer_range.dart';
import 'package:ticboom/core/styles/app_colors.dart';
import 'package:ticboom/core/styles/app_text_styles.dart';
import 'package:ticboom/features/setup/view/controllers/setup_controller.dart';
import 'package:ticboom/l10n/app_localizations.dart';

/// Riga "Detonatore Casuale" con scelta tra i range disponibili.
class DetonatorRow extends StatelessWidget {
  const DetonatorRow({super.key, required this.controller});

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

/// Chip di selezione di un range (privata: solo uso locale).
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
      color: isSelected ? AppColors.surfaceContainerHigh : Colors.transparent,
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
