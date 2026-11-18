import 'package:flutter/material.dart';

/// Palette replicata dal design reference HTML (tailwind.config).
/// Scheme scuro navy + accento giallo "party".
abstract final class AppColors {
  // ---------------------------------------------------------------------------
  // Background & surface (toni navy)
  // ---------------------------------------------------------------------------

  static const Color background = Color(0xFF101221);
  static const Color onBackground = Color(0xFFE1E1F6);

  static const Color surface = Color(0xFF101221);
  static const Color onSurface = Color(0xFFE1E1F6);
  static const Color surfaceDim = Color(0xFF101221);
  static const Color surfaceBright = Color(0xFF363849);
  static const Color surfaceContainerLowest = Color(0xFF0B0D1C);
  static const Color surfaceContainerLow = Color(0xFF191A2A);
  static const Color surfaceContainer = Color(0xFF1D1F2E);
  static const Color surfaceContainerHigh = Color(0xFF272939);
  static const Color surfaceContainerHighest = Color(0xFF323444);
  static const Color surfaceVariant = Color(0xFF323444);
  static const Color onSurfaceVariant = Color(0xFFD0C6AE);
  static const Color surfaceTint = Color(0xFFECC236);

  static const Color outline = Color(0xFF99907A);
  static const Color outlineVariant = Color(0xFF4D4634);

  static const Color shadow = Color(0xFF000000);
  static const Color scrim = Color(0xFF000000);

  static const Color inverseSurface = Color(0xFFE1E1F6);
  static const Color onInverseSurface = Color(0xFF2D2F40);
  static const Color inversePrimary = Color(0xFF735C00);

  // ---------------------------------------------------------------------------
  // Primary (giallo "boom")
  // ---------------------------------------------------------------------------

  static const Color primary = Color(0xFFFFF4DD);
  static const Color onPrimary = Color(0xFF3C2F00);
  static const Color primaryContainer = Color(0xFFFFD447);
  static const Color onPrimaryContainer = Color(0xFF735B00);
  static const Color primaryFixed = Color(0xFFFFE087);
  static const Color primaryFixedDim = Color(0xFFECC236);
  static const Color onPrimaryFixed = Color(0xFF231A00);
  static const Color onPrimaryFixedVariant = Color(0xFF574500);

  // ---------------------------------------------------------------------------
  // Secondary (arancio caldo)
  // ---------------------------------------------------------------------------

  static const Color secondary = Color(0xFFFFB599);
  static const Color onSecondary = Color(0xFF5A1C00);
  static const Color secondaryContainer = Color(0xFFAA3C00);
  static const Color onSecondaryContainer = Color(0xFFFFD3C3);
  static const Color secondaryFixed = Color(0xFFFFDBCE);
  static const Color secondaryFixedDim = Color(0xFFFFB599);
  static const Color onSecondaryFixed = Color(0xFF370E00);
  static const Color onSecondaryFixedVariant = Color(0xFF7F2B00);

  // ---------------------------------------------------------------------------
  // Tertiary (rosa chiaro)
  // ---------------------------------------------------------------------------

  static const Color tertiary = Color(0xFFFFF2F1);
  static const Color onTertiary = Color(0xFF680013);
  static const Color tertiaryContainer = Color(0xFFFFCCCB);
  static const Color onTertiaryContainer = Color(0xFFBC0D2E);
  static const Color tertiaryFixed = Color(0xFFFFDAD9);
  static const Color tertiaryFixedDim = Color(0xFFFFB3B2);
  static const Color onTertiaryFixed = Color(0xFF410008);
  static const Color onTertiaryFixedVariant = Color(0xFF920020);

  // ---------------------------------------------------------------------------
  // Error
  // ---------------------------------------------------------------------------

  static const Color error = Color(0xFFFFB4AB);
  static const Color onError = Color(0xFF690005);
  static const Color errorContainer = Color(0xFF93000A);
  static const Color onErrorContainer = Color(0xFFFFDAD6);

  // ---------------------------------------------------------------------------
  // Semantici
  // ---------------------------------------------------------------------------

  static const Color info = surfaceContainerHigh;
  static const Color onInfo = onSurface;
  static const Color infoContainer = surfaceContainerHighest;
  static const Color onInfoContainer = onSurfaceVariant;

  static const Color success = primaryContainer;
  static const Color onSuccess = onPrimary;
  static const Color successContainer = primaryFixed;
  static const Color onSuccessContainer = onPrimaryFixed;

  static const Color warning = primaryFixedDim;
  static const Color onWarning = onPrimaryFixed;
  static const Color warningContainer = primaryContainer;
  static const Color onWarningContainer = onPrimary;

  static const Color danger = error;
  static const Color onDanger = onError;
  static const Color dangerContainer = errorContainer;
  static const Color onDangerContainer = onErrorContainer;

  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);

  // ---------------------------------------------------------------------------
  // Legacy aliases: nomi della palette precedente mappati ai toni più vicini
  // della nuova palette, per compatibilità con usi preesistenti.
  // ---------------------------------------------------------------------------

  static const Color night = surfaceContainerLowest;
  static const Color deepTeal = onPrimaryContainer;
  static const Color teal = primaryFixedDim;
  static const Color mint = primaryContainer;
  static const Color sand = onSurfaceVariant;
  static const Color amber = primaryFixedDim;
  static const Color orange = secondary;
  static const Color rust = secondaryContainer;
  static const Color red = errorContainer;
  static const Color wine = onSecondary;

  static const Color teal950 = surfaceContainerLowest;
  static const Color teal900 = surfaceContainerLow;
  static const Color teal800 = onPrimaryContainer;
  static const Color teal700 = onPrimaryContainer;
  static const Color teal600 = primaryFixedDim;
  static const Color teal300 = primaryContainer;
  static const Color teal100 = primaryFixed;
  static const Color teal50 = primary;

  static const Color sand900 = onPrimaryFixed;
  static const Color sand700 = onPrimaryContainer;
  static const Color sand500 = onSurfaceVariant;
  static const Color sand200 = onSurface;
  static const Color sand100 = inverseSurface;
  static const Color sand50 = tertiary;

  static const Color amber900 = onPrimaryFixedVariant;
  static const Color amber800 = onPrimaryContainer;
  static const Color amber700 = onPrimaryContainer;
  static const Color amber600 = secondaryContainer;
  static const Color amber500 = primaryFixedDim;
  static const Color amber200 = primaryFixed;
  static const Color amber100 = primaryFixed;

  static const Color red950 = errorContainer;
  static const Color red900 = onError;
  static const Color red800 = errorContainer;
  static const Color red700 = secondaryContainer;
  static const Color red600 = secondaryContainer;
  static const Color red100 = onErrorContainer;
  static const Color red50 = tertiaryContainer;
}
