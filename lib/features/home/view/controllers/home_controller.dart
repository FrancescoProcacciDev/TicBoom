import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ticboom/core/routing/app_route.dart';
import 'package:ticboom/core/utils/app_key_store.dart';

class HomeController extends GetxController {
  static const double _tiltDegrees = 3;

  final isMuted = false.obs;

  /// Inclinazione in gradi della mascotte durante il bounce.
  final mascotTilt = 0.0.obs;

  /// Scala della mascotte durante il bounce (squishy effect).
  final mascotScale = 1.0.obs;

  bool _isBouncing = false;

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

  /// Sequenza di bounce della mascotte: rotate -3° → +3° → reset.
  Future<void> mascotBounce() async {
    if (_isBouncing) {
      return;
    }
    _isBouncing = true;

    mascotTilt.value = -_tiltDegrees;
    mascotScale.value = 1.05;
    await Future<void>.delayed(const Duration(milliseconds: 150));

    mascotTilt.value = _tiltDegrees;
    await Future<void>.delayed(const Duration(milliseconds: 150));

    mascotTilt.value = 0;
    mascotScale.value = 1.0;
    _isBouncing = false;
  }

  void goSetup() => Get.find<GoRouter>().go(AppRoute.gameConfig.path);

  void goRules() => Get.find<GoRouter>().go(AppRoute.howToPlayRules.path);

  void goSettings() => Get.find<GoRouter>().go(AppRoute.gameSettings.path);

  void goProfile() => Get.find<GoRouter>().go(AppRoute.profile.path);
}
