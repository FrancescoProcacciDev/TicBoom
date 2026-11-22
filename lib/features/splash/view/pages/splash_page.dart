import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ticboom/core/styles/app_colors.dart';
import 'package:ticboom/core/styles/app_text_styles.dart';
import 'package:ticboom/features/splash/view/controllers/splash_controller.dart';
import 'package:ticboom/l10n/app_localizations.dart';

/// Schermata "Splash / Caricamento miccia" minimale, replicata dal nuovo
/// design reference HTML (bomba vettoriale, riga di caricamento 2px).
///
/// Il caricamento è REALE (gestito da [SplashController]); terminati i task
/// reali di avvio (e rispettata la durata minima), il controller naviga
/// automaticamente verso la home.
class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SplashController>();

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Column(
              children: [
                const SizedBox(height: 16),
                const _StatusPillDot(),
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const _BombHero(),
                        const SizedBox(height: 28),
                        const _TitleGroup(),
                        const SizedBox(height: 32),
                        _LoadDock(controller: controller),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Pill top minimalista: solo puntino "ping", senza testo
// ---------------------------------------------------------------------------

class _StatusPillDot extends StatelessWidget {
  const _StatusPillDot();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHigh.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(999),
      ),
      child: const _PingDot(size: 6, color: AppColors.primaryContainer),
    );
  }
}

// ---------------------------------------------------------------------------
// Hero: bomba vettoriale + tag "SISTEMA INNESCO PRONTO"
// ---------------------------------------------------------------------------

class _BombHero extends StatelessWidget {
  const _BombHero();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return SizedBox(
      width: 176,
      height: 184,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Glow ambientale dietro la bomba.
          Positioned(
            top: 8,
            left: 16,
            child: Container(
              width: 144,
              height: 144,
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
          Positioned(
            top: 4,
            left: 8,
            child: const _BombVectorSmall(),
          ),
          // Tag di stato digitale, a cavallo del bordo inferiore.
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(999),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.shadow.withValues(alpha: 0.25),
                      offset: const Offset(0, 1),
                      blurRadius: 3,
                    ),
                  ],
                ),
                child: Text(
                  l10n.sistemaInnescoPronto.toUpperCase(),
                  style: AppTextStyles.labelMono.copyWith(
                    color: AppColors.primaryFixed,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Bombola minimale 160x160 (viewBox del riferimento SVG), disegnata con
/// CustomPaint: corpo con gradiente radiale satin, calotta + anello,
/// stoppino curvo doppio tratto, scintilla dorata con glow e pulse,
/// riflesso speculare e core con "ping" animato.
class _BombVectorSmall extends StatefulWidget {
  const _BombVectorSmall();

  @override
  State<_BombVectorSmall> createState() => _BombVectorSmallState();
}

class _BombVectorSmallState extends State<_BombVectorSmall>
    with TickerProviderStateMixin {
  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2000),
  )..repeat(reverse: true);

  late final AnimationController _ping = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2000),
  )..repeat();

  @override
  void dispose() {
    _pulse.dispose();
    _ping.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_pulse, _ping]),
      builder: (context, _) {
        // Pulse: respiro della scintilla (scala 0.92 → 1.08).
        final pulse = Curves.easeInOut.transform(_pulse.value);
        final sparkScale = 0.92 + pulse * 0.16;
        final sparkOpacity = 0.75 + pulse * 0.25;
        // Ping: anello del core che si espande e svanisce (loop 2s).
        final ping = Curves.easeOut.transform(_ping.value);

        return CustomPaint(
          size: const Size(160, 160),
          painter: _BombPainter(
            sparkScale: sparkScale,
            sparkOpacity: sparkOpacity,
            ping: ping,
          ),
        );
      },
    );
  }
}

class _BombPainter extends CustomPainter {
  const _BombPainter({
    required this.sparkScale,
    required this.sparkOpacity,
    required this.ping,
  });

  /// Scala della scintilla (pulse 0.92 → 1.08).
  final double sparkScale;

