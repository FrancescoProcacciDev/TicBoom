import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ticboom/core/styles/app_colors.dart';
import 'package:ticboom/core/styles/app_text_styles.dart';
import 'package:ticboom/core/view/widgets/app_bottom_nav.dart';
import 'package:ticboom/features/home/view/controllers/home_controller.dart';
import 'package:ticboom/l10n/app_localizations.dart';

/// Schermata "Party / Home Menu" replicata dal design reference HTML.
///
/// StatelessWidget puro: il layout è statico, la reattività passa da Obx
/// (stato del controller) e da piccoli widget animati privati.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Stack(
        children: [
          Column(
            children: [
              _HomeTopBar(controller: controller, l10n: l10n),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 110),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 480),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const SizedBox(height: 16),
                            _PartyPill(label: l10n.partyModeReady),
                            const SizedBox(height: 8),
                            const _HeroLogo(),
                            _MascotStage(controller: controller),
                            const SizedBox(height: 24),
                            _MenuButtons(controller: controller, l10n: l10n),
                            const SizedBox(height: 24),
                            _MultiplayerBadge(label: l10n.multiplayerBadge),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: AppBottomNav(),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Top bar
// ---------------------------------------------------------------------------

class _HomeTopBar extends StatelessWidget {
  const _HomeTopBar({required this.controller, required this.l10n});

  final HomeController controller;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
        child: Container(
          decoration: const BoxDecoration(
            color: Color(0xCC101221), // surface @ 80%
            boxShadow: [
              BoxShadow(
                color: Color(0x0A000000), // black @ 4%
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
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        SizedBox(
                          height: 32,
                          child: Image.asset(
                            'assets/images/logo.jpg',
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'TicBoom',
                          style: AppTextStyles.headlineMd.copyWith(
                            color: AppColors.primaryContainer,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 130),
                    child: Text(
                      l10n.homeMenuTitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.titleCard.copyWith(
                        color: AppColors.onSurface,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        _SoundFxButton(controller: controller),
                        const SizedBox(width: 4),
                        _ProfileAvatar(controller: controller),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SoundFxButton extends StatelessWidget {
  const _SoundFxButton({required this.controller});

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => GestureDetector(
        onTap: controller.toggleSoundFx,
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.surfaceContainerHigh,
            boxShadow: [
              BoxShadow(
                color: AppColors.shadow.withValues(alpha: 0.15),
                offset: const Offset(0, 2),
                blurRadius: 6,
              ),
            ],
          ),
          child: Icon(
            controller.isMuted.value ? Icons.volume_off : Icons.volume_up,
            size: 20,
            color: controller.isMuted.value
                ? AppColors.onSurfaceVariant
                : AppColors.onSurface,
          ),
        ),
      ),
    );
  }
}

class _ProfileAvatar extends StatelessWidget {
  const _ProfileAvatar({required this.controller});

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: controller.goProfile,
      child: Container(
        width: 32,
        height: 32,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.primary,
        ),
        child: const Icon(Icons.person, size: 18, color: AppColors.onPrimary),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Pill "Party Mode Pronto"
// ---------------------------------------------------------------------------

class _PartyPill extends StatelessWidget {
  const _PartyPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(999),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow.withValues(alpha: 0.2),
              offset: const Offset(0, 1),
              blurRadius: 2,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _PingDot(size: 10, color: AppColors.primaryContainer),
            const SizedBox(width: 8),
            Text(
              label,
              style: AppTextStyles.labelPill.copyWith(
                color: AppColors.primaryContainer,
                letterSpacing: 0.6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Hero logo
// ---------------------------------------------------------------------------

class _HeroLogo extends StatelessWidget {
  const _HeroLogo();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 200,
        height: 120,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Glow radiale ambientale dietro il logo.
            Container(
              width: 200,
              height: 200,
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
              width: 176,
              height: 96,
              fit: BoxFit.contain,
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Mascotte
// ---------------------------------------------------------------------------

class _MascotStage extends StatelessWidget {
  const _MascotStage({required this.controller});

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Glow radiale ambientale primario.
            Container(
              width: 224,
              height: 224,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.primaryContainer.withValues(alpha: 0.15),
                    AppColors.primaryContainer.withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),
            // Glow secondario caldo pulsante in alto a destra.
            Positioned(
              top: -4,
              right: 40,
              child: _PulsingGlow(
                size: 112,
                color: AppColors.secondaryContainer.withValues(alpha: 0.2),
              ),
            ),
            Obx(
              () => AnimatedRotation(
                turns: controller.mascotTilt.value / 360,
                duration: const Duration(milliseconds: 150),
                child: AnimatedScale(
                  scale: controller.mascotScale.value,
                  duration: const Duration(milliseconds: 300),
                  child: GestureDetector(
                    onTap: controller.mascotBounce,
                    child: const _MascotBody(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MascotBody extends StatelessWidget {
  const _MascotBody();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const _FuseCluster(),
        Transform.translate(
          offset: const Offset(0, -16),
          child: const _BombBody(),
        ),
        const SizedBox(height: 8),
        // Ombra a terra della mascotte.
        Container(
          width: 144,
          height: 16,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.surfaceContainerLowest.withValues(alpha: 0.8),
          ),
        ),
      ],
    );
  }
}

class _FuseCluster extends StatelessWidget {
  const _FuseCluster();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 112,
      height: 64,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: const Size(96, 64),
            painter: _FusePainter(),
          ),
          const Positioned(top: 0, right: 16, child: _LitFuseSpark()),
        ],
      ),
    );
  }
}

/// Disegna la curva dello stoppino del riferimento SVG:
/// `M 28 54 C 28 25, 65 35, 76 12` su viewBox 100x60, due tratti.
class _FusePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / 100, size.height / 60);

    final path = Path()
      ..moveTo(28, 54)
      ..cubicTo(28, 25, 65, 35, 76, 12);

    // Tratto pieno beige (outline).
    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6
        ..strokeCap = StrokeCap.round
        ..color = AppColors.outline,
    );

    // Tratto tratteggiato scuro (texture corda).
    final dashPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..color = AppColors.outlineVariant;

    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      var draw = true;
      while (distance < metric.length) {
        final end = (distance + (draw ? 2 : 4)).clamp(0.0, metric.length);
        if (draw) {
          canvas.drawPath(metric.extractPath(distance, end), dashPaint);
        }
        distance = end;
        draw = !draw;
      }
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(_FusePainter oldDelegate) => false;
}

class _LitFuseSpark extends StatelessWidget {
  const _LitFuseSpark();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 52,
      height: 52,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Fiamma principale con glow, rimbalzo continuo.
          _BouncingFire(),
          // Scintille orbitanti.
          const Positioned(
            top: 0,
            right: 0,
            child: _PingDot(size: 10, color: AppColors.secondary),
          ),
          const Positioned(
            bottom: 4,
            left: 4,
            child: _PingDot(size: 8, color: AppColors.primaryContainer),
          ),
        ],
      ),
    );
  }
}

class _BouncingFire extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _LoopAnimationBuilder(
      duration: const Duration(milliseconds: 800),
      builder: (context, value) {
        return Transform.translate(
          offset: Offset(0, 6 * value - 6),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryContainer.withValues(alpha: 0.9),
                  blurRadius: 12,
                ),
              ],
            ),
            child: const Icon(
              Icons.local_fire_department,
              size: 36,
              color: AppColors.primaryContainer,
            ),
          ),
        );
      },
    );
  }
}

