import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ticboom/core/styles/app_colors.dart';
import 'package:ticboom/core/styles/app_text_styles.dart';
import 'package:ticboom/core/view/widgets/app_bottom_nav.dart';
import 'package:ticboom/core/view/widgets/app_header.dart';
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
          Positioned(top: 8, child: const _BigBombVector()),
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

/// Bombola grande 240x240 (viewBox del riferimento SVG) con gradienti
/// propri e scintilla "intermittente" (opacità/scala a keyframe, replica
/// dell'animazione `intermittentSpark` del riferimento).
class _BigBombVector extends StatefulWidget {
  const _BigBombVector();

  @override
  State<_BigBombVector> createState() => _BigBombVectorState();
}

class _BigBombVectorState extends State<_BigBombVector>
    with SingleTickerProviderStateMixin {
  /// Controller custom della scintilla intermittente (ciclo 3s, come il
  /// keyframes CSS `intermittentSpark` del riferimento).
  late final AnimationController _spark = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 3000),
  )..repeat();

  @override
  void dispose() {
    _spark.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _spark,
      builder: (context, _) {
        final (opacity, scale) = _intermittentSpark(_spark.value);
        return CustomPaint(
          size: const Size(224, 224),
          painter: _BigBombPainter(sparkOpacity: opacity, sparkScale: scale),
        );
      },
    );
  }
}

/// Keyframes di `intermittentSpark`: (t, opacity, scale). Interpolazione
/// lineare tra i valori, replica dell'animazione CSS del riferimento.
const List<(double, double, double)> _sparkKeyframes = [
  (0.00, 0.25, 0.85),
  (0.08, 1.00, 1.25),
  (0.14, 0.40, 0.90),
  (0.22, 1.00, 1.35),
  (0.30, 0.30, 0.85),
  (0.45, 0.95, 1.15),
  (0.55, 0.20, 0.80),
  (0.65, 0.90, 1.20),
  (0.80, 0.35, 0.90),
  (0.90, 0.80, 1.10),
  (1.00, 0.25, 0.85),
];

(double, double) _intermittentSpark(double t) {
  for (var i = 0; i < _sparkKeyframes.length - 1; i++) {
    final (t0, o0, s0) = _sparkKeyframes[i];
    final (t1, o1, s1) = _sparkKeyframes[i + 1];
    if (t >= t0 && t <= t1) {
      final f = (t - t0) / (t1 - t0);
      return (o0 + (o1 - o0) * f, s0 + (s1 - s0) * f);
    }
  }
  return (0.25, 0.85);
}

class _BigBombPainter extends CustomPainter {
  const _BigBombPainter({required this.sparkOpacity, required this.sparkScale});

  final double sparkOpacity;
  final double sparkScale;

