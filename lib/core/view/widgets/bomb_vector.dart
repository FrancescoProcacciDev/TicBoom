import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:ticboom/core/styles/app_colors.dart';

/// Bomba animata condivisa (home e partita in corso): sfera scura con
/// calotta metallica, stoppino curvo tratteggiato e scintilla intermittente.
///
/// [fuseProgress] (0..1) consuma lo stoppino dalla punta verso la calotta:
/// 0 = miccia integra con scintilla in punta (uso home); valori crescenti
/// accorciano il filo residuo e spostano la scintilla sul punto di
/// bruciatura (uso partita). [relightFlash] aggiunge un flash di
/// riaccensione a inizio ciclo per mascherare il reset della miccia.
class BombVector extends StatefulWidget {
  const BombVector({
    super.key,
    this.size = const Size(240, 240),
    this.fuseProgress = 0,
    this.relightFlash = false,
  });

  final Size size;
  final double fuseProgress;
  final bool relightFlash;

  @override
  State<BombVector> createState() => _BombVectorState();
}

class _BombVectorState extends State<BombVector>
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
          size: widget.size,
          painter: BombPainter(
            sparkOpacity: opacity,
            sparkScale: scale,
            fuseProgress: widget.fuseProgress.clamp(0.0, 1.0),
            relightFlash: widget.relightFlash,
          ),
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

/// Painter della bomba condivisa. Spazio di disegno di riferimento 240x240,
/// scalato alla dimensione reale del CustomPaint.
class BombPainter extends CustomPainter {
  const BombPainter({
    required this.sparkOpacity,
    required this.sparkScale,
    this.fuseProgress = 0,
    this.relightFlash = false,
  });

  final double sparkOpacity;
  final double sparkScale;

  /// Consumo della miccia: 0 = integra, 1 = completamente bruciata.
  final double fuseProgress;

  final bool relightFlash;

  static const Offset _fuseTip = Offset(182, 28);

  /// Stopino curvo lungo della bomba (dalla calotta alla punta).
  Path get _fusePath => Path()
    ..moveTo(120, 72)
    ..cubicTo(120, 48, 142, 36, 164, 42)
    ..cubicTo(174, 45, 180, 38, 182, 28);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / 240, size.height / 240);

    _paintFuse(canvas);
    _paintCap(canvas);
    _paintBody(canvas);
    _paintSpark(canvas, _sparkPosition());

    canvas.restore();
  }

  /// Posizione della scintilla: punta della miccia (fuseProgress 0) oppure
  /// punto di bruciatura sul filo residuo (agganciato alla curva via
  /// PathMetrics).
  Offset _sparkPosition() {
    if (fuseProgress <= 0) {
      return _fuseTip;
    }
    final metrics = _fusePath.computeMetrics().first;
    final remaining =
        (metrics.length * (1 - fuseProgress)).clamp(0.0, metrics.length);
    final tangent = metrics.getTangentForOffset(remaining);
    return tangent?.position ?? _fuseTip;
  }

  /// Stoppino: tratto singolo con dash 6 4. Con fuseProgress > 0 viene
  /// disegnato solo il filo residuo, dal punto di attacco alla calotta
  /// fino al punto di bruciatura.
  void _paintFuse(Canvas canvas) {
    var visiblePath = _fusePath;
    if (fuseProgress > 0) {
      final metrics = _fusePath.computeMetrics().first;
      final remaining =
          (metrics.length * (1 - fuseProgress)).clamp(0.0, metrics.length);
      if (remaining <= 0.5) {
        // Miccia del tutto consumata: nessun filo da disegnare.
        return;
      }
      visiblePath = metrics.extractPath(0, remaining);
    }

    canvas.drawPath(
      visiblePath,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4.5
        ..strokeCap = StrokeCap.round
        ..color = AppColors.onSurfaceVariant,
    );

    BombPainterDashes.draw(canvas, visiblePath, const [6, 4]);
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

  /// Corpo: gradiente radiale proprio + riflesso + ombra portata.
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
  /// intermittenti, agganciata a [sparkCenter].
  void _paintSpark(Canvas canvas, Offset sparkCenter) {
    // Flash di riaccensione (solo partita): intensifica la scintilla a
    // inizio ciclo per mascherare il reset della miccia.
    final flash =
        relightFlash ? 1 - (fuseProgress / 0.08).clamp(0.0, 1.0) : 0.0;
    final alpha = (sparkOpacity * (1 + 0.6 * flash)).clamp(0.0, 1.0);
    final scale = sparkScale * (1 + 0.35 * flash);

    void drawSparkGroup({required double alphaMul, ui.MaskFilter? blur}) {
      final corePaint = Paint()
        ..shader = ui.Gradient.radial(
          Offset.zero,
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
      canvas.drawCircle(Offset.zero, 14, corePaint);

      // Stella a 4 punte (coordinate relative al centro della scintilla).
      final star = Path()
        ..moveTo(0, -16)
        ..lineTo(3, -4)
        ..lineTo(14, 0)
        ..lineTo(3, 4)
        ..lineTo(0, 16)
        ..lineTo(-3, 4)
        ..lineTo(-14, 0)
        ..lineTo(-3, -4)
        ..close();
      canvas.drawPath(
        star,
        Paint()
          ..color = AppColors.primary.withValues(alpha: alphaMul)
          ..maskFilter = blur,
      );

      // Centro bianco.
      canvas.drawCircle(
        Offset.zero,
        2.2,
        Paint()..color = Colors.white.withValues(alpha: alphaMul),
      );
    }

    canvas.save();
    canvas.translate(sparkCenter.dx, sparkCenter.dy);
    canvas.scale(scale);
    drawSparkGroup(
      alphaMul: alpha * 0.6,
      blur: ui.MaskFilter.blur(ui.BlurStyle.normal, 4),
    );
    drawSparkGroup(alphaMul: alpha);
    canvas.restore();
  }

  @override
  bool shouldRepaint(BombPainter oldDelegate) {
    return oldDelegate.sparkOpacity != sparkOpacity ||
        oldDelegate.sparkScale != sparkScale ||
        oldDelegate.fuseProgress != fuseProgress ||
        oldDelegate.relightFlash != relightFlash;
  }
}

/// Helper per i tratti tratteggiati dello stoppino.
abstract final class BombPainterDashes {
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
