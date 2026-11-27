import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ticboom/core/styles/app_colors.dart';
import 'package:ticboom/core/styles/app_text_styles.dart';
import 'package:ticboom/core/utils/app_haptics.dart';
import 'package:ticboom/core/view/widgets/app_bottom_nav.dart';
import 'package:ticboom/core/view/widgets/app_header.dart';
import 'package:ticboom/features/rules/view/controllers/rules_controller.dart';
import 'package:ticboom/l10n/app_localizations.dart';

/// Schermata "Come si gioca" replicata dal nuovo design reference HTML:
/// badge "Guida rapida", 3 pill feature, 3 card regole numerate con
/// micro-illustrazioni, callout "Regola d'oro", CTA dorata e footer nota.
/// Header e bottom nav seguono il design attuale del progetto (AppHeader
/// condiviso + AppBottomNav a 2 voci).
class RulesPage extends StatelessWidget {
  const RulesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<RulesController>();
    final l10n = AppLocalizations.of(context);
    // Schivata dell'header overlay: SafeArea del dispositivo + margine + altezza
    // barra (64). Corregge anche il problema del padding fisso noto dalla home.
    final topInset = MediaQuery.paddingOf(context).top + 16 + 64;

    return Scaffold(
      backgroundColor: AppColors.surface,
      // Nav ancorata al fondo dello schermo via Scaffold: il body termina
      // sopra la barra e la safe area inferiore è gestita dalla barra stessa.
      bottomNavigationBar: const AppBottomNav(),
      body: Stack(
        children: [
          // Il viewport scrollabile riempie SEMPRE l'intero body (viewport
          // meno nav): Positioned.fill impone vincoli tight, senza dipendere
          // dallo shrink-wrap del figlio non-posizionato dello Stack.
          Positioned.fill(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(top: topInset, bottom: 24),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 448),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 8),
                        _QuickGuideBadge(l10n: l10n),
                        const SizedBox(height: 8),
                        _TitleGroup(l10n: l10n),
                        const SizedBox(height: 24),
                        _FeaturePills(l10n: l10n),
                        const SizedBox(height: 24),
                        _RuleCard(
                          number: '01',
                          numberColor: AppColors.primaryContainer,
                          title: l10n.sceglieIlMazzo,
                          icon: const _RuleIcon(
                            type: _RuleIconType.cardDeck,
                            color: AppColors.primaryContainer,
                          ),
                          text: Text(
                            l10n.mazzoTesto,
                            style: AppTextStyles.body.copyWith(
                              color: AppColors.onSurfaceVariant,
                              height: 1.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        _RuleCard(
                          number: '02',
                          numberColor: AppColors.primaryContainer,
                          title: l10n.pronunciaEPassa,
                          icon: const _RuleIcon(
                            type: _RuleIconType.phoneHandoff,
                            color: AppColors.tertiary,
                          ),
                          text: Text(
                            l10n.pronunciaTesto,
                            style: AppTextStyles.body.copyWith(
                              color: AppColors.onSurfaceVariant,
                              height: 1.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        _RuleCard(
                          number: '03',
                          numberColor: AppColors.error,
                          title: l10n.detonazioneSorpresa,
                          icon: const _RuleIcon(
                            type: _RuleIconType.detonator,
                            color: AppColors.secondary,
                          ),
                          // "BOOM" in colore error semibold tracking-wide,
                          // reso con Text.rich (onomatopea identica in it/en).
                          text: Text.rich(
                            TextSpan(
                              text: '${l10n.detonazioneTesto} ',
                              children: [
                                TextSpan(
                                  text: 'BOOM',
                                  style: AppTextStyles.body.copyWith(
                                    color: AppColors.error,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 1.0,
                                  ),
                                ),
                                TextSpan(
                                  text: ' ${l10n.detonazioneTestoFinale}',
                                ),
                              ],
                            ),
                            style: AppTextStyles.body.copyWith(
                              color: AppColors.onSurfaceVariant,
                              height: 1.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        _GoldenRuleCallout(l10n: l10n),
                        const SizedBox(height: 32),
                        _UnderstoodCta(
                          controller: controller,
                          label: l10n.hoCapitoIniziamo,
                        ),
                        const SizedBox(height: 8),
                        _EstimatedTimeFooter(l10n: l10n),
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
            child: AppHeader(),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Badge "Guida rapida" + titolo + sottotitolo
// ---------------------------------------------------------------------------

class _QuickGuideBadge extends StatelessWidget {
  const _QuickGuideBadge({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Dot con glow ambra (shadow-[0_0_8px_rgba(251,191,36,0.6)]).
        Container(
          width: 6,
          height: 6,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primaryContainer,
            boxShadow: [
              BoxShadow(
                color: Color(0x99FBBF24), // rgba(251,191,36,0.6)
                blurRadius: 8,
              ),
            ],
          ),
        ),
        const SizedBox(width: 6),
        Text(
          l10n.guidaRapida.toUpperCase(),
          style: AppTextStyles.labelMono.copyWith(
            fontSize: 10,
            color: AppColors.primaryContainer,
          ),
        ),
      ],
    );
  }
}

class _TitleGroup extends StatelessWidget {
  const _TitleGroup({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.comeSiGioca.toUpperCase(),
          style: AppTextStyles.headline.copyWith(
            color: AppColors.onSurface,
            letterSpacing: 0,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          l10n.regoleEssenziali,
          style: AppTextStyles.body.copyWith(color: AppColors.onSurfaceVariant),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Pill feature: ZERO ATTESE / TIMER SEGRETO / 2-20 GIOCATORI
// ---------------------------------------------------------------------------

class _FeaturePills extends StatelessWidget {
  const _FeaturePills({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _FeaturePill(
          icon: Icons.bolt,
          iconColor: AppColors.tertiary,
          label: l10n.zeroAttese,
        ),
        _FeaturePill(
          icon: Icons.timer_outlined,
          iconColor: AppColors.primaryContainer,
          label: l10n.timerSegreto,
        ),
      ],
    );
  }
}

class _FeaturePill extends StatelessWidget {
  const _FeaturePill({
    required this.icon,
    required this.iconColor,
    required this.label,
  });

  final IconData icon;
  final Color iconColor;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: iconColor),
          const SizedBox(width: 6),
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
// Card regola numerata con micro-illustrazione
// ---------------------------------------------------------------------------

class _RuleCard extends StatelessWidget {
  const _RuleCard({
    required this.number,
    required this.numberColor,
    required this.title,
    required this.icon,
    required this.text,
  });

  final String number;
  final Color numberColor;
  final String title;
  final Widget icon;
  final Widget text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.2),
            offset: const Offset(0, 2),
            blurRadius: 6,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        number,
                        style: AppTextStyles.labelMono.copyWith(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: numberColor,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        title,
                        style: AppTextStyles.headline.copyWith(
                          fontSize: 18,
                          color: AppColors.onSurface,
                          letterSpacing: 0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              icon,
            ],
          ),
          const SizedBox(height: 12),
          text,
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Micro-illustrazioni SVG repicate in CustomPaint (viewBox 24x24, stroke
// 1.8 round, resi a 20x20 come w-5 h-5 del riferimento).
// ---------------------------------------------------------------------------

enum _RuleIconType { cardDeck, phoneHandoff, detonator }

class _RuleIcon extends StatelessWidget {
  const _RuleIcon({required this.type, required this.color});

  final _RuleIconType type;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(8),
      ),
      child: CustomPaint(
        size: const Size(20, 20),
        painter: _RuleIconPainter(type: type, color: color),
      ),
    );
  }
}

class _RuleIconPainter extends CustomPainter {
  const _RuleIconPainter({required this.type, required this.color});

  final _RuleIconType type;
  final Color color;

  static const double _strokeWidth = 1.8;

  @override
  void paint(Canvas canvas, Size size) {
    // Dal viewBox 24x24 del riferimento alla size di resa.
    canvas.scale(size.width / 24, size.height / 24);

    final stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = _strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..color = color;

    switch (type) {
      case _RuleIconType.cardDeck:
        _paintCardDeck(canvas, stroke);
      case _RuleIconType.phoneHandoff:
        _paintPhoneHandoff(canvas, stroke);
      case _RuleIconType.detonator:
        _paintDetonator(canvas, stroke);
    }
  }

  /// 01: mazzo di carte (rect + retro-rect con angolo arrotondato + pino).
  void _paintCardDeck(Canvas canvas, Paint stroke) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(3, 5, 13, 15),
        const Radius.circular(1.5),
      ),
      stroke,
    );
    // M 8 3 h 10 a 1.5 1.5 0 0 1 1.5 1.5 V 17 (angolo arrotondato via cubica).
    final back = Path()
      ..moveTo(8, 3)
      ..lineTo(18, 3)
      ..cubicTo(18.8, 3, 19.5, 3.7, 19.5, 4.5)
      ..lineTo(19.5, 17);
    canvas.drawPath(back, stroke);
    // Pino centrale pieno.
    canvas.drawCircle(
      const Offset(9.5, 12.5),
      1.5,
      Paint()..color = color,
    );
  }

  /// 02: telefono + frecce di passaggio a destra e sinistra.
  void _paintPhoneHandoff(Canvas canvas, Paint stroke) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(7, 3, 10, 18),
        const Radius.circular(2),
      ),
      stroke,
    );
    canvas.drawLine(const Offset(11, 17), const Offset(13, 17), stroke);
    // Freccia sinistra: M 4 10 l -2 2 2 2.
    final leftArrow = Path()
      ..moveTo(4, 10)
      ..lineTo(2, 12)
      ..lineTo(4, 14);
    canvas.drawPath(leftArrow, stroke);
    // Freccia destra: M 20 10 l 2 2 -2 2.
    final rightArrow = Path()
      ..moveTo(20, 10)
      ..lineTo(22, 12)
      ..lineTo(20, 14);
    canvas.drawPath(rightArrow, stroke);
  }

  /// 03: detonatore (cerchio + stelo + contestatore + core pieno).
  void _paintDetonator(Canvas canvas, Paint stroke) {
    canvas.drawCircle(const Offset(12, 14), 7, stroke);
    canvas.drawLine(const Offset(12, 7), const Offset(12, 4), stroke);
    canvas.drawLine(const Offset(10, 4), const Offset(14, 4), stroke);
    canvas.drawLine(const Offset(15, 4), const Offset(17, 2), stroke);
    canvas.drawCircle(const Offset(12, 14), 2.5, Paint()..color = color);
  }

  @override
  bool shouldRepaint(_RuleIconPainter oldDelegate) {
    return oldDelegate.type != type || oldDelegate.color != color;
  }
}

// ---------------------------------------------------------------------------
// Callout "Regola d'oro"
// ---------------------------------------------------------------------------

class _GoldenRuleCallout extends StatelessWidget {
  const _GoldenRuleCallout({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 12, 12),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.25),
            offset: const Offset(0, 4),
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Barra verticale primary-container a sinistra (w-1).
          Container(width: 4, height: 44, color: AppColors.primaryContainer),
          const SizedBox(width: 12),
          Container(
            width: 32,
            height: 32,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.primaryContainer.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Icon(
              Icons.verified,
              size: 18,
              color: AppColors.primaryContainer,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.regolaDoro.toUpperCase(),
                  style: AppTextStyles.labelMono.copyWith(
                    fontSize: 10,
                    color: AppColors.primaryContainer,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  l10n.regolaDoroTesto,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.onSurface,
                    fontWeight: FontWeight.w500,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// CTA "HO CAPITO, INIZIAMO!" + footer nota
// ---------------------------------------------------------------------------

class _UnderstoodCta extends StatefulWidget {
  const _UnderstoodCta({required this.controller, required this.label});

  final RulesController controller;
  final String label;

  @override
  State<_UnderstoodCta> createState() => _UnderstoodCtaState();
}

class _UnderstoodCtaState extends State<_UnderstoodCta> {
  bool _pressed = false;

  Future<void> _handleTap() async {
    if (_pressed) {
      return;
    }
    setState(() => _pressed = true);
    // Feedback tattile composito (replica navigator.vibrate([15,30,25])).
    await AppHaptics.mediumImpact();
    await Future<void>.delayed(const Duration(milliseconds: 120));
    if (!mounted) {
      return;
    }
    setState(() => _pressed = false);
    widget.controller.goHome();
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
          height: 52,
          decoration: BoxDecoration(
            color: AppColors.primaryContainer,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: Color(0x2EFBBF24), // rgba(251,191,36,0.18)
                offset: Offset(0, 0),
                blurRadius: 20,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.label.toUpperCase(),
                style: AppTextStyles.labelAction.copyWith(
                  color: AppColors.onPrimaryContainer,
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.arrow_forward,
                size: 20,
                color: AppColors.onPrimaryContainer,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EstimatedTimeFooter extends StatelessWidget {
  const _EstimatedTimeFooter({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.outline,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          l10n.tempoStimatoRound.toUpperCase(),
          style: AppTextStyles.labelMono.copyWith(
            fontSize: 10,
            color: AppColors.outline,
          ),
        ),
      ],
    );
  }
}
