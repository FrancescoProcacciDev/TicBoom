import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ticboom/core/styles/app_colors.dart';
import 'package:ticboom/core/styles/app_text_styles.dart';
import 'package:ticboom/features/splash/view/controllers/splash_controller.dart';
import 'package:ticboom/l10n/app_localizations.dart';

/// Schermata "Splash / Caricamento miccia" replicata dal design reference
/// HTML.
///
/// StatelessWidget puro e completamente PASSIVO: nessuna interazione tattile
/// (nessun bottone, nessun gesture). La reattività passa da Obx (progress
/// della miccia osservato dal caricamento reale, puntini) e da piccoli widget
/// animati privati.
class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SplashController>();
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Stack(
        children: [
          const _DecorativeSparks(),
          SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: Column(
                  children: [
                    const SizedBox(height: 12),
                    _PartyBadgePill(label: l10n.partyGameEsplosivo),
                    const Expanded(
                      child: _HeroGroup(),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
                      child: _LoadingDock(controller: controller, l10n: l10n),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Hero centrale: logo, headline, sottotitolo, pill allerta
// ---------------------------------------------------------------------------

class _HeroGroup extends StatelessWidget {
  const _HeroGroup();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const _HeroLogo(),
          const SizedBox(height: 16),
          Text.rich(
            TextSpan(
              text: l10n.splashHeadline,
              children: [
                const TextSpan(text: '\n'),
                TextSpan(
                  text: l10n.splashHeadlineAccent,
                  style: AppTextStyles.displayHero.copyWith(
                    color: AppColors.primaryContainer,
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.center,
            style: AppTextStyles.displayHero.copyWith(
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            l10n.splashSubtitle,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 20),
          _DangerPill(label: l10n.explosionAlertLevel),
        ],
      ),
    );
  }
}

class _HeroLogo extends StatelessWidget {
  const _HeroLogo();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 232,
      height: 232,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Anello glow giallo ambientale dietro il logo.
          Container(
            width: 232,
            height: 232,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.primaryContainer.withValues(alpha: 0.25),
                  AppColors.primaryContainer.withValues(alpha: 0.0),
                ],
              ),
            ),
          ),
          Image.asset(
            'assets/images/logo.jpg',
            width: 208,
            height: 208,
            fit: BoxFit.contain,
          ),
          // Scintilla che fa "ping" accanto allo stoppino.
          const Positioned(top: 4, right: 24, child: _FlarePing()),
        ],
      ),
    );
  }
}

class _FlarePing extends StatelessWidget {
  const _FlarePing();

  @override
  Widget build(BuildContext context) {
    return _LoopAnimationBuilder(
      duration: const Duration(milliseconds: 1600),
      curve: Curves.easeOut,
      repeatReverse: false,
      builder: (context, value) {
        return Transform.scale(
          scale: 1.0 + value * 0.6,
          child: Opacity(
            opacity: (1 - value).clamp(0.0, 1.0) * 0.8,
            child: const Icon(
              Icons.flare,
              size: 40,
              color: AppColors.primaryContainer,
            ),
          ),
        );
      },
    );
  }
}

