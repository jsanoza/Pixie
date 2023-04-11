import 'dart:developer';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:coastrial/helpers/colors.dart';
import 'package:coastrial/route/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:record/record.dart';
import 'package:rive/rive.dart' as riv;
import '../models/messages_model.dart';
import '../quickchat/quickchat_controller.dart';
import '../services/api.dart';

class HomeController extends GetxController with GetSingleTickerProviderStateMixin {
  late BuildContext context;
  var isPlaying = false.obs;
  var riveArtboard = riv.Artboard().obs;
  var riveArtboard2 = riv.Artboard().obs;
  riv.StateMachineController? _controller;
  riv.SMITrigger? triggerNext;
  riv.SMITrigger? triggerCard;
  var asset = "chat.riv".obs;
  var asset2 = "card.riv".obs;
  String? path = "";
  var textResponse = "".obs;
  var fullResponse = "".obs;
  var audioRecorder = Record();
  var showPopup = false.obs;
  var showLoadingMic = false.obs;
  final player = AudioPlayer();
  late AnimationController countdownController;

  void loadRive() async {
    var data = await rootBundle.load(asset.value);
    final file = riv.RiveFile.import(data);
    var artboard = file.mainArtboard;
    var controller = riv.StateMachineController.fromArtboard(artboard, 'State Machine 1');
    if (controller != null) {
      artboard.addController(controller);
      triggerCard = controller.findSMI('Trigger 2') as riv.SMITrigger;
      triggerCard!.fire();
    }
    riveArtboard2.value = artboard;
  }

  void loadRive2() async {
    var data = await rootBundle.load("${asset2.value}");
    final file = riv.RiveFile.import(data);
    var artboard = file.mainArtboard;
    var controller = riv.StateMachineController.fromArtboard(artboard, 'State Machine 1');
    if (controller != null) {
      artboard.addController(controller);
      triggerNext = controller.findSMI('Trigger 1') as riv.SMITrigger;
      triggerNext!.fire();
    }
    riveArtboard.value = artboard;
  }

  @override
  void onInit() {
    Get.put(QuickChatController());
    countdownController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 10),
    );

    initKeys();
    loadRive();
    loadRive2();
    super.onInit();
  }

  initKeys() async {
    OpenAICustomAPI.setAudioToken(dotenv.get('AUTH_KEY', fallback: "Url not found"));
    OpenAICustomAPI.setAudioID(dotenv.get('AUTH_USER_ID', fallback: "Url not found"));
    OpenAICustomAPI.setToken(dotenv.get('OPEN_AI_API_KEY', fallback: "Url not found"));

    if (await audioRecorder.hasPermission()) {
      await audioRecorder.isEncoderSupported(
        AudioEncoder.wav,
      );
    }
  }

  onRecordStart() async {
    audioRecorder = Record();
    await player.setAsset("soft.mp3");
    player.play();

    try {
      if (await audioRecorder.hasPermission()) {
        await audioRecorder.isEncoderSupported(
          AudioEncoder.wav,
        );
        await audioRecorder.start().then((value) {
          countdownController.forward();
          audioRecorder.onAmplitudeChanged(const Duration(milliseconds: 10000)).listen((event) {
            if (event.current < 1.0) {
              showPopup.value = false;
              showLoadingMic.value = true;
              onRecordStop();
              countdownController.reset();
            }
          });
        });
      }
    } catch (e) {
      log(e.toString());
    }
  }

  onRecordStop() async {
    Get.find<QuickChatController>().chatHistory.clear();
    path = await audioRecorder.stop();
    await player.setAsset("soft.mp3");
    player.play();

    if (path != null) {
      audioRecorder.dispose();
      await OpenAICustomAPI.transcribeAudio(path!, 'whisper-1').then((transcription) async {
        Get.find<QuickChatController>().chatHistory.add(ChatMessage(message: transcription, isUser: true));
        final messages = [
          {'role': 'user', 'content': transcription + ", the first 20 words should be the point of the response. After the 20 words new line for 5 times then provide details of your response."},
        ];
        try {
          await OpenAICustomAPI.completeChat("gpt-3.5-turbo", messages).then((value) async {
            textResponse.value = value.substring(0, value.toString().indexOf('.'));
            fullResponse.value = value.toString();

            Get.find<QuickChatController>().chatHistory.add(ChatMessage(message: fullResponse.value, isUser: false));
            await OpenAICustomAPI.convertAudio([textResponse.value]).then((value) async {
              player.stop();
              Future.delayed(Duration(milliseconds: 1500), () async {
                await OpenAICustomAPI.checkArticleStatus(value.toString()).then((value) async {
                  await player.setUrl(value);
                  player.play();

                  Get.dialog(
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(
                                Radius.circular(20),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Material(
                                color: Colors.white,
                                child: Column(
                                  children: [
                                    const SizedBox(height: 10),
                                    Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(right: 8.0),
                                          child: Container(
                                            width: 50.0,
                                            height: 50.0,
                                            padding: EdgeInsets.all(2.0),
                                            decoration: BoxDecoration(
                                              color: kcPrimaryColor,
                                              shape: BoxShape.circle,
                                            ),
                                            child: CircleAvatar(
                                              backgroundColor: Colors.white,
                                              child: Image.asset("assets/kcBot4.png"),
                                            ),
                                          ),
                                        ),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Pixie",
                                                  style: GoogleFonts.monoton(
                                                    fontSize: 20,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 15),
                                    Obx(
                                      () => Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: DefaultTextStyle(
                                              style: const TextStyle(
                                                fontSize: 14.0,
                                                fontFamily: 'Agne',
                                              ),
                                              child: AnimatedTextKit(
                                                totalRepeatCount: 0,
                                                isRepeatingAnimation: false,
                                                animatedTexts: [
                                                  TypewriterAnimatedText(textResponse.value.toString() + "."),
                                                ],
                                                onTap: () {},
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    GestureDetector(
                                      onTap: () {
                                        player.stop();
                                        showLoadingMic.value = false;
                                        Get.back();
                                        goToQuickChatView();
                                      },
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            "Read more",
                                            style: TextStyle(
                                              color: Color.fromARGB(255, 21, 236, 229),
                                            ),
                                          ),
                                          Icon(
                                            Icons.arrow_forward_ios_outlined,
                                            size: 16,
                                            color: kcPrimaryColor,
                                          )
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ).then((value) {
                    player.stop();
                    showLoadingMic.value = false;
                  });
                });
              });
            });
          });
        } catch (e) {
          log(e.toString());
        }
      }).onError((error, stackTrace) {
        Get.back();
        Get.snackbar("Error", error.toString());
      });
    }
  }
}
