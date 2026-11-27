import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ticboom/core/game/bgm_service.dart';
import 'package:ticboom/core/game/sound_fx_service.dart';
import 'package:ticboom/core/utils/app_key_store.dart';

/// Controller della schermata impostazioni: switch effetti sonori e
/// vibrazione aptica più slider del volume musica, tutti con persistenza
/// immediata al tap. Gli effetti sonori sono delegati a SoundFxService e la
/// musica a BgmService (fonti di verità condivise col gioco); l'aptica usa
/// una chiave dedicata.
class SettingsController extends GetxController {
  SettingsController() {
    final preferences = Get.find<SharedPreferences>();
    // Default attivo per l'aptica (chiave assente => on).
    hapticsOn.value = preferences.getBool(AppKeyStore.hapticsEnabled) ?? true;
  }

  /// Stato mute degli effetti sonori (ON nello switch = !muto).
  RxBool get soundMuted => Get.find<SoundFxService>().isMuted;

  /// Volume della musica di sottofondo (0-100, 0 = disattivata).
  RxInt get musicVolume => Get.find<BgmService>().volume;

  /// Stato dello switch vibrazione aptica (persistito su hapticsEnabled).
  final hapticsOn = true.obs;

  /// Toggle effetti sonori: delega al mute del servizio.
  Future<void> toggleSound() => Get.find<SoundFxService>().toggleSoundFx();

  /// Imposta il volume della musica: delega al servizio BGM (persistito e
  /// applicato live al player).
  Future<void> setMusicVolume(int value) =>
      Get.find<BgmService>().setMusicVolume(value);

  /// Toggle vibrazione aptica: persistito; le chiamate passano da
  /// [AppHaptics], che legge la chiave a ogni colpo.
  Future<void> toggleHaptics() async {
    hapticsOn.value = !hapticsOn.value;
    final preferences = Get.find<SharedPreferences>();
    await preferences.setBool(AppKeyStore.hapticsEnabled, hapticsOn.value);
  }
}
