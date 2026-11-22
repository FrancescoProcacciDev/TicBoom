import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:ticboom/core/game/game_service.dart';
import 'package:ticboom/core/game/game_session.dart';
import 'package:ticboom/core/game/sound_fx_service.dart';
import 'package:ticboom/core/routing/app_route.dart';

/// Controller della partita in corso: gestisce il timer segreto della bomba
/// basato sulla scadenza effettiva ([GameSession.scadenza]), l'esplosione e
/// gli effetti sonori (tic-tac in loop, boom che lo sostituisce).
///
/// Requisiti chiave:
/// - un solo timer, mai azzerato né riavviato;
/// - il tempo resta corretto anche se l'app va in background (la decisione
///   di esplosione confronta sempre `DateTime.now()` con la scadenza);
/// - l'esplosione avviene una sola volta e senza interazione dell'utente;
/// - nessun suono residuo a fine partita o dopo l'abbandono.
class GamePlayController extends GetxController with WidgetsBindingObserver {
  GamePlayController();

  GameSession? _session;
  Timer? _bombTimer;
  bool _isExploded = false;
  Worker? _muteWorker;

  /// Sessione corrente (categoria e domanda fisse per tutta la manche).
  GameSession? get session => _session;

  /// Feedback del pulsante "Passa il telefono" (solo visivo: non tocca
  /// domanda, categoria, timer né navigazione).
  final passFeedbackActive = false.obs;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    _session = Get.find<GameService>().session;
    if (_session == null) {
      // Accesso diretto alla rotta senza partita avviata: torna al setup.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.find<GoRouter>().go(AppRoute.gameConfig.path);
      });
      return;
    }
    _startBombTimer();
    _startSoundFx();
  }

  /// Un solo timer periodico: ogni tick confronta l'ora effettiva con la
  /// scadenza registrata. Non conta intervalli, quindi drift e sospensioni
  /// in background non falsano il risultato.
  void _startBombTimer() {
    _bombTimer?.cancel();
    _bombTimer = Timer.periodic(const Duration(milliseconds: 250), (_) {
      _checkDeadline();
    });
  }

  /// Effetti sonori: tic-tac in loop se non muto, sincronizzato con il
  /// toggle del mute (anche quello dell'header di partita).
  void _startSoundFx() {
    final soundFx = Get.find<SoundFxService>();
    if (!soundFx.isMuted.value) {
      soundFx.startTickLoop();
    }
    _muteWorker = ever<bool>(soundFx.isMuted, (muted) {
      if (muted) {
        soundFx.stopTick();
      } else if (!_isExploded && _session != null) {
        soundFx.startTickLoop();
      }
    });
  }

  void _checkDeadline() {
    if (_isExploded || _session == null) {
      return;
    }
    if (DateTime.now().isAfter(_session!.scadenza)) {
      _explode();
    }
  }

  /// Esplosione: una sola volta per tutta la vita del controller. Il boom
  /// prende il posto del ticchettio, poi si naviga alla fine partita.
  void _explode() {
    if (_isExploded) {
      return;
    }
    _isExploded = true;
    _bombTimer?.cancel();
    _bombTimer = null;
    Get.find<SoundFxService>().playExplosion();
    Get.find<GoRouter>().go(AppRoute.gameOver.path);
  }

  /// Ritorno in primo piano: se il tempo è scaduto mentre l'app era in
  /// background, l'esplosione avviene subito al resume.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkDeadline();
    }
  }

  /// CTA "Passa il telefono": nessun effetto sul gioco, solo un breve
  /// feedback visivo.
  void passThePhone() {
    if (passFeedbackActive.value) {
      return;
    }
    passFeedbackActive.value = true;
    Future.delayed(const Duration(milliseconds: 600), () {
      passFeedbackActive.value = false;
    });
  }

  /// Abbandono confermato dall'utente: interrompe il timer e i suoni,
  /// termina la sessione e torna alla homepage.
  void abandonGame() {
    _isExploded = true; // impedisce ulteriori esplosioni/navigazioni
    _bombTimer?.cancel();
    _bombTimer = null;
    Get.find<SoundFxService>().stopTick();
    Get.find<GameService>().clearSession();
    Get.find<GoRouter>().go(AppRoute.home.path);
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    _bombTimer?.cancel();
    _bombTimer = null;
    _muteWorker?.dispose();
    _muteWorker = null;
    Get.find<SoundFxService>().stopTick();
    super.onClose();
  }
}