  /// Opacità della scintilla (pulse 0.75 → 1.0).
  final double sparkOpacity;

  /// Progresso del ping del core (0 → 1, loop 2s).
  final double ping;

  static const Offset _sparkCenter = Offset(108, 12);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / 160, size.height / 160);

    _paintFuse(canvas);
    _paintCap(canvas);
    _paintBody(canvas);
    _paintSpark(canvas);

    canvas.restore();
  }

  /// Calotta detonatore + anello.
  void _paintCap(Canvas canvas) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(69, 33, 22, 11),
        const Radius.circular(2.5),
      ),
      Paint()..color = const Color(0xFF34343A),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(67, 41, 26, 3),
        const Radius.circular(1.5),
      ),
      Paint()..color = const Color(0xFF4F4633),
    );
  }

  /// Stoppino curvo: tratto pieno + tratto tratteggiato.
  void _paintFuse(Canvas canvas) {
    final path = Path()
      ..moveTo(80, 33)
      ..cubicTo(80, 18, 96, 16, 108, 12);

    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round
        ..color = AppColors.outline,
    );

    _drawDashed(
      canvas,
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5
        ..strokeCap = StrokeCap.round
        ..color = AppColors.onSurfaceVariant,
      const [2, 3],
    );
  }

  /// Corpo: gradiente radiale satin + contorno + riflesso speculare + core.
  void _paintBody(Canvas canvas) {
    final center = const Offset(80, 96);
    final radius = 52.0;

    // Corpo satin: gradiente radiale a 4 stop (riferimento SVG).
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..shader = ui.Gradient.radial(
          const Offset(65, 72),
          68,
          const [
            Color(0xFF34343A),
            Color(0xFF1E1F25),
            Color(0xFF121318),
            Color(0xFF0D0E13),
          ],
          const [0.0, 0.45, 0.85, 1.0],
        ),
    );
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5
        ..color = const Color(0xFF34343A).withValues(alpha: 0.6),
    );

    // Arco di riflesso speculare.
    final arc = Path()
      ..moveTo(46, 76)
      ..cubicTo(50, 62, 64, 52, 78, 50);
    canvas.drawPath(
      arc,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..strokeCap = StrokeCap.round
        ..color = AppColors.onSurface.withValues(alpha: 0.22),
    );

    // Core: indicatore di precisione + ping + punto pieno.
    canvas.drawCircle(
      center,
      12,
      Paint()..color = AppColors.surface,
    );
    canvas.drawCircle(
      center,
      12,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1
        ..color = const Color(0xFF34343A),
    );
    canvas.drawCircle(
      center,
      5 + ping * 6,
      Paint()..color = AppColors.primaryContainer.withValues(
        alpha: 0.75 * (1 - ping).clamp(0.0, 1.0),
      ),
    );
    canvas.drawCircle(
      center,
      4,
      Paint()..color = AppColors.primaryContainer,
    );
  }

  /// Scintilla dorata con glow: alone sfocato + gruppo netto, con pulse
  /// (scala/opacità) centrato sulla punta dello stoppino.
  void _paintSpark(Canvas canvas) {
    void drawSparkGroup({required double alphaMul, MaskFilter? blur}) {
      final glowPaint = Paint()
        ..color = AppColors.primaryContainer.withValues(
          alpha: 0.4 * alphaMul,
        )
        ..maskFilter = blur;
      canvas.drawCircle(_sparkCenter, 10, glowPaint);

      final sharp = Paint()
        ..color = AppColors.primaryContainer.withValues(alpha: alphaMul)
        ..maskFilter = blur;
      canvas.drawCircle(_sparkCenter, 4.5, sharp);

      // Stella a 4 punte.
      final star = Path()
        ..moveTo(108, 2)
        ..lineTo(110, 9.5)
        ..lineTo(118, 12)
        ..lineTo(110, 14.5)
        ..lineTo(108, 22)
        ..lineTo(106, 14.5)
        ..lineTo(98, 12)
        ..lineTo(106, 9.5)
        ..close();
      canvas.drawPath(
        star,
        Paint()
          ..color = AppColors.primary.withValues(alpha: alphaMul)
          ..maskFilter = blur,
      );

      // Glint diagonale secondario.
      final glint = Path()
        ..moveTo(103, 7)
        ..lineTo(108, 11)
        ..lineTo(113, 7)
        ..lineTo(109, 12)
        ..lineTo(113, 17)
        ..lineTo(108, 13)
        ..lineTo(103, 17)
        ..lineTo(107, 12)
        ..close();
      canvas.drawPath(
        glint,
        Paint()
          ..color = AppColors.primaryContainer.withValues(
            alpha: 0.7 * alphaMul,
          )
          ..maskFilter = blur,
      );

      // Centro bianco.
      canvas.drawCircle(
        _sparkCenter,
        1.8,
        Paint()..color = Colors.white.withValues(alpha: alphaMul),
      );
    }

    canvas.save();
    canvas.translate(_sparkCenter.dx, _sparkCenter.dy);
    canvas.scale(sparkScale);
    canvas.translate(-_sparkCenter.dx, -_sparkCenter.dy);

    // Passata di glow (blur), poi passata netta.
    drawSparkGroup(
      alphaMul: sparkOpacity * 0.65,
      blur: ui.MaskFilter.blur(ui.BlurStyle.normal, 3),
    );
    drawSparkGroup(alphaMul: sparkOpacity);

    canvas.restore();
  }

  /// Disegna un tratto tratteggiato lungo [path].
  static void _drawDashed(
    Canvas canvas,
    Path path,
    Paint paint,
    List<double> dashPattern,
  ) {
    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      var draw = true;
      var index = 0;
      while (distance < metric.length) {
        final segment = dashPattern[index % dashPattern.length];
        final end = (distance + segment).clamp(0.0, metric.length);
        if (draw) {
          canvas.drawPath(metric.extractPath(distance, end), paint);
        }
        distance = end;
        index++;
        draw = !draw;
      }
    }
  }

  @override
  bool shouldRepaint(_BombPainter oldDelegate) {
    return oldDelegate.sparkScale != sparkScale ||
        oldDelegate.sparkOpacity != sparkOpacity ||
        oldDelegate.ping != ping;
  }
}