class _BombBody extends StatelessWidget {
  const _BombBody();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 176,
      height: 176,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          // Corpo nero lucido con ombra esterna.
          Container(
            width: 176,
            height: 176,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.surfaceContainerLowest,
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadow.withValues(alpha: 0.5),
                  offset: const Offset(0, 16),
                  blurRadius: 28,
                ),
              ],
            ),
          ),
          // Inner shadow in basso (fondo scuro).
          Positioned.fill(
            child: ClipOval(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.shadow.withValues(alpha: 0.0),
                      AppColors.shadow.withValues(alpha: 0.8),
                    ],
                    stops: const [0.6, 1.0],
                  ),
                ),
              ),
            ),
          ),
          // Calotta sopra la bombola.
          Positioned(
            top: -12,
            left: (176 - 56) / 2,
            child: Container(
              width: 56,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(999),
                color: AppColors.surfaceContainerHighest,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.surfaceContainerHighest,
                    AppColors.outlineVariant,
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadow.withValues(alpha: 0.4),
                    offset: const Offset(0, 2),
                    blurRadius: 4,
                  ),
                ],
              ),
            ),
          ),
          // Riflesso speculare ovale (gloss).
          Positioned(
            top: 16,
            left: 24,
            child: Transform.rotate(
              angle: -35 * math.pi / 180,
              child: Container(
                width: 48,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(999),
                  color: AppColors.primary.withValues(alpha: 0.2),
                ),
              ),
            ),
          ),
          // Bolla di riflesso secondaria.
          Positioned(
            top: 28,
            left: 16,
            child: Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withValues(alpha: 0.3),
              ),
            ),
          ),
          // Faccia cartoon.
          const _MascotFace(),
        ],
      ),
    );
  }
}

class _MascotFace extends StatelessWidget {
  const _MascotFace();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _MascotEye(pupilAlignment: Alignment.topRight),
              const SizedBox(width: 20),
              _MascotEye(pupilAlignment: Alignment.topLeft),
            ],
          ),
          const SizedBox(height: 8),
          _MascotMouth(),
        ],
      ),
    );
  }
}

class _MascotEye extends StatelessWidget {
  const _MascotEye({required this.pupilAlignment});

