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
/// Unica fonte di verità per la musica: il volume (0-100, persistito sulla
/// chiave AppKeyStore.musicVolume) guida tutto — 0 equivale a disattivata.
/// Il player è creato UNA SOLA VOLTA e resta vivo per tutta la sessione:
/// l'asset è pre-caricato con [AudioPlayer.setSource] (decodifica a monte),
/// quindi pausa/ripartenza e variazioni di volume sono istantanee. La
/// ripresa avviene con [AudioPlayer.resume], che prosegue dalla posizione
/// di pausa invece di ripartire dall'inizio della traccia.
class BgmService extends GetxService {
  static const String _asset = 'sounds/tic_boom_soundtrack_2.mp3';

  /// Volume di default quando non c'è alcun valore salvato.
  static const int _defaultVolume = 50;

  /// Volume della musica (0-100, osservabile dallo slider di settings):
  /// 0 equivale a disattivata.
  final volume = _defaultVolume.obs;

  /// Contatore di sospensioni attive: le due schermate di gioco (partita e
  /// fine partita) si sovrappongono al cambio rotta, quindi la ripresa
  /// avviene solo quando TUTTE le sospensioni sono state rilasciate.
  int _suspendCount = 0;

  /// Player persistente: null finché non è pronto (asset pre-caricato).
  AudioPlayer? _player;

  /// Pre-caricamento in corso: le richieste di riproduzione lo attendono.
  Future<void>? _preparing;

  @override
  void onInit() {
    super.onInit();
    final preferences = Get.find<SharedPreferences>();
    // Migrazione dallo switch "Musica di Sottofondo": chi aveva la musica
    // muta parte da volume 0 (disattivata).
    final wasMuted = preferences.getBool(AppKeyStore.musicMuted) ?? false;
    volume.value = wasMuted
        ? 0
        : preferences.getInt(AppKeyStore.musicVolume) ?? _defaultVolume;
    // Musica attiva dal bootstrap, se il volume lo consente.
    unawaited(_syncPlayback());
  }

  /// Imposta il volume (0-100): persistito e applicato LIVE al player, così
  /// lo slider si sente mentre si trascina. 0 mette in pausa (disattivata),
  /// un valore > 0 fa riprendere la musica dalla posizione di pausa.
  Future<void> setMusicVolume(int value) async {
    final clamped = value.clamp(0, 100);
    volume.value = clamped;
    final preferences = Get.find<SharedPreferences>();
    await preferences.setInt(AppKeyStore.musicVolume, clamped);
    await _syncPlayback();
  }

  /// Sospensione (schermate di partita): pausa della musica; il conteggio
  /// rende idempotenti le chiamate sovrapposte di partita e fine partita.
  void suspend() {
    _suspendCount++;
    if (_suspendCount == 1) {
      unawaited(_player?.pause());
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
    if (_suspendCount == 0) {
      unawaited(_syncPlayback());
    }
  }

  /// Sincronizza lo stato del player con volume e sospensioni: suona se e
  /// solo se volume > 0 e nessuna sospensione attiva.
  Future<void> _syncPlayback() async {
    final shouldPlay = volume.value > 0 && _suspendCount == 0;
    if (!shouldPlay) {
      await _player?.pause();
      return;
    }
    final preparing = _preparing ?? _preparePlayer();
    await preparing;
    if (volume.value <= 0 || _suspendCount > 0) {
      // Stato cambiato durante la preparazione: nessun avvio.
      return;
    }
    final player = _player;
    if (player == null) {
      return;
    }
    // TODO(log-timing): log temporaneo di diagnostica latenza, da rimuovere.
    final stopWatch = Stopwatch()..start();
    await player.setVolume(volume.value / 100);
    await player.resume();
    debugPrint(
      '[bgm] resume done in ${stopWatch.elapsedMilliseconds}ms '
      '${DateTime.now().millisecondsSinceEpoch}',
    );
  }

  /// Pre-caricamento (una sola volta): crea il player, imposta il loop e
  /// carica/decodifica l'asset mentre è fermo. Le chiamate concorrenti
  /// condividono lo stesso future.
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
    await player.setSource(AssetSource(_asset));
    _player = player;
  }

  @override
  void onClose() {
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