  static const Offset _sparkCenter = Offset(184, 26);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / 240, size.height / 240);

    _paintFuse(canvas);
    _paintCap(canvas);
    _paintBody(canvas);
    _paintSpark(canvas);

    canvas.restore();
  }

  /// Stoppino curvo lungo, tratto singolo con dash 6 4.
  void _paintFuse(Canvas canvas) {
    final path = Path()
      ..moveTo(120, 72)
      ..cubicTo(120, 48, 142, 36, 164, 42)
      ..cubicTo(174, 45, 180, 38, 182, 28);

    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4.5
        ..strokeCap = StrokeCap.round
        ..color = AppColors.onSurfaceVariant,
    );

    _BigBombPainterDashes.draw(canvas, path, const [6, 4]);
  }

  /// Calotta con gradiente lineare + anello.
  void _paintCap(Canvas canvas) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(108, 62, 24, 12),
        const Radius.circular(3),
      ),
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF555866), Color(0xFF2D2F38), Color(0xFF181920)],
        ).createShader(const Rect.fromLTWH(108, 62, 24, 12)),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(105, 70, 30, 4),
        const Radius.circular(2),
      ),
      Paint()..color = const Color(0xFF4F4633),
    );
  }

  /// Corpo: gradiente radiale propri + riflesso + ombra portata.
  void _paintBody(Canvas canvas) {
    final center = const Offset(120, 150);
    final radius = 76.0;

    // Ombra morbida sotto la bombola.
    canvas.drawCircle(
      const Offset(120, 160),
      radius,
      Paint()
        ..color = AppColors.shadow.withValues(alpha: 0.35)
        ..maskFilter = const ui.MaskFilter.blur(ui.BlurStyle.normal, 12),
    );

    // Corpo con gradiente radiale (cx 38% cy 34% del riferimento).
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..shader = ui.Gradient.radial(
          const Offset(96, 104),
          110,
          const [
            Color(0xFF383B48),
            Color(0xFF22242E),
            Color(0xFF14151B),
            Color(0xFF0A0B0E),
          ],
          const [0.0, 0.45, 0.85, 1.0],
        ),
    );
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = const Color(0xFF383B48).withValues(alpha: 0.6),
    );

    // Arco di riflesso speculare.
    final arc = Path()
      ..moveTo(66, 120)
      ..cubicTo(72, 96, 94, 82, 114, 78);
    canvas.drawPath(
      arc,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.5
        ..strokeCap = StrokeCap.round
        ..color = AppColors.onSurface.withValues(alpha: 0.2),
    );
  }

  /// Scintilla con core a gradiente radiale, glow e scala/opacità
  /// intermittenti.
  void _paintSpark(Canvas canvas) {
    void drawSparkGroup({required double alphaMul, MaskFilter? blur}) {
      final corePaint = Paint()
        ..shader = ui.Gradient.radial(
          _sparkCenter,
          16,
          const [
            Color(0xFFFFFFFF),
            Color(0xFFFFE177),
            Color(0xFFFBBF24),
            Color(0x00FBBF24),
          ],
          const [0.0, 0.3, 0.7, 1.0],
        )
        ..color = AppColors.primaryContainer.withValues(alpha: alphaMul)
        ..maskFilter = blur;
      canvas.drawCircle(_sparkCenter, 14, corePaint);

      // Stella a 4 punte.
      final star = Path()
        ..moveTo(184, 10)
        ..lineTo(187, 22)
        ..lineTo(198, 26)
        ..lineTo(187, 30)
        ..lineTo(184, 42)
        ..lineTo(181, 30)
        ..lineTo(170, 26)
        ..lineTo(181, 22)
        ..close();
      canvas.drawPath(
        star,
        Paint()
          ..color = AppColors.primary.withValues(alpha: alphaMul)
          ..maskFilter = blur,
      );

      // Centro bianco.
      canvas.drawCircle(
        _sparkCenter,
        2.2,
        Paint()..color = Colors.white.withValues(alpha: alphaMul),
      );
    }

    canvas.save();
    canvas.translate(_sparkCenter.dx, _sparkCenter.dy);
    canvas.scale(sparkScale);
    canvas.translate(-_sparkCenter.dx, -_sparkCenter.dy);

    drawSparkGroup(
      alphaMul: sparkOpacity * 0.6,
      blur: ui.MaskFilter.blur(ui.BlurStyle.normal, 4),
    );
    drawSparkGroup(alphaMul: sparkOpacity);

    canvas.restore();
  }

  @override
  bool shouldRepaint(_BigBombPainter oldDelegate) {
    return oldDelegate.sparkOpacity != sparkOpacity ||
        oldDelegate.sparkScale != sparkScale;
  }
}

/// Helper per i tratti tratteggiati dello stoppino grande.
abstract final class _BigBombPainterDashes {
  static void draw(Canvas canvas, Path path, List<double> dashPattern) {
    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      var draw = true;
      var index = 0;
      while (distance < metric.length) {
        final segment = dashPattern[index % dashPattern.length];
        final end = (distance + segment).clamp(0.0, metric.length);
        if (draw) {
          canvas.drawPath(
            metric.extractPath(distance, end),
            Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = 2
              ..strokeCap = StrokeCap.round
              ..color = AppColors.onSurface,
          );
        }
        distance = end;
        index++;
        draw = !draw;
      }
    }
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
