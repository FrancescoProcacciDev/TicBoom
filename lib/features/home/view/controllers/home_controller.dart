import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ticboom/core/routing/app_route.dart';
import 'package:ticboom/core/utils/app_key_store.dart';

/// Controller della home menu: audio persistito (isMuted) e navigazione
/// delle CTA.
class HomeController extends GetxController {
  /// Stato audio persistito su SharedPreferences (AppKeyStore.soundFxMuted).
  final isMuted = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadSoundFxMuted();
  }

  Future<void> _loadSoundFxMuted() async {
    final preferences = Get.find<SharedPreferences>();
    isMuted.value = preferences.getBool(AppKeyStore.soundFxMuted) ?? false;
  }

  Future<void> toggleSoundFx() async {
    isMuted.value = !isMuted.value;
    final preferences = Get.find<SharedPreferences>();
    await preferences.setBool(AppKeyStore.soundFxMuted, isMuted.value);
  }

  /// CTA principale: naviga alla feature party rooms.
  void goPlay() => Get.find<GoRouter>().go(AppRoute.partyRooms.path);

  /// Card secondaria "Setup": naviga alle impostazioni app.
  void goSettings() => Get.find<GoRouter>().go(AppRoute.gameSettings.path);

  /// Card secondaria "Regole": naviga alla pagina "Come si gioca"
  /// (haptic ~10ms, come nel riferimento JS).
  void goRules() {
    HapticFeedback.lightImpact();
    Get.find<GoRouter>().go(AppRoute.howToPlayRules.path);
  }

  void goProfile() => Get.find<GoRouter>().go(AppRoute.profile.path);
}
