import 'package:flutter/material.dart';
import 'package:ticboom/core/game/category_style.dart';
import 'package:ticboom/core/styles/app_colors.dart';
import 'package:ticboom/core/styles/app_text_styles.dart';
import 'package:ticboom/features/setup/view/widgets/category_icon_badge.dart';
import 'package:ticboom/l10n/app_localizations.dart';

/// Riga di una categoria personalizzata: selezione al tap, modifiche ed
/// eliminazione tramite le azioni a destra.
class CustomCategoryRow extends StatelessWidget {
  const CustomCategoryRow({
    super.key,
    required this.categoria,
    required this.domande,
    required this.isSelected,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  final String categoria;

  /// Numero di domande della categoria (mostrato sotto il nome).
  final int domande;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

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
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? color : AppColors.outlineVariant,
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Row(
            children: [
              CategoryIconBadge(icon: icon, color: color),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      categoria.toUpperCase(),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.labelPill.copyWith(
                        color: isSelected
                            ? AppColors.onSurface
                            : AppColors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      l10n.domandeDisponibili(domande),
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              if (isSelected) Icon(Icons.check_circle, size: 18, color: color),
              _RowActionIcon(
                icon: Icons.edit_outlined,
                tooltip: l10n.modificaCategoriaTitolo,
                onPressed: onEdit,
              ),
              _RowActionIcon(
                icon: Icons.delete_outline,
                tooltip: l10n.eliminaCategoriaConferma,
                onPressed: onDelete,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Piccolo pulsante-icona delle azioni di riga (privato: solo uso locale).
class _RowActionIcon extends StatelessWidget {
  const _RowActionIcon({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      visualDensity: VisualDensity.compact,
      constraints: const BoxConstraints(),
      padding: const EdgeInsets.only(left: 8),
      iconSize: 18,
      color: AppColors.onSurfaceVariant,
      icon: Icon(icon),
      tooltip: tooltip,
      onPressed: onPressed,
    );
  }
}
