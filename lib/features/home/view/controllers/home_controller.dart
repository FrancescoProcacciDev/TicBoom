import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:ticboom/core/game/sound_fx_service.dart';
import 'package:ticboom/core/routing/app_route.dart';

/// Controller della home menu: navigazione delle CTA e stato audio.
/// Il mute è gestito da SoundFxService (unica fonte di verità, condivisa
/// con il toggle dell'header di partita).
class HomeController extends GetxController {
  /// Stato audio persistito, delegato a SoundFxService.
  RxBool get isMuted => Get.find<SoundFxService>().isMuted;

  Future<void> toggleSoundFx() => Get.find<SoundFxService>().toggleSoundFx();

  /// CTA principale: naviga alla configurazione della partita.
  void goPlay() => Get.find<GoRouter>().go(AppRoute.gameConfig.path);

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
