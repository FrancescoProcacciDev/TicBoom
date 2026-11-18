import 'package:flutter/material.dart';
import 'package:ticboom/core/styles/app_colors.dart';
import 'package:ticboom/core/styles/app_text_styles.dart';
import 'package:ticboom/core/view/widgets/app_bottom_nav.dart';

/// Placeholder per la rotta `how-to-play-rules` (Regole).
class RulesPage extends StatelessWidget {
  const RulesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                'Rules',
                style: AppTextStyles.headline.copyWith(
                  color: AppColors.primaryContainer,
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                  'Coming soon',
                  style: AppTextStyles.labelAction.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const AppBottomNav(),
    );
  }
}
