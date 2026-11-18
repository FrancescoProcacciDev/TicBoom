import 'package:get/get.dart';

import 'package:ticboom/features/splash/view/controllers/splash_controller.dart';

class SplashBindings implements Bindings {
  const SplashBindings();

  @override
  void dependencies() {
    if (!Get.isRegistered<SplashController>()) {
      Get.lazyPut<SplashController>(() => SplashController());
    }
  }
}
