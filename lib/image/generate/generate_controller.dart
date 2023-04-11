import 'dart:convert';
import 'package:coastrial/route/routes.dart';
import 'package:coastrial/image/edit/edit_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../helpers/functions.dart';
import 'dart:ui' as ui;

class GenerateController extends GetxController with GetSingleTickerProviderStateMixin {
  late BuildContext context;
  final TextEditingController textEditingController = TextEditingController();
  List<String> convertedUrls = <String>[].obs;
  final List<GlobalKey> screenshotKey = <GlobalKey>[].obs;
  var prompt = "".obs;

  goToEdit(String url) async {
    Get.put(EditController());
    Get.find<EditController>().isReplaced.value = true;

    Get.put(EditController());
    ui.Image image = await bytesToImage(base64.decode(url));
    final bgImageBytes = await ImageProcessor.getImageBytesAsset('assets/kcTrans.png');
    ui.decodeImageFromList(bgImageBytes, (bgResult) async {
      Get.find<EditController>().image = image;
      Get.find<EditController>().imageBytes = base64.decode(url);
      Get.find<EditController>().bgImageBytes = bgImageBytes;
      Get.find<EditController>().bgImage = bgResult;
      Get.find<EditController>().historyList.add(convertedUrls);
    });
    goToEditImageView();
  }

  @override
  void onInit() {
    super.onInit();
  }
}
