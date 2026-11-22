import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ticboom/core/utils/app_key_store.dart';

/// Servizio degli effetti sonori di gioco: tic-tac in loop durante la
/// manche ed esplosione che lo sostituisce al boom della bomba.
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

  /// Avvia il loop del tic-tac mentre il timer della bomba scorre.
  /// Nessun effetto se l'audio è muto.
  Future<void> startTickLoop() async {
    if (isMuted.value) {
      return;
    }
    await _stopTick();
    final player = AudioPlayer();
    _tickPlayer = player;
    await player.setReleaseMode(ReleaseMode.loop);
    await player.play(AssetSource('sounds/tic_tac_2.mp3'));
  }

  /// Esplosione: ferma il tic-tac e fa partire il boom al suo posto.
  /// Inerte se muto (nessun suono residuo).
  Future<void> playExplosion() async {
    await _stopTick();
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
    await player.play(AssetSource('sounds/explosion.mp3'));
  }

  /// Stop netto del ticchettio (esplosione, abbandono, dispose).
  Future<void> stopTick() => _stopTick();

  /// Toggle del mute persistito: se si entra in muto il ticchettio si ferma
  /// subito. Il riavvio del loop (se una partita è in corso) è gestito dal
  /// controller di partita, che osserva [isMuted].
  Future<void> toggleSoundFx() async {
    isMuted.value = !isMuted.value;
    final preferences = Get.find<SharedPreferences>();
    await preferences.setBool(AppKeyStore.soundFxMuted, isMuted.value);
    if (isMuted.value) {
      await _stopTick();
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
