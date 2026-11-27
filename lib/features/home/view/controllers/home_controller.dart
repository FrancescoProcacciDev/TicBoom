import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:ticboom/core/routing/app_route.dart';
import 'package:ticboom/core/utils/app_haptics.dart';

/// Controller della home menu: navigazione delle CTA.
class HomeController extends GetxController {
  /// CTA principale: naviga alla configurazione della partita.
  void goPlay() => Get.find<GoRouter>().go(AppRoute.gameConfig.path);

  /// Card secondaria "Regole": naviga alla pagina "Come si gioca"
  /// (haptic ~10ms, come nel riferimento JS).
  void goRules() {
    AppHaptics.lightImpact();
    Get.find<GoRouter>().go(AppRoute.howToPlayRules.path);
  }

  void goProfile() => Get.find<GoRouter>().go(AppRoute.profile.path);
}
