import 'package:flutter/material.dart';
import 'package:ticboom/core/styles/app_colors.dart';
import 'package:ticboom/core/styles/app_text_styles.dart';
import 'package:ticboom/core/view/widgets/app_bottom_nav.dart';

/// Placeholder per la rotta `vault-records` (archivio record/partite).
class VaultRecordsPage extends StatelessWidget {
  const VaultRecordsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        surfaceTintColor: AppColors.surface,
        elevation: 0,
        centerTitle: false,
        title: Text(
          'VAULT',
          style: AppTextStyles.headlineMd.copyWith(
            fontSize: 16,
            letterSpacing: 1.1,
            color: AppColors.primary,
          ),
        ),
      ),
      body: const Center(
        child: Text(
          'Coming soon',
          style: TextStyle(color: AppColors.onSurfaceVariant),
        ),
      ),
      bottomNavigationBar: const AppBottomNav(),
    );
  }
}
