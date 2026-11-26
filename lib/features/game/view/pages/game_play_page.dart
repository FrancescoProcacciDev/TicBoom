import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ticboom/core/game/category_style.dart';
import 'package:ticboom/core/game/sound_fx_service.dart';
import 'package:ticboom/core/styles/app_colors.dart';
import 'package:ticboom/core/styles/app_text_styles.dart';
import 'package:ticboom/core/view/widgets/bomb_vector.dart';
import 'package:ticboom/features/game/view/controllers/game_play_controller.dart';
import 'package:ticboom/l10n/app_localizations.dart';

/// Schermata di partita in corso: categoria e domanda estratte, bomba con
/// miccia accesa, indicatore TIC! TAC… e card riepilogo con le istruzioni
/// per il passaggio dello smartphone.
///
/// Nessun countdown visibile: la durata della bomba resta segreta. Il back
/// (sistema o freccia) chiede conferma prima di abbandonare la partita.
class GamePlayPage extends StatefulWidget {
  const GamePlayPage({super.key});

  @override
  State<GamePlayPage> createState() => _GamePlayPageState();
}

class _GamePlayPageState extends State<GamePlayPage> {
  late final GamePlayController controller;

  @override
  void initState() {
    super.initState();
    // Il ciclo di vita del controller è legato a QUESTA pagina (l'app usa
    // go_router senza GetMaterialApp, quindi GetX non smaltisce i controller
    // a fine rotta). Se resta registrato un esemplare di una pagina
    // precedente (cambio rotta nello stesso frame), lo si chiude prima di
    // registrarne uno nuovo.
    if (Get.isRegistered<GamePlayController>()) {
      Get.delete<GamePlayController>(force: true);
    }
    controller = Get.put(GamePlayController());
  }