  final Alignment pupilAlignment;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 40,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.primary,
      ),
      child: Align(
        alignment: pupilAlignment,
        child: Container(
          margin: const EdgeInsets.only(top: 8, left: 6, right: 6),
          width: 16,
          height: 20,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.surfaceContainerLowest,
          ),
          child: Align(
            alignment: pupilAlignment,
            child: Container(
              margin: const EdgeInsets.only(top: 2, left: 2, right: 2),
              width: 6,
              height: 6,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MascotMouth extends StatelessWidget {
  const _MascotMouth();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      height: 16,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Guance rosa.
          Positioned(
            left: 0,
            child: Container(
              width: 14,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.secondary.withValues(alpha: 0.4),
              ),
            ),
          ),
          Positioned(
            right: 0,
            child: Container(
              width: 14,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.secondary.withValues(alpha: 0.4),
              ),
            ),
          ),
          // Sorriso con lingua.
          Container(
            width: 32,
            height: 16,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(16),
              ),
              color: AppColors.secondaryContainer,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.shadow.withValues(alpha: 0.4),
                  AppColors.shadow.withValues(alpha: 0.0),
                ],
                stops: const [0.0, 0.35],
              ),
            ),
            child: Center(
              child: Container(
                width: 16,
                height: 8,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.tertiaryContainer,
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
// Pulsanti menu
// ---------------------------------------------------------------------------

class _MenuButtons extends StatelessWidget {
  const _MenuButtons({required this.controller, required this.l10n});

  final HomeController controller;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _LedgeButton(
          baseColor: AppColors.onPrimaryFixedVariant,
          baseGlow: BoxShadow(
            color: AppColors.primaryFixedDim.withValues(alpha: 0.3),
            offset: const Offset(0, 8),
            blurRadius: 20,
          ),
          faceColor: AppColors.primaryContainer,
          faceHeight: 72,
          baseOffset: 6,
          onTap: controller.goSetup,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.play_arrow,
                size: 32,
                color: AppColors.onPrimary,
                shadows: [
                  Shadow(
                    color: AppColors.onPrimaryFixedVariant,
                    offset: Offset(0, 1),
                    blurRadius: 2,
                  ),
                ],
              ),
              const SizedBox(width: 12),
              Flexible(
                child: Text(
                  l10n.play,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.headline.copyWith(
                    color: AppColors.onPrimary,
                    letterSpacing: 1.4,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              const _RotatingSparkle(),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _LedgeButton(
          baseColor: AppColors.surfaceContainerLowest,
          faceColor: AppColors.surfaceContainerHigh,
          faceHeight: 64,
          baseOffset: 4,
          onTap: controller.goRules,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.menu_book,
                size: 22,
                color: AppColors.primaryContainer,
              ),
              const SizedBox(width: 12),
              Flexible(
                child: Text(
                  l10n.howToPlay,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.labelAction.copyWith(
                    color: AppColors.onSurface,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _LedgeButton(
          baseColor: AppColors.surfaceContainerLowest,
          faceColor: AppColors.surfaceContainerHigh,
          faceHeight: 64,
          baseOffset: 4,
          onTap: controller.goSettings,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.settings,
                size: 22,
                color: AppColors.onSurfaceVariant,
              ),
              const SizedBox(width: 12),
              Flexible(
                child: Text(
                  l10n.settings,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.labelAction.copyWith(
                    color: AppColors.onSurface,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Pulsante con "base 3D" scura sotto la faccia, traslata in basso
/// (ledge shadow del riferimento).
class _LedgeButton extends StatelessWidget {
  const _LedgeButton({
    required this.baseColor,
    required this.faceColor,
    required this.faceHeight,
    required this.baseOffset,
    required this.onTap,
    required this.child,
    this.baseGlow,
  });

  final Color baseColor;
  final Color faceColor;
  final double faceHeight;
  final double baseOffset;
  final VoidCallback onTap;
  final Widget child;
  final BoxShadow? baseGlow;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(999);

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: faceHeight + baseOffset,
        child: Stack(
          children: [
            Positioned.fill(
              child: Transform.translate(
                offset: Offset(0, baseOffset),
                child: Container(
                  decoration: BoxDecoration(
                    color: baseColor,
                    borderRadius: borderRadius,
                    boxShadow: baseGlow != null ? [baseGlow!] : null,
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: faceColor,
                  borderRadius: borderRadius,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: child,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RotatingSparkle extends StatelessWidget {
  const _RotatingSparkle();

  @override
  Widget build(BuildContext context) {
    return _LoopAnimationBuilder(
      duration: const Duration(seconds: 3),
      curve: Curves.linear,
      repeatReverse: false,
      builder: (context, value) {
        return Transform.rotate(
          angle: 2 * math.pi * value,
          child: const Icon(
            Icons.auto_awesome,
            size: 20,
            color: AppColors.onPrimaryContainer,
          ),
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Badge multiplayer
// ---------------------------------------------------------------------------

class _MultiplayerBadge extends StatelessWidget {
  const _MultiplayerBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: AppColors.outlineVariant, width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.groups, size: 16, color: AppColors.primaryContainer),
            const SizedBox(width: 8),
            Text(
              label,
              style: AppTextStyles.labelPill.copyWith(
                color: AppColors.onSurfaceVariant,
                letterSpacing: 0.6,
              ),
            ),
          ],
        ),
      ),
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

/// Glow circolare con opacità pulsante.
class _PulsingGlow extends StatelessWidget {
  const _PulsingGlow({required this.size, required this.color});

  final double size;
  final Color color;

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
                  color,
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
