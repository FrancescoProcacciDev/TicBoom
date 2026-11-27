import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ticboom/core/game/bgm_service.dart';
import 'package:ticboom/core/game/sound_fx_service.dart';
import 'package:ticboom/core/utils/app_key_store.dart';

/// Controller della schermata impostazioni: tre switch (effetti sonori,
/// musica di sottofondo, vibrazione aptica) che persistono subito il loro
/// stato. Gli effetti sonori sono delegati a SoundFxService e la musica a
/// BgmService (fonti di verità condivise col gioco); l'aptica usa una
/// chiave dedicata.
class SettingsController extends GetxController {
  SettingsController() {
    final preferences = Get.find<SharedPreferences>();
    // Default attivo per l'aptica (chiave assente => on).
    hapticsOn.value = preferences.getBool(AppKeyStore.hapticsEnabled) ?? true;
  }

  /// Stato mute degli effetti sonori (ON nello switch = !muto).
  RxBool get soundMuted => Get.find<SoundFxService>().isMuted;

  /// Stato mute della musica di sottofondo (ON nello switch = !muto).
  RxBool get musicMuted => Get.find<BgmService>().isMuted;

  final hapticsOn = true.obs;

  /// Toggle effetti sonori: delega al mute del servizio.
  Future<void> toggleSound() => Get.find<SoundFxService>().toggleSoundFx();

  /// Toggle musica di sottofondo: delega al mute del servizio BGM.
  Future<void> toggleMusic() => Get.find<BgmService>().toggleSound();

  /// Toggle vibrazione aptica: persistito; le chiamate passano da
  /// [AppHaptics], che legge la chiave a ogni colpo.
  Future<void> toggleHaptics() async {
    hapticsOn.value = !hapticsOn.value;
    final preferences = Get.find<SharedPreferences>();
    await preferences.setBool(AppKeyStore.hapticsEnabled, hapticsOn.value);
  }
}
