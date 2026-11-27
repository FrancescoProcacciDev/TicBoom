import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ticboom/core/utils/app_key_store.dart';

/// Servizio della musica di sottofondo: loop continuo della soundtrack su
/// tutte le schermate tranne partita in corso e fine partita, dove la
/// riproduzione è sospesa per lasciare spazio al tic-tac e al boom.
///
/// Unica fonte di verità per il mute della musica: persiste la chiave già
/// usata dallo switch "Musica di Sottofondo" nelle impostazioni
/// (AppKeyStore.musicMuted).
///
/// Il player è creato UNA SOLA VOLTA e resta vivo per tutta la sessione:
/// l'asset è pre-caricato con [AudioPlayer.setSource] (decodifica a monte),
/// quindi pausa/ripartenza e mute/unmute sono istantanei, senza ricarichi.
/// La ripresa avviene con [AudioPlayer.resume], che prosegue dalla posizione
/// di pausa invece di ripartire dall'inizio della traccia.
class BgmService extends GetxService {
  /// Volume del sottofondo: presente ma sotto il ticchettio e il boom.
  static const double _bgmVolume = 0.45;

  static const String _asset = 'sounds/tic_boom_soundtrack_2.mp3';

  /// Stato del mute persistito (osservabile dallo switch di settings).
  final isMuted = false.obs;

  /// Contatore di sospensioni attive: le due schermate di gioco (partita e
  /// fine partita) si sovrappongono al cambio rotta, quindi la ripresa
  /// avviene solo quando TUTTE le sospensioni sono state rilasciate.
  int _suspendCount = 0;

  /// Player persistente: null finché non è pronto (asset pre-caricato).
  AudioPlayer? _player;

  /// Pre-caricamento in corso: le richieste di ripresa lo attendono.
  Future<void>? _preparing;

  Worker? _muteWorker;

  @override
  void onInit() {
    super.onInit();
    final preferences = Get.find<SharedPreferences>();
    isMuted.value = preferences.getBool(AppKeyStore.musicMuted) ?? false;
    // Il toggle del mute (da qualunque schermata) mette in pausa o fa
    // riprendere subito la musica, se non è sospesa dalle schermate di gioco.
    _muteWorker = ever<bool>(isMuted, (muted) {
      if (muted) {
        _pausePlayer();
      } else {
        unawaited(_playPrepared());
      }
    });
    // Musica attiva dal bootstrap, rispettando subito il mute persistito.
    if (!isMuted.value) {
      unawaited(_playPrepared());
    }
  }

  /// Toggle del mute persistito: la riproduzione segue via osservatore.
  Future<void> toggleSound() async {
    isMuted.value = !isMuted.value;
    final preferences = Get.find<SharedPreferences>();
    await preferences.setBool(AppKeyStore.musicMuted, isMuted.value);
  }

  /// Sospensione (schermate di partita): pausa della musica; il conteggio
  /// rende idempotenti le chiamate sovrapposte di partita e fine partita.
  void suspend() {
    _suspendCount++;
    if (_suspendCount == 1) {
      _pausePlayer();
    }
  }

  /// Ripresa (uscita dalle schermate di partita): la musica riparte solo
  /// quando tutte le sospensioni sono state rilasciate. Chiamate in eccesso
  /// (mai sospesa) sono no-op.
  void resume() {
    if (_suspendCount == 0) {
      return;
    }
    _suspendCount--;
    if (_suspendCount == 0 && !isMuted.value) {
      unawaited(_playPrepared());
    }
  }

  /// Avvio/ripartenza: attende l'eventuale pre-caricamento in corso e poi
  /// fa ripartire il player dalla posizione di pausa (o da zero al primo
  /// avvio, che è subito dopo la preparazione).
  Future<void> _playPrepared() async {
    if (isMuted.value || _suspendCount > 0) {
      return;
    }
    final preparing = _preparing ?? _preparePlayer();
    await preparing;
    if (isMuted.value || _suspendCount > 0) {
      // Stato cambiato durante la preparazione: nessun avvio.
      return;
    }
    final player = _player;
    if (player == null) {
      return;
    }
    // TODO(log-timing): log temporaneo di diagnostica latenza, da rimuovere.
    final stopWatch = Stopwatch()..start();
    await player.resume();
    debugPrint(
      '[bgm] resume done in ${stopWatch.elapsedMilliseconds}ms '
      '${DateTime.now().millisecondsSinceEpoch}',
    );
  }

  /// Pre-caricamento (una sola volta): crea il player, imposta loop e
  /// volume e carica/decodifica l'asset mentre è fermo. Le chiamate
  /// concorrenti condividono lo stesso future.
  Future<void> _preparePlayer() {
    final existing = _preparing;
    if (existing != null) {
      return existing;
    }
    final preparing = _doPrepare();
    _preparing = preparing;
    unawaited(
      preparing.whenComplete(() => _preparing = null),
    );
    return preparing;
  }

  Future<void> _doPrepare() async {
    if (_player != null) {
      return;
    }
    final player = AudioPlayer();
    await player.setReleaseMode(ReleaseMode.loop);
    await player.setVolume(_bgmVolume);
    await player.setSource(AssetSource(_asset));
    _player = player;
  }

  /// Pausa: istantanea e ripetibile (riprende da posizione).
  Future<void> _pausePlayer() async {
    await _player?.pause();
  }

  @override
  void onClose() {
    _muteWorker?.dispose();
    _muteWorker = null;
    final player = _player;
    _player = null;
    if (player != null) {
      unawaited(
        player.stop().whenComplete(player.dispose),
      );
    }
    super.onClose();
  }
}
