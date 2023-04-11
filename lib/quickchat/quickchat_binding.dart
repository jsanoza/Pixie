import 'package:get/get.dart';

import 'quickchat_controller.dart';

class QuickChatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<QuickChatController>(
      () => QuickChatController(),
    );
  }
}