class _DangerPill extends StatelessWidget {
  const _DangerPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const _PingDot(size: 10, color: AppColors.secondaryContainer),
          const SizedBox(width: 8),
          Text(
            label,
            style: AppTextStyles.labelPill.copyWith(
              color: AppColors.secondary,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Pill top "Party Game Esplosivo"
// ---------------------------------------------------------------------------

class _PartyBadgePill extends StatelessWidget {
  const _PartyBadgePill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(999),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.15),
            offset: const Offset(0, 2),
            blurRadius: 6,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const _RotatingFire(),
          const SizedBox(width: 8),
          Text(
            label,
            style: AppTextStyles.labelPill.copyWith(
              color: AppColors.primary,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

class _RotatingFire extends StatelessWidget {
  const _RotatingFire();

  @override
  Widget build(BuildContext context) {
    return _LoopAnimationBuilder(
      duration: const Duration(seconds: 3),
      curve: Curves.linear,
      repeatReverse: false,
      builder: (context, value) {
        return Transform.rotate(
          angle: 2 * 3.14159 * value,
          child: const Icon(
            Icons.local_fire_department,
            size: 18,
            color: AppColors.primaryContainer,
          ),
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Card di caricamento
// ---------------------------------------------------------------------------

class _LoadingDock extends StatelessWidget {
  const _LoadingDock({required this.controller, required this.l10n});

  final SplashController controller;
  final AppLocalizations l10n;

  static const List<String> _dotFrames = ['.', '..', '...', ''];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.2),
            offset: const Offset(0, 8),
            blurRadius: 16,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Riga stato: "Caricamento miccia..." + percentuale.
          Row(
            children: [
              const Icon(
                Icons.timer,
                size: 20,
                color: AppColors.primaryContainer,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Obx(
                  () => Text(
                    '${l10n.loadingFuse}${_dotFrames[controller.dotFrame.value]}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.titleCard.copyWith(
                      color: AppColors.onSurface,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Obx(
                () => Text(
                  '${controller.percent.value}%',
                  style: AppTextStyles.labelAction.copyWith(
                    fontSize: 14,
                    color: AppColors.primaryContainer,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Traccia di detonazione: barra gialla con manopola lightning.
          _FuseTrack(controller: controller),
        ],
      ),
    );
  }
}

class _FuseTrack extends StatelessWidget {
  const _FuseTrack({required this.controller});

  final SplashController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 24,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(999),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(999),
        child: Obx(
          () => TweenAnimationBuilder<double>(
            tween: Tween(end: controller.percent.value / 100),
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
            builder: (context, fraction, _) => FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: fraction,
              child: Container(
                decoration: const BoxDecoration(
                  color: AppColors.primaryContainer,
                ),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Transform.translate(
                    // Manopola lightning sporgente sul bordo destro.
                    offset: const Offset(4, 0),
                    child: Container(
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.tertiaryContainer,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryContainer.withValues(
                              alpha: 0.8,
                            ),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.bolt,
                        size: 14,
                        color: AppColors.onTertiaryContainer,
                      ),
                    ),
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

// ---------------------------------------------------------------------------
// Decorazioni di sfondo: glows e stelle/sparkle sparse
// ---------------------------------------------------------------------------

class _DecorativeSparks extends StatelessWidget {
  const _DecorativeSparks();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Glow radiale pulsante in alto al centro.
        Positioned(
          top: 120,
          left: 0,
          right: 0,
          child: Center(
            child: _PulsingGlow(size: 288, color: AppColors.primaryContainer),
          ),
        ),
        // Glow caldo in basso.
        Positioned(
          bottom: 180,
          left: 0,
          right: 0,
          child: Center(
            child: _PulsingGlow(
              size: 240,
              color: AppColors.secondaryContainer,
              opacity: 0.2,
            ),
          ),
        ),
        // Stelle e sparkle sparsi.
        Positioned(
          top: 32,
          left: 32,
          child: _BouncingSparkle(size: 24, color: AppColors.primaryContainer),
        ),
        const Positioned(
          top: 96,
          right: 40,
          child: _StaticDot(size: 14, color: AppColors.secondary),
        ),
        const Positioned(
          top: 280,
          left: 24,
          child: _StaticStar(size: 20, color: AppColors.primaryContainer),
        ),
        Positioned(
          top: 380,
          right: 24,
          child: _PulsingSparkle(size: 26, color: AppColors.primaryContainer),
        ),
        const Positioned(
          bottom: 128,
          left: 40,
          child: _StaticDot(size: 10, color: AppColors.primary),
        ),
        const Positioned(
          bottom: 96,
          right: 48,
          child: _StaticStar(size: 18, color: AppColors.secondary),
        ),
      ],
    );
  }
}

class _PulsingGlow extends StatelessWidget {
  const _PulsingGlow({
    required this.size,
    required this.color,
    this.opacity = 0.15,
  });

  final double size;
  final Color color;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return _LoopAnimationBuilder(
      duration: const Duration(milliseconds: 2000),
      builder: (context, value) {
        return Opacity(
          opacity: 0.5 + 0.5 * value,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  color.withValues(alpha: opacity),
                  color.withValues(alpha: 0.0),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _BouncingSparkle extends StatelessWidget {
  const _BouncingSparkle({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return _LoopAnimationBuilder(
      duration: const Duration(milliseconds: 1200),
      curve: Curves.easeInOut,
      builder: (context, value) {
        return Transform.translate(
          offset: Offset(0, 6 * value - 3),
          child: Icon(Icons.star, size: size, color: color),
        );
      },
    );
  }
}

class _PulsingSparkle extends StatelessWidget {
  const _PulsingSparkle({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return _LoopAnimationBuilder(
      duration: const Duration(milliseconds: 2000),
      builder: (context, value) {
        return Opacity(
          opacity: 0.5 + 0.5 * value,
          child: Icon(Icons.auto_awesome, size: size, color: color),
        );
      },
    );
  }
}

class _StaticStar extends StatelessWidget {
  const _StaticStar({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Icon(Icons.star, size: size, color: color);
  }
}

class _StaticDot extends StatelessWidget {
  const _StaticDot({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}

// ---------------------------------------------------------------------------
// Widget animati privati (loop)
// ---------------------------------------------------------------------------

/// AnimationController in loop riusato dai widget animati della pagina.
class _LoopAnimationBuilder extends StatefulWidget {
  const _LoopAnimationBuilder({
    required this.duration,
    required this.builder,
    this.curve = Curves.easeInOut,
    this.repeatReverse = true,
  });

  final Duration duration;
  final Widget Function(BuildContext context, double value) builder;
  final Curve curve;
  final bool repeatReverse;

  @override
  State<_LoopAnimationBuilder> createState() => _LoopAnimationBuilderState();
}

class _LoopAnimationBuilderState extends State<_LoopAnimationBuilder>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: widget.duration,
  )..repeat(reverse: widget.repeatReverse);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: CurvedAnimation(parent: _controller, curve: widget.curve),
      builder: (context, _) => widget.builder(context, _controller.value),
    );
  }
}

/// Puntino con "ping" continuo (anello che si espande e svanisce).
class _PingDot extends StatelessWidget {
  const _PingDot({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size * 2,
      height: size * 2,
      child: Stack(
        alignment: Alignment.center,
        children: [
          _LoopAnimationBuilder(
            duration: const Duration(milliseconds: 1200),
            curve: Curves.easeOut,
            repeatReverse: false,
            builder: (context, value) {
              return Transform.scale(
                scale: 1.0 + value * 0.8,
                child: Opacity(
                  opacity: (1 - value).clamp(0.0, 1.0) * 0.7,
                  child: Container(
                    width: size,
                    height: size,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: color,
                    ),
                  ),
                ),
              );
            },
          ),
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(shape: BoxShape.circle, color: color),
          ),
        ],
      ),
    );
  }
}
