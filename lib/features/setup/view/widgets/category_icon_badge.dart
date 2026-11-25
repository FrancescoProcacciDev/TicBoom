import 'package:flutter/material.dart';

/// Icona della categoria nel cerchietto tinta: linguaggio condiviso dalle
/// card della griglia e dalle righe delle categorie personalizzate.
class CategoryIconBadge extends StatelessWidget {
  const CategoryIconBadge({super.key, required this.icon, required this.color});

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, size: 16, color: color),
    );
  }
}
