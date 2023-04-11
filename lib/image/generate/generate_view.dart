import 'dart:convert';
import 'dart:developer';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:coastrial/widgets/component_chat_loading.dart';
import 'package:coastrial/widgets/component_mic_loading.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:glass/glass.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'dart:convert';
import '../image/image_view.dart';
import 'generate_controller.dart';
import 'package:image_network/image_network.dart';

class GenerateView extends GetView<GenerateController> {
  @override
  Widget build(BuildContext context) {
    controller.context = context;
    return Scaffold(
      body: Stack(
        children: [
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
                                  child: Image.asset("assets/kcBot6.png"),
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
                                      "Generate",
                                      style: TextStyle(
                                        fontSize: 20,
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
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 32.0, bottom: 0),
                    child: Text(
                      "Prompt: ",
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 32.0, bottom: 0, right: 32),
                      child: DefaultTextStyle(
                        style: const TextStyle(),
                        child: AnimatedTextKit(
                          totalRepeatCount: 0,
                          isRepeatingAnimation: false,
                          animatedTexts: [
                            TypewriterAnimatedText(controller.prompt.value, speed: Duration(milliseconds: 30)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Expanded(
                child: DelayedDisplay(
                  slidingBeginOffset: const Offset(0.0, 0.35),
                  delay: Duration(milliseconds: 1000),
                  child: Container(
                    child: ScrollConfiguration(
                      behavior: MyCustomScrollBehavior(),
                      child: ListView.builder(
                        cacheExtent: 9999,
                        scrollDirection: !ResponsiveWrapper.of(context).isSmallerThan(TABLET) ? Axis.horizontal : Axis.vertical,
                        itemBuilder: (context, index) {
                          controller.screenshotKey.add(GlobalKey());
                          return Stack(
                            fit: StackFit.loose,
                            children: [
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      controller.goToEdit(controller.convertedUrls[index]);
                                    },
                                    child: Container(
                                      height: !ResponsiveWrapper.of(context).isSmallerThan(TABLET) ? 700 : 300,
                                      width: !ResponsiveWrapper.of(context).isSmallerThan(TABLET) ? 700 : 300,
                                      child: Image.memory(
                                        base64.decode(controller.convertedUrls[index]),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                        itemCount: controller.convertedUrls.length,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
