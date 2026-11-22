import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ticboom/core/styles/app_colors.dart';
import 'package:ticboom/core/styles/app_text_styles.dart';
import 'package:ticboom/core/view/widgets/app_bottom_nav.dart';
import 'package:ticboom/core/view/widgets/app_header.dart';
import 'package:ticboom/core/view/widgets/bomb_vector.dart';
import 'package:ticboom/features/home/view/controllers/home_controller.dart';
import 'package:ticboom/l10n/app_localizations.dart';

/// Schermata "Menu principale minimale" replicata dal nuovo design reference
/// HTML: header fisso traslucido, pill pass-and-play, bombola vettoriale
/// grande con scintilla intermittente, CTA dorata, card secondarie e card di
/// stato. La logica (isMuted persistito, goProfile, ecc.) resta quella
/// esistente del controller.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppColors.surface,
      // Nav ancorata al fondo dello schermo via Scaffold: il body termina
      // sopra la barra e la safe area inferiore è gestita dalla barra stessa.
      bottomNavigationBar: const AppBottomNav(),
      body: Stack(
        children: [
          // Il viewport scrollabile riempie SEMPRE l'intero body (viewport
          // meno nav, altezza già imposta dallo Scaffold): Positioned.fill
          // impone vincoli tight, senza dipendere dallo shrink-wrap del
          // figlio non-posizionato dello Stack.
          Positioned.fill(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(top: 16 + 64, bottom: 24),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 448),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        _PassAndPlayPill(label: l10n.passAndPlayPill),
                        const SizedBox(height: 8),
                        const _BombHero(),
                        const SizedBox(height: 12),
                        _TitleGroup(l10n: l10n),
                        const SizedBox(height: 24),
                        _ActionZone(controller: controller, l10n: l10n),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Header fisso condiviso.
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            child: AppHeader(
              isMuted: controller.isMuted,
              onToggleSoundFx: controller.toggleSoundFx,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Pill "Pass-and-play da tavolo"
// ---------------------------------------------------------------------------

class _PassAndPlayPill extends StatelessWidget {
  const _PassAndPlayPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(999),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.15),
            offset: const Offset(0, 1),
            blurRadius: 2,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const _PulseDot(size: 6, color: AppColors.primaryContainer),
          const SizedBox(width: 8),
          Text(
            label.toUpperCase(),
            style: AppTextStyles.labelMono.copyWith(
              fontSize: 10,
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Hero: bombola grande + glow + badge READY
// ---------------------------------------------------------------------------

class _BombHero extends StatelessWidget {
  const _BombHero();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 256,
      height: 268,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          // Glow ambientale dietro la bombola.
          Positioned(
            top: 0,
            child: Container(
              width: 256,
              height: 256,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.primaryContainer.withValues(alpha: 0.10),
                    AppColors.primaryContainer.withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),
          ),
          Positioned(top: 8, child: const BombVector(size: Size(224, 224))),
          // Badge READY overlay.
          Positioned(
            bottom: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerHigh.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: AppColors.surfaceContainerHighest),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadow.withValues(alpha: 0.2),
                    offset: const Offset(0, 2),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primaryContainer,
                      boxShadow: const [
                        BoxShadow(color: Color(0xFFFBBF24), blurRadius: 8),
                      ],
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'READY',
                    style: AppTextStyles.labelMono.copyWith(
                      fontSize: 10,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Titolo + sottotitolo
// ---------------------------------------------------------------------------

class _TitleGroup extends StatelessWidget {
  const _TitleGroup({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text.rich(
          TextSpan(
            text: 'TIC',
            children: [
              TextSpan(
                text: 'BOOM',
                style: AppTextStyles.displayHero.copyWith(
                  color: AppColors.primaryContainer,
                ),
              ),
            ],
          ),
          style: AppTextStyles.displayHero.copyWith(color: AppColors.onSurface),
        ),
        const SizedBox(height: 8),
        Text(
          l10n.paroleSottoPressione,
          textAlign: TextAlign.center,
          style: AppTextStyles.body.copyWith(color: AppColors.onSurfaceVariant),
        ),
        const SizedBox(height: 2),
        Text(
          l10n.chiHaLaBomba,
          textAlign: TextAlign.center,
          style: AppTextStyles.body.copyWith(
            color: AppColors.secondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Zona azioni: CTA, card secondarie, card di stato
// ---------------------------------------------------------------------------

class _ActionZone extends StatelessWidget {
  const _ActionZone({required this.controller, required this.l10n});

  final HomeController controller;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _PlayCta(controller: controller, label: l10n.giocaSubito),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _SecondaryCard(
                icon: Icons.menu_book,
                iconColor: AppColors.primary,
                label: l10n.regole,
                onTap: controller.goRules,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _SecondaryCard(
                icon: Icons.tune,
                iconColor: AppColors.primary,
                label: l10n.setup,
                onTap: controller.goSettings,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _StatusCard(label: l10n.multiplayerStatus),
      ],
    );
  }
}

class _PlayCta extends StatefulWidget {
  const _PlayCta({required this.controller, required this.label});

  final HomeController controller;
  final String label;

  @override
  State<_PlayCta> createState() => _PlayCtaState();
}

class _PlayCtaState extends State<_PlayCta> {
  bool _pressed = false;

  Future<void> _handleTap() async {
    if (_pressed) {
      return;
    }
    setState(() => _pressed = true);
    // Feedback tattile composito (replica navigator.vibrate([15,30,25])).
    HapticFeedback.mediumImpact();
    await Future<void>.delayed(const Duration(milliseconds: 120));
    if (!mounted) {
      return;
    }
    setState(() => _pressed = false);
    widget.controller.goPlay();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: _pressed ? 0.98 : 1.0,
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeOut,
      child: GestureDetector(
        onTap: _handleTap,
        child: Container(
          height: 54,
          decoration: BoxDecoration(
            color: AppColors.primaryContainer,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: Color(0x38FBBF24), // rgba(251,191,36,0.22)
                offset: Offset(0, 4),
                blurRadius: 20,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.play_arrow,
                size: 24,
                color: AppColors.onPrimaryFixed,
              ),
              const SizedBox(width: 8),
              Text(
                widget.label.toUpperCase(),
                style: AppTextStyles.labelAction.copyWith(
                  color: AppColors.onPrimaryFixed,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SecondaryCard extends StatelessWidget {
  const _SecondaryCard({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow.withValues(alpha: 0.15),
              offset: const Offset(0, 1),
              blurRadius: 2,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18, color: iconColor),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.body.copyWith(
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3,
                  color: AppColors.onSurface,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusCard extends StatelessWidget {
  const _StatusCard({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.15),
            offset: const Offset(0, 1),
            blurRadius: 2,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.phonelink_ring,
            size: 16,
            color: AppColors.tertiaryContainer,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.labelMono.copyWith(
                fontSize: 10,
                letterSpacing: 0.4,
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Widget animati privati (loop)
// ---------------------------------------------------------------------------

/// Puntino con pulse continuo (opacità che respira, `animate-pulse` del
/// riferimento).
class _PulseDot extends StatelessWidget {
  const _PulseDot({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return _LoopAnimationBuilder(
      duration: const Duration(milliseconds: 2000),
      builder: (context, value) {
        return Opacity(
          opacity: 0.4 + 0.6 * value,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(shape: BoxShape.circle, color: color),
          ),
        );
      },
    );
  }
}

/// AnimationController in loop riusato dai widget animati della pagina.
class _LoopAnimationBuilder extends StatefulWidget {
  const _LoopAnimationBuilder({required this.duration, required this.builder});

  final Duration duration;
  final Widget Function(BuildContext context, double value) builder;

  @override
  State<_LoopAnimationBuilder> createState() => _LoopAnimationBuilderState();
}

class _LoopAnimationBuilderState extends State<_LoopAnimationBuilder>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: widget.duration,
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) => widget.builder(context, _controller.value),
    );
  }
}
