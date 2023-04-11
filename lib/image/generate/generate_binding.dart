import 'package:get/get.dart';

import 'generate_controller.dart';

class GenerateBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GenerateController>(
      () => GenerateController(),
    );
  }
}
