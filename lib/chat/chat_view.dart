import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:coast/coast.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
// import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:glass/glass.dart';
import 'package:siri_wave/siri_wave.dart';
import '../models/messages_model.dart';
import '../widgets/component_chat_loading.dart';
import '../widgets/component_loading.dart';
import '../widgets/component_mic.dart';
import 'chat_controller.dart';

class ChatView extends GetView<ChatController> {
  const ChatView({super.key});

  @override
  Widget build(BuildContext context) {
    controller.context = context;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromARGB(255, 25, 178, 238),
                  Color.fromARGB(255, 21, 236, 229),
                ],
              ),
            ),
          ),
          Column(
            children: [
              DelayedDisplay(
                slidingBeginOffset: const Offset(0.0, -0.35),
                delay: Duration(milliseconds: 200),
                child: Container(
                  height: 70,
                  width: Get.width,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(14.0),
                      bottomLeft: Radius.circular(14.0),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Get.back();
                              },
                              child: Icon(
                                Icons.arrow_back_ios,
                                color: Colors.black,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Container(
                                width: 50.0,
                                height: 50.0,
                                padding: EdgeInsets.all(2.0),
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 21, 236, 229),
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
                                      style: TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Online",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.green,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ).asGlass(),
              ),
              Expanded(
                child: Obx(() {
                  if (controller.chatHistory.length == 0) {
                    return Container(
                      width: Get.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 50,
                            width: 50,
                            child: const ComponentLoadingChat(),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return NotificationListener<ScrollNotification>(
                      onNotification: (scrollNotification) {
                        FocusScope.of(context).unfocus();
                        return true;
                      },
                      child: ListView.builder(
                        cacheExtent: 9999,
                        controller: controller.scrollController,
                        reverse: false,
                        itemCount: controller.chatHistory.length,
                        itemBuilder: (BuildContext context, int index) {
                          final ChatMessage message = controller.chatHistory[index];

                          return Column(
                            children: [
                              Row(
                                mainAxisAlignment: message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(width: 8),
                                  Flexible(
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                                      padding: const EdgeInsets.all(8.0),
                                      decoration: BoxDecoration(
                                        color: message.isUser ? Colors.blue : Colors.white.withOpacity(0.9),
                                        borderRadius: message.isUser
                                            ? BorderRadius.only(
                                                topLeft: Radius.circular(24.0),
                                                bottomRight: Radius.circular(14.0),
                                                bottomLeft: Radius.circular(24.0),
                                              )
                                            : BorderRadius.only(
                                                topRight: Radius.circular(24.0),
                                                bottomRight: Radius.circular(24.0),
                                                bottomLeft: Radius.circular(14.0),
                                              ),
                                      ),
                                      constraints: BoxConstraints(
                                        maxWidth: !ResponsiveWrapper.of(context).isSmallerThan(DESKTOP) ? Get.width / 2 : Get.width,
                                      ),
                                      child: GestureDetector(
                                        onDoubleTapDown: (details) => controller.showPopUpMenuAtTap(context, details, message.message),
                                        child: buildChatMessage(message.message, message.isUser, controller.scrollToBottom, controller),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                ],
                              ),
                              if (controller.isTyping.isTrue && index == controller.chatHistory.length - 1)
                                Container(
                                  width: Get.width,
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 18.0),
                                        child: Container(
                                          height: 50,
                                          width: 50,
                                          child: const ComponentLoading(),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              Obx(
                                () => controller.isTranscribing.value == true && index == controller.chatHistory.length - 1
                                    ? Container(
                                        width: Get.width,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(right: 18.0),
                                              child: Container(
                                                height: 50,
                                                width: 50,
                                                child: const ComponentLoading(),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : SizedBox.shrink(),
                              ),
                            ],
                          );
                        },
                      ),
                    );
                  }
                }),
              ),
              Container(
                child: Column(
                  children: [
                    DelayedDisplay(
                      slidingBeginOffset: const Offset(0.0, 0.35),
                      delay: Duration(milliseconds: 200),
                      child: Container(
                        width: Get.width,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(14.0),
                            topLeft: Radius.circular(14.0),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0, top: 16, bottom: 16),
                                child: TextField(
                                  maxLines: 10,
                                  minLines: 1,
                                  onTap: () {
                                    Future.delayed(Duration(milliseconds: 400), () {
                                      controller.scrollToBottom();
                                    });
                                  },
                                  controller: controller.textEditingController,
                                  decoration: InputDecoration(
                                    hintText: 'Type something ...',
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0xFF15ECE5),
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color.fromARGB(255, 21, 236, 229),
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Obx(
                              () => IconButton(
                                icon: controller.isAnimating.value == true ? Icon(Icons.mic) : Icon(Icons.mic_off),
                                onPressed: () {
                                  controller.isTranscribing.value = true;
                                  if (controller.isAnimating.value == true) {
                                    controller.stop();
                                    controller.isAnimating.value = false;
                                  } else {
                                    controller.isAnimating.value = true;
                                    controller.start();
                                  }
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: IconButton(
                                icon: Icon(Icons.send),
                                onPressed: () {
                                  // controller.isAnimating.value = true;
                                  controller.sendMessage(false);
                                  Future.delayed(Duration(milliseconds: 400), () {
                                    controller.scrollToBottom();
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ).asGlass(),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 1,
            child: Obx(() => controller.isAnimating.value == true
                ? Container(
                    height: 80,
                    width: Get.width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(14.0),
                        topLeft: Radius.circular(14.0),
                      ),
                    ),
                    child: Stack(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 100,
                              width: Get.width - 100,
                              child: SiriWave(
                                controller: controller.waveController,
                                // options: SiriWaveOptions(backgroundColor: Colors.black),
                                // style: SiriWaveStyle.ios_7,
                              ),
                            ),
                          ],
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: GestureDetector(
                            onTap: () async {
                              controller.stop();
                              controller.isAnimating.value = false;
                              Future.delayed(Duration(milliseconds: 2000), () {
                                controller.scrollToBottom();
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Container(
                                width: 50.0,
                                height: 50.0,
                                padding: EdgeInsets.all(2.0),
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 21, 236, 229),
                                  shape: BoxShape.circle,
                                ),
                                child: CircleAvatar(backgroundColor: Colors.white, child: Icon(Icons.stop, color: Colors.black)),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                : SizedBox.shrink()),
          )
        ],
      ),
    );
  }
}
