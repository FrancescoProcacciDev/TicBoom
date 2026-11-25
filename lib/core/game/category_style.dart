import 'package:flutter/material.dart';

import 'package:ticboom/core/styles/app_colors.dart';

/// Stile visivo condiviso delle categorie: icona e colore d'accento per
/// ogni chiave built-in. Le categorie personalizzate (o comunque non
/// mappate) ricevono l'icona e il colore di fallback.
abstract final class CategoryStyle {
  /// Icona delle categorie senza voce dedicata nella mappa.
  static const IconData fallbackIcon = Icons.category;

  /// Colore d'accento delle categorie senza voce dedicata nella mappa.
  static const Color fallbackColor = AppColors.onSurfaceVariant;

  /// Icona e colore d'accento di ogni categoria built-in (le chiavi sono
  /// le stesse dell'asset `assets/data/questions.json`).
  static const Map<String, (IconData, Color)> visuals = {
    'ANIMALI': (Icons.pets, AppColors.primaryContainer),
    'CIBO E BEVANDE': (Icons.restaurant, AppColors.secondaryContainer),
    'CALCIO': (Icons.sports_soccer, AppColors.tertiaryContainer),
    'ANIME': (Icons.auto_awesome, AppColors.primaryFixed),
    'GEOGRAFIA': (Icons.public, AppColors.primaryContainer),
    'FILM E SERIE TV': (Icons.movie, AppColors.secondaryContainer),
    'MUSICA': (Icons.music_note, AppColors.tertiaryContainer),
    'VIDEOGIOCHI': (Icons.videogame_asset, AppColors.primaryFixed),
    'VITA QUOTIDIANA': (Icons.home, AppColors.primaryContainer),
    'CULTURA GENERALE': (Icons.school, AppColors.secondaryContainer),
    'SUPEREROI E FUMETTI': (Icons.shield, AppColors.tertiaryContainer),
    'PAROLE E LETTERE': (Icons.abc, AppColors.primaryFixed),
  };

  /// Icona della categoria, con fallback per le personalizzate.
  static IconData iconFor(String categoria) =>
      (visuals[categoria] ?? (fallbackIcon, fallbackColor)).$1;

  /// Icona e colore d'accento della categoria, con fallback.
  static (IconData, Color) visualFor(String categoria) =>
      visuals[categoria] ?? (fallbackIcon, fallbackColor);
}
