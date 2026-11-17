import 'package:get/get.dart';

import 'package:ticboom/features/home/view/controllers/home_controller.dart';

class HomeBindings implements Bindings {
  const HomeBindings();

  @override
  void dependencies() {
    if (!Get.isRegistered<HomeController>()) {
      Get.lazyPut<HomeController>(() => HomeController());
    }
  }
}
