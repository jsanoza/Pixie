import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:coast/coast.dart';
import 'package:coastrial/helpers/colors.dart';

import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:glass/glass.dart';
import 'package:siri_wave/siri_wave.dart';
import '../models/messages_model.dart';
import '../widgets/component_chat_loading.dart';
import '../widgets/component_loading.dart';
import '../widgets/component_mic.dart';
import 'quickchat_controller.dart';

class QuickChatView extends GetView<QuickChatController> {
  const QuickChatView({super.key});

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
                  kcBgColor,
                  kcPrimaryColor,
                ],
              ),
            ),
          ),
          Column(
            children: [
              DelayedDisplay(
                slidingBeginOffset: const Offset(0.0, -0.35),
                delay: Duration(milliseconds: 10),
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
                  return NotificationListener<ScrollNotification>(
                    onNotification: (scrollNotification) {
                      FocusScope.of(context).unfocus();
                      return true;
                    },
                    child: ListView.builder(
                      reverse: false,
                      controller: controller.scrollController,
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
                                      child: buildQuickChatMessage(message.message, message.isUser, controller.scrollToBottom, controller),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 8),
                              ],
                            ),
                          ],
                        );
                      },
                    ),
                  );
                }),
              ),
            ],
          ),
          Align(alignment: Alignment.bottomRight, child: Image.asset("assets/kcBot4.png", height: 150)),
        ],
      ),
    );
  }
}