  @override
  void dispose() {
    // Cancella il controller solo se è ancora quello di questa pagina:
    // durante un cambio rotta l'initState della nuova pagina gira prima del
    // dispose della vecchia, quindi la registrazione potrebbe essere già
    // passata a un controller più recente.
    if (Get.isRegistered<GamePlayController>()) {
      if (identical(Get.find<GamePlayController>(), controller)) {
        Get.delete<GamePlayController>();
      }
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final session = controller.session;

    if (session == null) {
      // Nessuna sessione: il controller sta già riportando al setup.
      return const Scaffold(
        backgroundColor: AppColors.surface,
        body: SizedBox.shrink(),
      );
    }

    return PopScope(
      // Il back non abbandona la partita in silenzio: chiede conferma.
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          return;
        }
        _confirmAbandon(context, controller);
      },
      child: Scaffold(
        backgroundColor: AppColors.surface,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _Header(onBack: () => _confirmAbandon(context, controller)),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      _CategoryChip(
                        categoria: session.categoria,
                        label: _categoriaLabel(session.categoria, l10n),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        session.domanda,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.headline.copyWith(
                          color: AppColors.onSurface,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const _BurningBombVector(),
                      const SizedBox(height: 8),
                      const _TicTacIndicator(),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainer,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.outlineVariant),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.smartphone,
                                  size: 20,
                                  color: AppColors.primaryContainer,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    l10n.bombaInMano,
                                    style: AppTextStyles.titleCard.copyWith(
                                      color: AppColors.onSurface,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.tertiaryContainer
                                        .withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                  child: Text(
                                    l10n.inGioco,
                                    style: AppTextStyles.labelMono.copyWith(
                                      fontSize: 9,
                                      color: AppColors.tertiaryContainer,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              l10n.toccaAChiHaIlTelefono,
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              l10n.rispondiEPassa,
                              style: AppTextStyles.bodyLarge.copyWith(
                                color: AppColors.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(
                                  Icons.block,
                                  size: 14,
                                  color: AppColors.onSurfaceVariant,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  l10n.nessunaRipetizione,
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: AppColors.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _categoriaLabel(String categoria, AppLocalizations l10n) {
    return switch (categoria) {
      'ANIMALI' => l10n.categoriaAnimali,
      'CIBO E BEVANDE' => l10n.categoriaCiboBevande,
      'CALCIO' => l10n.categoriaCalcio,
      'ANIME' => l10n.categoriaAnime,
      'GEOGRAFIA' => l10n.categoriaGeografia,
      'FILM E SERIE TV' => l10n.categoriaFilmSerieTv,
      'MUSICA' => l10n.categoriaMusica,
      'VIDEOGIOCHI' => l10n.categoriaVideogiochi,
      'VITA QUOTIDIANA' => l10n.categoriaVitaQuotidiana,
      'CULTURA GENERALE' => l10n.categoriaCulturaGenerale,
      'SUPEREROI E FUMETTI' => l10n.categoriaSupereroiFumetti,
      'PAROLE E LETTERE' => l10n.categoriaParoleLettere,
      _ => categoria,
    };
  }

  /// Dialog di conferma abbandono: annulla → la partita prosegue con il
  /// timer originale (la scadenza non cambia); conferma → stop e home.
  Future<void> _confirmAbandon(
    BuildContext context,
    GamePlayController controller,
  ) async {
    final l10n = AppLocalizations.of(context);
    final abandon = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.surfaceContainer,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          l10n.abbandonoTitolo,
          style: AppTextStyles.titleCard.copyWith(color: AppColors.onSurface),
        ),
        content: Text(
          l10n.abbandonoTesto,
          style: AppTextStyles.body.copyWith(color: AppColors.onSurfaceVariant),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(
              l10n.abbandonoAnnulla,
              style: AppTextStyles.labelAction.copyWith(
                color: AppColors.primaryContainer,
                fontSize: 13,
              ),
            ),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.secondaryContainer,
              foregroundColor: AppColors.onSecondaryContainer,
            ),
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l10n.abbandonoConferma),
          ),
        ],
      ),
    );
    if (abandon ?? false) {
      controller.abandonGame();
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Header con freccia back (passa dal dialog di abbandono)
// ─────────────────────────────────────────────────────────────────────────────

class _Header extends StatelessWidget {
  const _Header({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 24, 8),
      child: Row(
        children: [
          IconButton(
            onPressed: onBack,
            icon: const Icon(Icons.arrow_back),
            color: AppColors.onSurfaceVariant,
            tooltip: l10n.abbandonoTitolo,
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              l10n.partitaInCorsoTitle,
              style: AppTextStyles.titleCard.copyWith(
                color: AppColors.onSurface,
              ),
            ),
          ),
          // Toggle mute di partita: condivisa con la home la chiave
          // persistita (SoundFxService); il ticchettio si ferma/riparte
          // subito grazie all'osservatore del controller.
          Obx(() {
            final soundFx = Get.find<SoundFxService>();
            return IconButton(
              onPressed: soundFx.toggleSoundFx,
              icon: Icon(
                soundFx.isMuted.value ? Icons.volume_off : Icons.volume_up,
              ),
              color: AppColors.onSurfaceVariant,
            );
          }),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Chip della categoria estratta
// ─────────────────────────────────────────────────────────────────────────────

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({required this.categoria, required this.label});

  final String categoria;
  final String label;

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
          Icon(
            CategoryStyle.iconFor(categoria),
            size: 16,
            color: AppColors.primaryContainer,
          ),
          const SizedBox(width: 8),
          Text(
            label.toUpperCase(),
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
// Bomba condivisa della home (BombVector) con miccia che si consuma
// ─────────────────────────────────────────────────────────────────────────────

class _BurningBombVector extends StatefulWidget {
  const _BurningBombVector();

  @override
  State<_BurningBombVector> createState() => _BurningBombVectorState();
}

class _BurningBombVectorState extends State<_BurningBombVector>
    with SingleTickerProviderStateMixin {
  /// Ciclo di consumo della miccia (4s): il filo si accorcia dalla punta
  /// verso la calotta; al termine riparte con il flash di riaccensione
  /// gestito dal painter condiviso [BombVector].
  late final AnimationController _burn = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 4000),
  )..repeat();

  @override
  void dispose() {
    _burn.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _burn,
      builder: (context, _) {
        return BombVector(
          size: const Size(200, 200),
          fuseProgress: _burn.value,
          relightFlash: true,
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Indicatore ritmico TIC! / TAC… (decorativo, non legato al timer segreto)
// ─────────────────────────────────────────────────────────────────────────────

class _TicTacIndicator extends StatefulWidget {
  const _TicTacIndicator();

  @override
  State<_TicTacIndicator> createState() => _TicTacIndicatorState();
}

class _TicTacIndicatorState extends State<_TicTacIndicator> {
  static const _labels = ['tic', 'tac'];
  Timer? _ticker;
  int _index = 0;

  @override
  void initState() {
    super.initState();
    _ticker = Timer.periodic(const Duration(milliseconds: 700), (_) {
      if (mounted) {
        setState(() {
          _index = (_index + 1) % _labels.length;
        });
      }
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Text(
      _index == 0 ? l10n.ticLabel : l10n.tacLabel,
      style: AppTextStyles.labelAction.copyWith(
        color: AppColors.primaryContainer,
        fontSize: 14,
      ),
    );
  }
}
