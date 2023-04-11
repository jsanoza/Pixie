import 'dart:async';
import 'dart:convert';
import 'dart:developer' as dev;
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:coastrial/image/generate/generate_controller.dart';
import 'package:coastrial/route/routes.dart';
import 'package:dart_openai/openai.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../helpers/functions.dart';
import '../../helpers/loading_strings.dart';
import '../../services/api.dart';
import '../../widgets/component_mic_loading.dart';
import '../edit/edit_controller.dart';
import 'package:image/image.dart' as img;

class ImageController extends GetxController with GetSingleTickerProviderStateMixin {
  late BuildContext context;
  final TextEditingController textEditingController = TextEditingController();
  late CarouselSlider carouselSlider;
  var progress = 0.0.obs;
  int currentIndex = 0;
  var isGenerating = false.obs;
  var isLoading = false.obs;

  var selectedItem = 'Initializing... Loading now.'.obs;

  var samplePrompts = [
    "",
    "photo of an extremely cute alien fish swimming an alien habitable underwater planet, coral reefs, dream-like atmosphere, water, plants, peaceful, serenity, calm ocean, tansparent water, reefs, fish, coral, inner peace, awareness, silence, nature, evolution",
    "Axel Auriant, ultra detail, ultra realist, 8K, 3D, natural light, photorealism",
    "a cowboy gunslinger walking the neon lit streets and alleys of a futuristic tokyo covered in a dense fog",
    "a big large happy kawaii fluffy cutest baby Shiba-inu puppy wearing kimono enjoy shopping in a futuristic abandoned city, anime movie, IMAX, cinematic lighting, only in cinema, Makoto Shinkai",
  ];

  var imageList = [
    'assets/sampleImages/kc1.png',
    'assets/sampleImages/kc2.png',
    'assets/sampleImages/kc3.png',
    'assets/sampleImages/kc4.png',
    'assets/sampleImages/kc5.png',
  ];

  // initKeys() {
  //   OpenAICustomAPI.setToken(dotenv.get('OPEN_AI_API_KEY', fallback: "Url not found"));
  // }

  surpriseMe() async {
    isLoading.value = true;
    final messages = [
      {'role': 'user', 'content': "hyperrealistic random dall-e prompt"},
    ];

    await OpenAICustomAPI.completeChat("gpt-3.5-turbo", messages).then((value) {
      dev.log(value);
      textEditingController.text = value;
      createImage();
    }).onError((error, stackTrace) {
      isLoading.value = false;
      Get.snackbar("Error", error.toString());
    });
  }

  customImage() async {
    Get.put(EditController());
    Get.find<EditController>().isReplaced.value = true;
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );

    if (pickedFile != null) {
      pickedFile.readAsBytes().then((value) {

        var imager = img.decodeImage(value);
        var pngImage = img.encodePng(imager!);

        ui.decodeImageFromList(pngImage, (result) async {
          ui.Image image = await bytesToImage(pngImage);
          List<String> historyBytes = [];
          historyBytes.add(base64.encode(pngImage));
          final bgImageBytes = await ImageProcessor.getImageBytesAsset('assets/kcTrans.png');
          ui.decodeImageFromList(bgImageBytes, (bgResult) async {
            Get.find<EditController>().image = image;
            Get.find<EditController>().imageBytes = pngImage;
            Get.find<EditController>().bgImageBytes = bgImageBytes;
            Get.find<EditController>().bgImage = bgResult;
            Get.find<EditController>().historyList.add(historyBytes);
            goToEditImageView();
          });
        });
      });
    }
  }

  createImage() async {
    if (textEditingController.text.isNotEmpty) {
      Get.put(GenerateController());
      Get.find<GenerateController>().convertedUrls.clear();
      Get.find<GenerateController>().prompt.value = textEditingController.text;
      var prompt = textEditingController.text.trim();
      isGenerating.value = true;
      isLoading.value = true;
      progress.value = 0.0;
      textEditingController.clear();

      Timer.periodic(Duration(milliseconds: 100), (timer) {
        if (isLoading.value && progress.value < 10.0) {
          progress.value += 0.01;
        } else {
          timer.cancel();
        }
      });
      showProgressDialog(prompt);
      await OpenAICustomAPI.generateImage(prompt, 4, "1024x1024").then((value) {
        Get.find<GenerateController>().convertedUrls.addAll(value);
        goToGenerateView();
        isGenerating.value = false;
        isLoading.value = false;
      }).onError((error, stackTrace) {
        isGenerating.value = false;
        isLoading.value = false;
        Get.back();
        Get.snackbar("Error", error.toString());
      });
    } else {
      Get.snackbar("Error", "Please provide prompt");
    }
  }

  @override
  void onInit() {
    // initKeys();
    super.onInit();
  }

  showProgressDialog(String prompt) {
    Timer.periodic(Duration(seconds: 3), (_) {
      selectedItem.value = loadingPrompts[Random().nextInt(loadingPrompts.length)];
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
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: 300,
                      child: Wrap(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 0.0, bottom: 8),
                            child: Text(
                              "Prompt: \n",
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          Expanded(
                            child: DefaultTextStyle(
                              style: const TextStyle(
                                fontFamily: 'Agne',
                                fontSize: 14,
                              ),
                              child: AnimatedTextKit(
                                totalRepeatCount: 0,
                                isRepeatingAnimation: false,
                                animatedTexts: [
                                  TypewriterAnimatedText(prompt, speed: Duration(milliseconds: 30)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
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
}
