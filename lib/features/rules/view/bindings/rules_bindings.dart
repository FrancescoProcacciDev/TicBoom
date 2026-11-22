import 'package:get/get.dart';

import 'package:ticboom/features/rules/view/controllers/rules_controller.dart';

class RulesBindings implements Bindings {
  const RulesBindings();

  @override
  void dependencies() {
    if (!Get.isRegistered<RulesController>()) {
      Get.lazyPut<RulesController>(() => RulesController());
    }
  }
}
