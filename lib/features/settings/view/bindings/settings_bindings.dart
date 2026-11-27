import 'package:get/get.dart';

import 'package:ticboom/features/settings/view/controllers/settings_controller.dart';

class SettingsBindings implements Bindings {
  const SettingsBindings();

  @override
  void dependencies() {
    if (!Get.isRegistered<SettingsController>()) {
      Get.lazyPut<SettingsController>(() => SettingsController());
    }
  }
}
