import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ticboom/core/styles/app_colors.dart';
import 'package:ticboom/core/styles/app_text_styles.dart';
import 'package:ticboom/features/game/view/controllers/game_over_controller.dart';
import 'package:ticboom/l10n/app_localizations.dart';

/// Schermata di partita terminata: mostrata automaticamente dopo
/// l'esplosione della bomba, con il tempo effettivo trascorso.
///
/// "Gioca nuova partita" riporta alla homepage e ripulisce la sessione;
/// "Rigiochi subito la manche" resta visibile ma disabilitato.
class GameOverPage extends StatefulWidget {
  const GameOverPage({super.key});

  @override
  State<GameOverPage> createState() => _GameOverPageState();
}

class _GameOverPageState extends State<GameOverPage> {
  late final GameOverController controller;

  @override
  void initState() {
    super.initState();
    // Ciclo di vita legato a questa pagina (go_router senza GetMaterialApp:
    // GetX non smaltisce i controller a fine rotta). Eventuali esemplari
    // residui di pagine precedenti vengono chiusi prima della registrazione.
    if (Get.isRegistered<GameOverController>()) {
      Get.delete<GameOverController>(force: true);
    }
    controller = Get.put(GameOverController());
  }

  @override
  void dispose() {
    // Cancella il controller solo se è ancora quello di questa pagina (la
    // nuova pagina può già essersi registrata durante un cambio rotta).
    if (Get.isRegistered<GameOverController>()) {
      if (identical(Get.find<GameOverController>(), controller)) {
        Get.delete<GameOverController>();
      }
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return PopScope(
      // Il back dalla schermata di fine partita conduce alla homepage,
      // con la sessione ripulita.
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          return;
        }
        controller.goHome();
      },
      child: Scaffold(
        backgroundColor: AppColors.surface,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _Header(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      const SizedBox(height: 8),
                      const _ExplosionVector(),
                      const SizedBox(height: 12),
                      _ContextChip(l10n: l10n),
                      const SizedBox(height: 10),
                      Text(
                        l10n.bombaEsplosaMessaggio,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.headline.copyWith(
                          color: AppColors.onSurface,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _DefeatCard(l10n: l10n),
                      const SizedBox(height: 12),
                      _TimeMetric(
                        l10n: l10n,
                        seconds: controller.elapsedSeconds,
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
                child: _GameOverActions(controller: controller, l10n: l10n),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Header con freccia back (porta alla home con sessione ripulita)
// ─────────────────────────────────────────────────────────────────────────────

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<GameOverController>();
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 24, 8),
      child: Row(
        children: [
          IconButton(
            onPressed: controller.goHome,
            icon: const Icon(Icons.arrow_back),
            color: AppColors.onSurfaceVariant,
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              AppLocalizations.of(context).partitaInCorsoTitle,
              style: AppTextStyles.titleCard.copyWith(
                color: AppColors.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Illustrazione dell'esplosione con badge BOOM!
// ─────────────────────────────────────────────────────────────────────────────

class _ExplosionVector extends StatelessWidget {
  const _ExplosionVector();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      height: 180,
      child: Stack(
        alignment: Alignment.center,
        children: [
          const CustomPaint(
            size: Size(220, 180),
            painter: _ExplosionPainter(),
          ),
          // Badge "BOOM!" a testo pieno sopra il glow, come nel mockup
          // (nessuna pill di sfondo).
          Text(
            'BOOM!',
            style: AppTextStyles.labelAction.copyWith(
              color: const Color(0xFFF3EFE4),
              fontSize: 30,
              letterSpacing: 2,
              shadows: const [
                Shadow(color: Color(0x66000000), blurRadius: 14),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Illustrazione dell'esplosione replicata dal mockup: glow radiale ambra,
/// raggi sottili che attraversano il centro, anello di archi spezzati (il
/// guscio della bomba), cerchio tratteggiato esterno, frammento di miccia
/// in alto e braci colorate sparse.
class _ExplosionPainter extends CustomPainter {
  const _ExplosionPainter();

  static const Offset _center = Offset(110, 92);

  /// Frammenti del guscio: (angolo iniziale in gradi, ampiezza, scostamento
  /// radiale). Convenzione canvas: 0° = destra, senso orario (y verso il
  /// basso), 270° = alto.
  static const List<(double, double, double)> _shards = [
    (30, 50, 0),
    (110, 42, 2),
    (185, 48, 0),
    (240, 22, -2),
    (315, 22, 2),
  ];

  /// Braci sparse: (scostamento dal centro, colore, raggio).
  static const List<(Offset, Color, double)> _embers = [
    (Offset(-80, -62), Color(0xFFF3EFE4), 3),
    (Offset(-96, 16), Color(0xFFFFB2B7), 3.5),
    (Offset(90, -34), Color(0xFFFBBF24), 2.5),
    (Offset(84, 30), Color(0xFFFFB2B7), 3),
    (Offset(56, 66), Color(0xFFFBBF24), 3.5),
    (Offset(-34, 78), Color(0xFFF3EFE4), 2.5),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    _paintGlow(canvas);
    _paintRays(canvas);
    _paintShardRing(canvas);
    _paintFuseFragment(canvas);
    _paintDashedCircle(canvas);
    _paintEmbers(canvas);
  }

  /// Glow radiale: nucleo crema-oro brillante → ambra → arancio bruciato
  /// → trasparente.
  void _paintGlow(Canvas canvas) {
    final glow = Paint()
      ..shader = const RadialGradient(
        colors: [
          Color(0xFFF6E7C1),
          Color(0xFFF9BD22),
          Color(0x99B45309),
          Color(0x00B45309),
        ],
        stops: [0.0, 0.30, 0.62, 1.0],
      ).createShader(Rect.fromCircle(center: _center, radius: 84));
    canvas.drawCircle(_center, 84, glow);
  }

  /// Raggi sottili: 3 linee che attraversano tutto il centro (orizzontale +
  /// 2 diagonali) e 2 segmenti verticali corto in alto e in basso.
  void _paintRays(Canvas canvas) {
    final ray = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..color = AppColors.primaryContainer;

    void fullRay(double angleDeg, double inner, double outer, double width) {
      ray.strokeWidth = width;
      final dir = Offset.fromDirection(angleDeg * pi / 180, 1);
      canvas.drawLine(_center + dir * inner, _center + dir * outer, ray);
      canvas.drawLine(_center - dir * inner, _center - dir * outer, ray);
    }

    fullRay(0, 20, 96, 2.5);
    fullRay(45, 22, 92, 2.5);
    fullRay(135, 22, 92, 2.5);
    fullRay(90, 44, 70, 2);
    fullRay(270, 44, 70, 2);
  }

  /// Anello spezzato: archi spessi scuri con sottile contorno su entrambi
  /// i bordi, con gap irregolari tra i frammenti.
  void _paintShardRing(Canvas canvas) {
    const radius = 46.0;
    const thickness = 15.0;
    final fill = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = thickness
      ..color = AppColors.surfaceContainerLowest;
    final edge = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..color = AppColors.outlineVariant;

    for (final (startDeg, sweepDeg, shift) in _shards) {
      final r = radius + shift;
      final start = startDeg * pi / 180;
      final sweep = sweepDeg * pi / 180;
      canvas.drawArc(
        Rect.fromCircle(center: _center, radius: r),
        start,
        sweep,
        false,
        fill,
      );
      canvas.drawArc(
        Rect.fromCircle(center: _center, radius: r + thickness / 2),
        start,
        sweep,
        false,
        edge,
      );
      canvas.drawArc(
        Rect.fromCircle(center: _center, radius: r - thickness / 2),
        start,
        sweep,
        false,
        edge,
      );
    }
  }

  /// Frammento di miccia in alto: piccolo arco di guscio con filo che
  /// sporge verso l'alto e scintilla ambra in punta.
  void _paintFuseFragment(Canvas canvas) {
    final fill = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..color = AppColors.surfaceContainerLowest;
    final edge = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..color = AppColors.outlineVariant;

    final start = 258 * pi / 180;
    final sweep = 30 * pi / 180;
    canvas.drawArc(
      Rect.fromCircle(center: _center, radius: 42),
      start,
      sweep,
      false,
      fill,
    );
    canvas.drawArc(
      Rect.fromCircle(center: _center, radius: 48),
      start,
      sweep,
      false,
      edge,
    );
    canvas.drawArc(
      Rect.fromCircle(center: _center, radius: 36),
      start,
      sweep,
      false,
      edge,
    );

    // Filo della miccia che sporge dal frammento.
    final fuse = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..color = AppColors.onSurfaceVariant;
    final fuseStart = _center + const Offset(10, -52);
    final fuseMid = _center + const Offset(18, -68);
    final fuseEnd = _center + const Offset(26, -80);
    canvas.drawPath(
      Path()
        ..moveTo(fuseStart.dx, fuseStart.dy)
        ..quadraticBezierTo(fuseMid.dx, fuseMid.dy, fuseEnd.dx, fuseEnd.dy),
      fuse,
    );

    // Scintilla in punta.
    final sparkGlow = Paint()
      ..color = AppColors.primaryContainer.withValues(alpha: 0.5)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5);
    canvas.drawCircle(fuseEnd, 6, sparkGlow);
    final spark = Paint()..color = AppColors.primaryFixed;
    canvas.drawCircle(fuseEnd, 3, spark);
  }

  /// Cerchio esterno tratteggiato.
  void _paintDashedCircle(Canvas canvas) {
    final dash = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..color = AppColors.outlineVariant;
    const radius = 88.0;
    const dashDeg = 5.0;
    const gapDeg = 10.0;
    for (var a = 0.0; a < 360; a += dashDeg + gapDeg) {
      canvas.drawArc(
        Rect.fromCircle(center: _center, radius: radius),
        a * pi / 180,
        dashDeg * pi / 180,
        false,
        dash,
      );
    }
  }

  /// Braci coriandolo sparse attorno all'esplosione.
  void _paintEmbers(Canvas canvas) {
    final ember = Paint();
    for (final (offset, color, radius) in _embers) {
      ember.color = color;
      canvas.drawCircle(_center + offset, radius, ember);
    }
  }

  @override
  bool shouldRepaint(covariant _ExplosionPainter oldDelegate) => false;
}

// ─────────────────────────────────────────────────────────────────────────────
// Chip "Detonazione confermata"
// ─────────────────────────────────────────────────────────────────────────────

class _ContextChip extends StatelessWidget {
  const _ContextChip({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.local_fire_department,
            size: 16,
            color: AppColors.primaryContainer,
          ),
          const SizedBox(width: 8),
          Text(
            l10n.detonazioneConfermata,
            style: AppTextStyles.labelMono.copyWith(
              color: AppColors.primaryContainer,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Card di sconfitta: chi ha il telefono in mano ha perso
// ─────────────────────────────────────────────────────────────────────────────

class _DefeatCard extends StatelessWidget {
  const _DefeatCard({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: Row(
        children: [
          // Barra ambra sul bordo sinistro, come nel riferimento.
          Container(width: 4, height: 44, color: AppColors.primaryContainer),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.sconfittaDelRound,
                  style: AppTextStyles.labelMono.copyWith(
                    fontSize: 9,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.haiIlTelefonoInMano,
                  style: AppTextStyles.titleCard.copyWith(
                    color: AppColors.onSurface,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.sentiment_very_dissatisfied,
            size: 22,
            color: AppColors.onSurfaceVariant,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Metrica "Tempo": secondi effettivi trascorsi prima dell'esplosione
// ─────────────────────────────────────────────────────────────────────────────

class _TimeMetric extends StatelessWidget {
  const _TimeMetric({required this.l10n, required this.seconds});

  final AppLocalizations l10n;
  final int seconds;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.schedule,
            size: 20,
            color: AppColors.primaryContainer,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              l10n.tempoLabel,
              style: AppTextStyles.titleSmall.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ),
          Text(
            l10n.secondiResistiti(seconds),
            style: AppTextStyles.titleCard.copyWith(
              color: AppColors.primaryContainer,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Azioni finali
// ─────────────────────────────────────────────────────────────────────────────

class _GameOverActions extends StatelessWidget {
  const _GameOverActions({required this.controller, required this.l10n});

  final GameOverController controller;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FilledButton(
          onPressed: controller.goHome,
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.primaryContainer,
            foregroundColor: AppColors.onPrimaryContainer,
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: Row(
            children: [
              const Icon(Icons.arrow_forward),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  l10n.giocaNuovaPartita,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.labelAction.copyWith(
                    color: AppColors.onPrimaryContainer,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        // "Rigiochi subito la manche": visibile ma completamente
        // disabilitato (nessuna azione in questa versione).
        Opacity(
          opacity: 0.4,
          child: OutlinedButton(
            onPressed: null,
            style: OutlinedButton.styleFrom(
              disabledForegroundColor: AppColors.onSurfaceVariant,
              side: const BorderSide(color: AppColors.outlineVariant),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.replay),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    l10n.rigiochiManche,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.buttonSecondary.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
