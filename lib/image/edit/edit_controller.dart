import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:web_image_downloader/web_image_downloader.dart';
import 'dart:developer';
import 'dart:typed_data';
import 'package:image/image.dart' as IMG;
import 'package:cross_file/cross_file.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'dart:ui' as ui;

import '../../helpers/functions.dart';
import '../../helpers/loading_strings.dart';
import '../../services/api.dart';
import '../../widgets/component_mic_loading.dart';

class EditController extends GetxController with GetSingleTickerProviderStateMixin {
  late BuildContext context;
  var editType = EditType.eraser.obs;
  List<PlaygroundEraserCanvasPath> eraserPath = <PlaygroundEraserCanvasPath>[].obs;
  var paintPath = <PlaygroundEraserCanvasPath>[].obs;
  final TextEditingController textEditingController = TextEditingController();
  final GlobalKey bgImageKey = GlobalKey();
  final GlobalKey imageKey = GlobalKey();
  final GlobalKey bgImageEraserKey = GlobalKey();
  final GlobalKey imageEraserKey = GlobalKey();
  final GlobalKey screenshotKey = GlobalKey();
  List<List<String>> historyList = List<List<String>>.empty(growable: true).obs;
  late Uint8List? imageBytes;
  late Uint8List bgImageBytes;
  late ui.Image image;
  late ui.Image bgImage;
  late String path;
  var progresser = 0.0.obs;
  var isShot = false.obs;
  var removeBg = false.obs;
  Uint8List image2 = Uint8List.fromList([0]);
  var isLoading = false.obs;
  List<String> variationsUrl = <String>[].obs;
  var isReplaced = false.obs;
  var selectedItem = 'Initializing... Loading now.'.obs;

  showProgressDialog() {
    Timer.periodic(Duration(seconds: 3), (_) {
      selectedItem.value = loadingPrompts[math.Random().nextInt(loadingPrompts.length)];
    });

    Get.dialog(
      Obx(() {
        return Visibility(
          visible: isLoading.value,
          child: Dialog(
            backgroundColor: Colors.white,
            insetPadding: EdgeInsets.all(0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        color: Colors.white,
                      ),
                      child: ComponentMicLoading()),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 38.0, left: 10, right: 10, top: 16),
                  child: Container(
                    width: 300,
                    child: Obx(
                      () => Center(
                        child: Text(
                          selectedItem.value.isNotEmpty ? selectedItem.value : '',
                          style: TextStyle(fontSize: 14),
                          overflow: TextOverflow.visible,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
      barrierDismissible: false,
    );
  }

  @override
  void onInit() {
    // initKeys();
    super.onInit();
  }

  PlaygroundEraserCanvasPath _currentPath = PlaygroundEraserCanvasPath(drawPoints: []);

  void startEdit(Offset position) {
    _currentPath = PlaygroundEraserCanvasPath(drawPoints: [position]);
    if (editType.value == EditType.eraser) {
      eraserPath.add(_currentPath);
      update();
    } else {
      paintPath.add(_currentPath);
      update();
    }
  }

  void updateEdit(Offset position) {
    _currentPath.drawPoints.add(position);
    if (editType.value == EditType.eraser) {
      eraserPath[eraserPath.length - 1] = _currentPath;
      update();
    } else {
      paintPath[paintPath.length - 1] = _currentPath;
      update();
    }
  }

  void undo() {
    if (eraserPath.isEmpty && paintPath.isEmpty) return;
    if (editType.value == EditType.eraser) {
      eraserPath.removeLast();
      update();
    } else {
      paintPath.removeLast();
      update();
    }
  }

  replaceImageFocus(String url) async {
    isReplaced.value = true;
    ui.Image newImage = await bytesToImage(base64.decode(url));
    image.dispose();

    image = newImage;
    imageBytes = base64.decode(url);
    update();
  }

  saveImage() async {
    Future.delayed(const Duration(milliseconds: 2000), () async {
      await WebImageDownloader.downloadImage(imageEraserKey, 'image.png').then((value) {
        Future.delayed(const Duration(milliseconds: 500), () async {
          isLoading.value = false;
          Get.back();
        });
      });
    });
  }

  generateVariations() async {
    isReplaced.value = false;
    var pathNew = XFile.fromData(imageBytes!);
    var finalPath = pathNew.path;
    log("hey im here!");
    isLoading.value = true;
    variationsUrl.clear();
    showProgressDialog();
    await OpenAICustomAPI.generateImageVariation(finalPath, 4, "1024x1024").then((value) {
      variationsUrl.addAll(value);
      historyList.add(value);
      isLoading.value = false;
      replaceImageFocus(value.first.toString());
      Get.back();
    }).onError((error, stackTrace) {
      Get.back();
      Get.snackbar("Error", error.toString());
    });
  }

  generateVariationsBaseOnPrompt() async {
    if (textEditingController.text.isNotEmpty) {
      eraserPath.clear();
      isLoading.value = true;
      showProgressDialog();
      RenderRepaintBoundary boundary = imageEraserKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 1.0);
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);

      if (byteData != null) {
        Uint8List pngBytes = byteData.buffer.asUint8List();

        Future.delayed(const Duration(milliseconds: 500), () async {
          var mainImage = XFile.fromData(pngBytes);
          var mainpath = mainImage.path;

          var pathNew = XFile.fromData(imageBytes!);
          var finalPath = pathNew.path;
          log(finalPath.toString());
          log(mainpath.toString());

          await OpenAICustomAPI.editImage(
            imagePath: finalPath,
            maskPath: mainpath,
            prompt: textEditingController.text.trim(),
            n: 4,
            size: '1024x1024',
          ).then((value) {
            Get.back();
            historyList.add(value);
            replaceImageFocus(value.first.toString());
            textEditingController.clear();
          }).onError((error, stackTrace) {
            Get.back();
            Get.snackbar("Error", error.toString());
          });
        });
      }
    } else {
      Get.snackbar("Error", "Please provide prompt");
    }
  }
}
