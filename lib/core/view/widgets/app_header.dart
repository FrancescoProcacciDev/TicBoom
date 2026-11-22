import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ticboom/core/styles/app_colors.dart';
import 'package:ticboom/core/styles/app_text_styles.dart';
import 'package:ticboom/l10n/app_localizations.dart';

/// Header fisso condiviso delle schermate principali (home, regole):
/// brand TICBOOM + badge EDITION + toggle audio.
///
/// Overlay traslucido: surface @ 80% con blur (backdrop-blur-xl del
/// riferimento), SafeArea top e barra alta 64. Lo stato audio resta di
/// competenza della feature: il widget riceve l'Rx e il callback.
class AppHeader extends StatelessWidget {
  const AppHeader({
    super.key,
    required this.isMuted,
    required this.onToggleSoundFx,
  });

  /// Stato audio persistito della feature ( HomeController.isMuted ).
  final RxBool isMuted;

  /// Toggle audio della feature ( HomeController.toggleSoundFx ).
  final VoidCallback onToggleSoundFx;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return ClipRect(
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: 24, sigmaY: 24),
        child: Container(
          decoration: const BoxDecoration(
            color: Color(0xCC121318), // surface @ 80%
            boxShadow: [
              BoxShadow(
                color: Color(0x26000000), // black @ 15%
                offset: Offset(0, 1),
                blurRadius: 8,
              ),
            ],
          ),
          child: SafeArea(
            top: true,
            bottom: false,
            child: SizedBox(
              height: 64,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Text(
                      'TICBOOM',
                      style: AppTextStyles.headlineMd.copyWith(
                        fontSize: 16,
                        letterSpacing: 1.1,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerHigh,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        l10n.edition.toUpperCase(),
                        style: AppTextStyles.labelMono.copyWith(
                          fontSize: 10,
                          color: AppColors.outline,
                        ),
                      ),
                    ),
                    const Spacer(),
                    _SoundButton(isMuted: isMuted, onTap: onToggleSoundFx),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SoundButton extends StatelessWidget {
  const _SoundButton({required this.isMuted, required this.onTap});

  final RxBool isMuted;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => GestureDetector(
        onTap: onTap,
        child: Container(
          width: 44,
          height: 44,
          alignment: Alignment.center,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
          child: Icon(
            isMuted.value ? Icons.volume_off : Icons.volume_up,
            size: 20,
            color: AppColors.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}
