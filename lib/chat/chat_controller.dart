import 'dart:async';
import 'dart:developer';
import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:dart_openai/openai.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bouncing_widgets/flutter_bouncing_widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:record/record.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:siri_wave/siri_wave.dart';
import 'package:typewritertext/typewritertext.dart';

import '../models/messages_model.dart';
import '../services/api.dart';

class ChatController extends GetxController {
  final TextEditingController textEditingController = TextEditingController();
  final RxList<ChatMessage> chatHistory = <ChatMessage>[].obs;
  late ScrollController scrollController;
  late BuildContext context;
  var isTyping = false.obs;
  var isLoading = false.obs;
  var isAnimating = false.obs;
  int recordDuration = 0;
  Timer? timer;
  final audioRecorder = Record();
  StreamSubscription<RecordState>? recordSub;
  RecordState recordState = RecordState.stop;
  StreamSubscription<Amplitude>? amplitudeSub;
  final waveController = SiriWaveController();
  Amplitude? amplitude;
  var pathForAudio = "".obs;
  final player = AudioPlayer();
  var isStart = false.obs;
  var isTranscribing = false.obs;

  scrollToBottom() {
    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 500),
      curve: Curves.fastOutSlowIn,
    );
  }

  @override
  void onInit() {
    waveController.setAmplitude(1);
    scrollController = ScrollController(keepScrollOffset: true);

    recordSub = audioRecorder.onStateChanged().listen((recordState) {
      recordState = recordState;
      update();
    });
    amplitudeSub = audioRecorder.onAmplitudeChanged(const Duration(milliseconds: 300)).listen((amp) => amplitude = amp);

    initialGptMessage();
    super.onInit();
  }

  Future<void> start() async {
    await player.setAsset("soft.mp3");
    player.play();

    isTranscribing.value = true;
    try {
      if (await audioRecorder.hasPermission()) {
        final isSupported = await audioRecorder.isEncoderSupported(
          AudioEncoder.wav,
        );
        if (kDebugMode) {
          print('${AudioEncoder.aacLc.name} supported: $isSupported');
        }
        isStart.value = true;
        await audioRecorder.start();
        recordDuration = 0;
      }
      update();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> stop() async {
    timer?.cancel();
    recordDuration = 0;
    isStart.value = false;
    final path = await audioRecorder.stop();
    log(path.toString());

    if (path != null) {
      await player.setAsset("soft.mp3");
      player.play();
      pathForAudio.value = path.toString();
      micToChat(pathForAudio.value);
    }
    update();
  }

  Future<void> pause() async {
    timer?.cancel();
    isStart.value = false;
    await audioRecorder.pause();
    update();
  }

  @override
  void onClose() {
    recordSub?.cancel();
    amplitudeSub?.cancel();
    audioRecorder.dispose();
    super.onClose();
  }

  initialGptMessage() async {
    isLoading.value = true;
    textEditingController.text = "Your name is Pixie. Introduce yourself and ask me how you can help";
    sendMessage(true);
  }

  micToChat(String path) async {
    // OpenAICustomAPI.setToken(dotenv.get('OPEN_AI_API_KEY', fallback: "Url not found"));
    try {
      final transcription = await OpenAICustomAPI.transcribeAudio(path, 'whisper-1');
      print('Transcription: $transcription');
      Future.delayed(Duration(milliseconds: 1000), () {
        textEditingController.text = transcription.toString().trim();
        isTranscribing.value = false;
        sendMessage(false);
      }).then((value) {});
      log("check");
    } catch (e) {
      print('Error: ${e}');
    }
  }

  sendMessage(bool isInitialize) async {
    isTranscribing.value = false;
    final String messageText = textEditingController.text.trim();
    if (messageText.isNotEmpty) {
      var prompt = "";
      isTyping.value = true;
      if (chatHistory.isNotEmpty) {
        prompt = "${chatHistory.last.message}|||$messageText";
      } else {
        prompt = messageText;
      }
      try {
        if (!isInitialize) {
          chatHistory.add(ChatMessage(message: messageText, isUser: true));
          Future.delayed(Duration(milliseconds: 400), () {
            scrollToBottom();
          });
        } else {
          null;
        }
      } catch (e) {
        print(e);
      }

      textEditingController.clear();

      final messages = [
        {'role': 'user', 'content': prompt},
      ];
      try {
        await OpenAICustomAPI.completeChat("gpt-3.5-turbo", messages).then((value) {
          chatHistory.add(ChatMessage(message: value, isUser: false));
          Future.delayed(Duration(milliseconds: 400), () {
            scrollToBottom();
          });
        }).onError((error, stackTrace) {
          Get.back();
          Get.snackbar("Error", error.toString());
        });
      } catch (e) {
        print('Error: $e');
      }

      isLoading.value = false;
      isTyping.value = false;
    }
  }

  showPopUpMenuAtTap(BuildContext context, TapDownDetails details, String message) {
    double left = details.globalPosition.dx;
    double top = details.globalPosition.dy;

    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(left, top, left, 0),
      items: [
        PopupMenuItem(
          child: const Text('Copy'),
          value: '1',
          onTap: () {
            Clipboard.setData(ClipboardData(text: message.toString())).then((_) {
              Get.snackbar(
                "Success",
                "Message copied to clipboard!",
                colorText: Colors.white,
                backgroundColor: Color(0xff343541),
              );
            });
          },
        ),
      ],
      elevation: 8.0,
    );
  }
}

