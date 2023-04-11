import 'package:coastrial/base/base_binding.dart';
import 'package:coastrial/base/base_view.dart';
import 'package:coastrial/home/home_binding.dart';
import 'package:coastrial/home/home_controller.dart';
import 'package:coastrial/home/home_view.dart';
import 'package:coastrial/image/edit/edit_binding.dart';
import 'package:coastrial/image/edit/edit_view.dart';
import 'package:coastrial/image/generate/generate_binding.dart';
import 'package:coastrial/image/image/image_view.dart';
import 'package:get/get.dart';

import '../chat/chat_binding.dart';
import '../chat/chat_view.dart';
import '../image/generate/generate_view.dart';
import '../image/image/image_binding.dart';
import '../quickchat/quickchat_binding.dart';
import '../quickchat/quickchat_view.dart';

const String homeView = "/home";
const String chatView = "/chat";
const String baseView = "/";
const String quickChatView = "/quick";
const String imageView = "/images";
const String editImageView = "/edit";
const String generateView = "/generate";

List<GetPage> getRootPage() {
  List<GetPage> list = [];

  list.add(GetPage(
    name: homeView,
    page: () => HomeView(),
    transition: Transition.fadeIn,
    binding: HomeBinding(),
  ));

  list.add(GetPage(
    name: chatView,
    page: () => ChatView(),
    transition: Transition.fadeIn,
    binding: ChatBinding(),
  ));

  list.add(GetPage(
    name: baseView,
    page: () => BaseView(),
    transition: Transition.fadeIn,
    binding: BaseBinding(),
  ));
  list.add(GetPage(
    name: quickChatView,
    page: () => QuickChatView(),
    transition: Transition.fadeIn,
    binding: QuickChatBinding(),
  ));

  list.add(GetPage(
    name: editImageView,
    page: () => EditView(),
    transition: Transition.fadeIn,
    binding: EditBinding(),
  ));

  list.add(GetPage(
    name: imageView,
    page: () => ImageView(),
    transition: Transition.fadeIn,
    binding: ImageBinding(),
  ));

  list.add(GetPage(
    name: generateView,
    page: () => GenerateView(),
    transition: Transition.fadeIn,
    binding: GenerateBinding(),
  ));

  return list;
}

goToHomeView() {
  Get.toNamed(homeView);
}

goToChatView() {
  Get.toNamed(chatView);
}

goToBaseView() {
  Get.toNamed(baseView);
}

goToQuickChatView() {
  Get.toNamed(quickChatView);
}

goToEditImageView() {
  Get.toNamed(editImageView);
}

goToImageView() {
  Get.toNamed(imageView);
}

goToGenerateView() {
  Get.toNamed(generateView);
}