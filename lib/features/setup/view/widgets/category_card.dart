import 'package:flutter/material.dart';
import 'package:ticboom/core/game/category_style.dart';
import 'package:ticboom/core/styles/app_colors.dart';
import 'package:ticboom/core/styles/app_text_styles.dart';
import 'package:ticboom/features/setup/view/widgets/category_icon_badge.dart';
import 'package:ticboom/l10n/app_localizations.dart';

/// Card di una categoria predefinita nella griglia: selezione al tap.
class CategoryCard extends StatelessWidget {
  const CategoryCard({
    super.key,
    required this.categoria,
    required this.isSelected,
    required this.onTap,
  });

  final String categoria;
  final bool isSelected;
  final VoidCallback onTap;

  String _label(AppLocalizations l10n) {
    return switch (categoria) {
      'ANIMALI' => l10n.categoriaAnimali,
      'CIBO E BEVANDE' => l10n.categoriaCiboBevande,
      'CALCIO' => l10n.categoriaCalcio,
      'ANIME' => l10n.categoriaAnime,
      'GEOGRAFIA' => l10n.categoriaGeografia,
      'FILM E SERIE TV' => l10n.categoriaFilmSerieTv,
      'MUSICA' => l10n.categoriaMusica,
      'VIDEOGIOCHI' => l10n.categoriaVideogiochi,
      'VITA QUOTIDIANA' => l10n.categoriaVitaQuotidiana,
      'CULTURA GENERALE' => l10n.categoriaCulturaGenerale,
      'SUPEREROI E FUMETTI' => l10n.categoriaSupereroiFumetti,
      'PAROLE E LETTERE' => l10n.categoriaParoleLettere,
      _ => categoria,
    };
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final (icon, color) = CategoryStyle.visualFor(categoria);

    return Material(
      color: isSelected
          ? AppColors.surfaceContainerHigh
          : AppColors.surfaceContainer,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            // Tinta leggera del colore della categoria quando selezionata.
            color: isSelected
                ? color.withValues(alpha: 0.08)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? color : AppColors.outlineVariant,
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CategoryIconBadge(icon: icon, color: color),
                  if (isSelected)
                    Icon(Icons.check_circle, size: 18, color: color),
                ],
              ),
              const SizedBox(height: 8),
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
            ],
          ),
        ),
      ),
    );
  }
}