Widget buildChip(String label, Color color, TextEditingController textEditingController, Function onTap) {
  return GestureDetector(
    onTap: () {
      textEditingController.text = label;
      onTap();
    },
    child: Chip(
      labelPadding: EdgeInsets.all(2.0),
      label: Text(
        label,
        style: TextStyle(
          color: Colors.white,
        ),
        overflow: TextOverflow.ellipsis,
      ),
      backgroundColor: color,
      elevation: 6.0,
      shadowColor: Colors.grey[60],
      padding: EdgeInsets.all(8.0),
    ),
  );
}

Widget buildChatMessage(String message, bool isUser, Function onTap, ChatController controller) {
  List<String> messageParts = message.split('```');
  List<Widget> messageWidgets = [];

  for (int i = 0; i < messageParts.length; i++) {
    String part = messageParts[i];
    if (i % 2 == 0) {
      messageWidgets.add(
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: !isUser
              ? DefaultTextStyle(
                  style: const TextStyle(
                    fontFamily: 'Agne',
                  ),
                  child: AnimatedTextKit(
                    totalRepeatCount: 0,
                    isRepeatingAnimation: false,
                    animatedTexts: [
                      TypewriterAnimatedText(part.trim(), speed: Duration(milliseconds: 10)),
                    ],
                    onTap: () {
                      print("Tap Event");
                    },
                  ),
                )
              : Text(
                  part.trim(),
                  overflow: TextOverflow.visible,
                  style: TextStyle(
                    color: isUser ? Colors.white : Colors.black,
                  ),
                ),
        ),
      );
    } else {
      // Add code block
      messageWidgets.add(
        Container(
          margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(8.0),
          ),
          constraints: BoxConstraints(
            maxWidth: !ResponsiveWrapper.of(controller.context).isSmallerThan(DESKTOP) ? Get.width : Get.width / 2,
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: Color(0xff343541),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Icon(
                              Icons.code,
                              size: 14,
                              color: Colors.white,
                            ),
                          ),
                          CustomBounceWidget(
                            duration: Duration(milliseconds: 100),
                            scaleFactor: 1.5,
                            onPressed: () {
                              Clipboard.setData(ClipboardData(text: part.trim())).then((_) {
                                Get.snackbar(
                                  "Success",
                                  "Code copied to clipboard!",
                                  colorText: Colors.white,
                                  backgroundColor: Color(0xff343541),
                                );
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.copy,
                                    size: 14,
                                    color: Colors.white,
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Text(
                                    "Copy to clipboard",
                                    style: TextStyle(color: Colors.white, fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 8,
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      part.trim(),
                      style: TextStyle(
                        fontFamily: 'Courier',
                        fontSize: 12,
                        color: isUser ? Colors.black : Colors.white,
                      ),
                      overflow: TextOverflow.visible,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 40,
              ),
            ],
          ),
        ),
      );
    }
  }

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: messageWidgets,
  );
}
