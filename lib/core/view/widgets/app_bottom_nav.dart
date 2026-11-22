import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ticboom/core/routing/app_route.dart';
import 'package:ticboom/core/styles/app_colors.dart';
import 'package:ticboom/core/styles/app_text_styles.dart';
import 'package:ticboom/l10n/app_localizations.dart';

/// Bottom nav fissa traslucida del design reference minimale: Lobby / Config,
/// voce attiva colorata (solo colore, senza scale),
/// contenuta in larghezza (max-w-md) e centrata.
class AppBottomNav extends StatelessWidget {
  const AppBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final currentLocation = GoRouterState.of(context).matchedLocation;

    final items = <_BottomNavItem>[
      _BottomNavItem(
        label: l10n.navLobby,
        icon: Icons.dashboard,
        path: AppRoute.home.path,
      ),
      _BottomNavItem(
        label: l10n.navConfig,
        icon: Icons.tune,
        path: AppRoute.gameSettings.path,
      ),
    ];

    return ClipRect(
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: 24, sigmaY: 24),
        child: Container(
          decoration: const BoxDecoration(
            color: Color(0xD9121318), // surface @ 85%
            boxShadow: [
              BoxShadow(
                color: Color(0x40000000), // black @ 25%
                offset: Offset(0, -1),
                blurRadius: 12,
              ),
            ],
          ),
          child: SafeArea(
            top: false,
            // heightFactor: 1.0 — dentro bottomNavigationBar l'altezza
            // disponibile non è vincolata: senza questo, Center si espande
            // fino a riempire l'intero schermo e il Scaffold riduce il body
            // a altezza zero (schermo nero).
            child: Center(
              heightFactor: 1.0,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 448),
                child: SizedBox(
                  height: 64,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: items
                        .map(
                          (item) => _BottomNavItemView(
                            item: item,
                            isActive: currentLocation == item.path,
                            onTap: () => context.go(item.path),
                          ),
                        )
                        .toList(growable: false),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BottomNavItem {
  const _BottomNavItem({
    required this.label,
    required this.icon,
    required this.path,
  });

  final String label;
  final IconData icon;
  final String path;
}

class _BottomNavItemView extends StatelessWidget {
  const _BottomNavItemView({
    required this.item,
    required this.isActive,
    required this.onTap,
  });

  final _BottomNavItem item;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    // Voce attiva: solo cambio colore (primary-container), senza scale.
    final color = isActive
        ? AppColors.primaryContainer
        : AppColors.onSurfaceVariant;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: SizedBox(
        width: 64,
        height: 64,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(item.icon, size: 22, color: color),
            const SizedBox(height: 2),
            Text(
              item.label.toUpperCase(),
              style: AppTextStyles.labelMono.copyWith(
                fontSize: 9,
                letterSpacing: 1.0,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