// ---------------------------------------------------------------------------
// Titolo + sottotitolo
// ---------------------------------------------------------------------------

class _TitleGroup extends StatelessWidget {
  const _TitleGroup();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

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
          style: AppTextStyles.displayHero.copyWith(
            color: AppColors.onSurface,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          l10n.splashTagline,
          textAlign: TextAlign.center,
          style: AppTextStyles.body.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Indicatore di caricamento di precisione
// ---------------------------------------------------------------------------

class _LoadDock extends StatelessWidget {
  const _LoadDock({required this.controller});

  final SplashController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 320),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Obx(
            () => Row(
              children: [
                Container(
                  width: 4,
                  height: 4,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primaryContainer,
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    l10n.loadingFuse.toUpperCase(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.labelMono.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ),
                Text(
                  '${controller.percent.value}%',
                  style: AppTextStyles.labelMono.copyWith(
                    color: AppColors.primaryFixed,
                    fontFeatures: const [ui.FontFeature.tabularFigures()],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Traccia 2px con fill gradiente + glow.
          Obx(
            () => TweenAnimationBuilder<double>(
              tween: Tween(end: controller.percent.value / 100),
              duration: const Duration(milliseconds: 700),
              curve: Curves.easeOut,
              builder: (context, fraction, _) => Container(
                height: 2,
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: fraction,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(999),
                      gradient: const LinearGradient(
                        colors: [
                          AppColors.primaryFixedDim,
                          AppColors.primaryContainer,
                          AppColors.primaryFixed,
                        ],
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0xFFFBBF24),
                          blurRadius: 8,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                  ),
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
// Widget animati privati (loop)
// ---------------------------------------------------------------------------

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
