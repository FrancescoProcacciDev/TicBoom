import 'package:get/get.dart';

import 'package:ticboom/features/setup/view/controllers/setup_controller.dart';

class SetupBindings implements Bindings {
  const SetupBindings();

  @override
  void dependencies() {
    if (!Get.isRegistered<SetupController>()) {
      Get.lazyPut<SetupController>(() => SetupController());
    }
  }
}
