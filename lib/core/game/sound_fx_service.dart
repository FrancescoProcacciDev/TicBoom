import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ticboom/core/utils/app_key_store.dart';

/// Servizio degli effetti sonori di gioco: tic-tac durante la manche ed
/// esplosione che lo sostituisce al boom della bomba.
///
/// Unica fonte di verità per il mute: persiste la chiave già usata
/// dall'interruttore della home (AppKeyStore.soundFxMuted) e ogni
/// chiamata è inerte quando l'audio è muto.
class SoundFxService extends GetxService {
  /// Stato del mute persistito (osservabile dai toggle UI).
  final isMuted = false.obs;

  AudioPlayer? _tickPlayer;
  AudioPlayer? _boomPlayer;

  @override
  void onInit() {
    super.onInit();
    final preferences = Get.find<SharedPreferences>();
    isMuted.value = preferences.getBool(AppKeyStore.soundFxMuted) ?? false;
  }

  /// Avvia il tic-tac mentre il timer della bomba scorre.
  /// Nessun effetto se l'audio è muto.
  Future<void> startTick() async {
    if (isMuted.value) {
      return;
    }
    await _stopTick();
    final player = AudioPlayer();
    _tickPlayer = player;
    await player.play(AssetSource('sounds/tic_tac_4.mp3'));
  }

  /// Prepara in anticipo il player del boom: carica e decodifica l'asset una
  /// volta, così all'esplosione il suono parte senza latenza di caricamento.
  /// Inerte se muto: la preparazione avviene al momento dell'unmute.
  Future<void> prepareExplosion() async {
    if (isMuted.value) {
      return;
    }
    final oldBoom = _boomPlayer;
    _boomPlayer = null;
    if (oldBoom != null) {
      await oldBoom.stop();
      await oldBoom.dispose();
    }
    final player = AudioPlayer();
    _boomPlayer = player;
    await player.setSource(AssetSource('sounds/explosion.mp3'));
    // TODO(log-timing): log temporaneo di diagnostica latenza, da rimuovere.
    debugPrint(
      '[boom] prepared ${DateTime.now().millisecondsSinceEpoch}',
    );
  }

  /// Esplosione: fa partire il boom e ferma il tic-tac solo dopo, con un
  /// breve margine: il ticchettio copre la latenza di avvio del boom e il
  /// botto a pieno volume lo inghiotte, così non c'è silenzio tra i due.
  /// Il tick viene solo fermato ([_pauseTick]), senza dispose: il rilascio
  /// del MediaPlayer avviene poi in [startTickLoop] (avvio della prossima
  /// partita), [toggleSoundFx], [onClose] e in caso di abbandono
  /// ([stopTick]), tutti fuori dal percorso critico.
  /// Se muto non c'è alcun suono: solo la fermata immediata del tick.
  /// Se il player preparato manca (caso imprevisto), ricrea al volo con la
  /// latenza di caricamento.
  Future<void> playExplosion() async {
    // TODO(log-timing): log temporanei di diagnostica latenza, da rimuovere.
    debugPrint(
      '[boom] playExplosion start ${DateTime.now().millisecondsSinceEpoch}',
    );
    if (isMuted.value) {
      await _pauseTick();
      return;
    }
    final player = _boomPlayer;
    if (player != null) {
      await player.resume();
      debugPrint(
        '[boom] resume done ${DateTime.now().millisecondsSinceEpoch}',
      );
    } else {
      final fallback = AudioPlayer();
      _boomPlayer = fallback;
      await fallback.play(AssetSource('sounds/explosion.mp3'));
      debugPrint(
        '[boom] fallback play done ${DateTime.now().millisecondsSinceEpoch}',
      );
    }
    // Il boom è partito: con un breve margine il ticchettio viene
    // inghiottito dal botto invece di lasciare un buco di silenzio.
    unawaited(
      Future<void>.delayed(const Duration(milliseconds: 150), _pauseTick),
    );
  }

  /// Stop netto del ticchettio (esplosione, abbandono, dispose).
  Future<void> stopTick() => _stopTick();

  /// Toggle del mute persistito: se si entra in muto il ticchettio si ferma
  /// subito. Il riavvio del ticchettio (se una partita è in corso) è gestito
  /// dal controller di partita, che osserva [isMuted].
  Future<void> toggleSoundFx() async {
    isMuted.value = !isMuted.value;
    final preferences = Get.find<SharedPreferences>();
    await preferences.setBool(AppKeyStore.soundFxMuted, isMuted.value);
    if (isMuted.value) {
      await _stopTick();
    }
  }

  /// Fermata leggera del ticchettio: solo stop, senza dispose. Usata
  /// all'esplosione per tenere il rilascio del MediaPlayer fuori dal
  /// percorso critico del boom; il dispose avviene poi in [startTickLoop],
  /// [toggleSoundFx] e [onClose].
  Future<void> _pauseTick() async {
    final player = _tickPlayer;
    if (player != null) {
      await player.stop();
    }
  }

  Future<void> _stopTick() async {
    final player = _tickPlayer;
    _tickPlayer = null;
    if (player != null) {
      await player.stop();
      await player.dispose();
    }
  }

  @override
  void onClose() {
    _stopTick();
    final boom = _boomPlayer;
    _boomPlayer = null;
    if (boom != null) {
      boom.dispose();
    }
    super.onClose();
  }
}
