import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ticboom/core/routing/app_route.dart';
import 'package:ticboom/core/styles/app_colors.dart';
import 'package:ticboom/core/styles/app_text_styles.dart';
import 'package:ticboom/l10n/app_localizations.dart';

/// Bottom nav fissa traslucida del design reference: Party / Setup / Rules /
/// Settings, con voce attiva gialla evidenziata in base alla rotta corrente.
class AppBottomNav extends StatelessWidget {
  const AppBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final currentLocation = GoRouterState.of(context).matchedLocation;

    final items = <_BottomNavItem>[
      _BottomNavItem(
        label: l10n.navParty,
        icon: Icons.sports_esports,
        path: AppRoute.home.path,
      ),
      _BottomNavItem(
        label: l10n.navSetup,
        icon: Icons.tune,
        path: AppRoute.gameConfig.path,
      ),
      _BottomNavItem(
        label: l10n.navRules,
        icon: Icons.help_center,
        path: AppRoute.howToPlayRules.path,
      ),
      _BottomNavItem(
        label: l10n.navSettings,
        icon: Icons.settings,
        path: AppRoute.gameSettings.path,
      ),
    ];

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
        child: Container(
          decoration: const BoxDecoration(
            color: Color(0xD90B0D1C), // surfaceContainerLowest @ 85%
            boxShadow: [
              BoxShadow(
                color: Color(0x33000000), // black @ 20%
                offset: Offset(0, -4),
                blurRadius: 16,
              ),
            ],
          ),
          child: SafeArea(
            top: false,
            child: SizedBox(
              height: 80,
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
    final color = isActive ? AppColors.primaryContainer : AppColors.onSurfaceVariant;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: AnimatedScale(
        scale: isActive ? 1.05 : 1.0,
        duration: const Duration(milliseconds: 200),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 56, minHeight: 44),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(item.icon, size: 24, color: color),
              const SizedBox(height: 4),
              Text(
                item.label,
                style: AppTextStyles.labelPill.copyWith(
                  color: color,
                  fontWeight: isActive ? FontWeight.w700 : FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
