import 'dart:developer';

import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:coastrial/route/routes.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bouncing_widgets/custom_bounce_widget.dart';
import 'package:get/get.dart';
import 'package:glass/glass.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../../helpers/colors.dart';
import '../../widgets/component_mic.dart';
import '../../widgets/component_mic_loading.dart';
import 'image_controller.dart';
import 'package:easy_scroll_animation/easy_scroll_animation.dart';

class ImageView extends GetView<ImageController> {
  @override
  Widget build(BuildContext context) {
    controller.context = context;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Container(
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
                                  color: kcButtonColor,
                                  shape: BoxShape.circle,
                                ),
                                child: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  child: Image.asset("assets/kcBot7.png"),
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "Image",
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ).asGlass(),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16, bottom: 16),
                  child: Container(
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
                                bottomLeft: Radius.circular(14.0),
                                bottomRight: Radius.circular(14.0),
                              ),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: ResponsiveWrapper.of(context).isSmallerThan(TABLET) ? MainAxisAlignment.spaceBetween : MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 12.0, top: 20),
                                      child: Text("Start with a detailed description"),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    CustomBounceWidget(
                                      duration: Duration(milliseconds: 200),
                                      scaleFactor: 1.5,
                                      onPressed: () {
                                        controller.surpriseMe();
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 8.0, top: 20, right: 8),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: kcButtonColor,
                                            borderRadius: BorderRadius.only(
                                              bottomRight: Radius.circular(8.0),
                                              bottomLeft: Radius.circular(8.0),
                                              topLeft: Radius.circular(8.0),
                                              topRight: Radius.circular(8.0),
                                            ),
                                          ),
                                          height: 40,
                                          width: 100,
                                          child: Center(
                                              child: Obx(() => controller.isLoading.value != true
                                                  ? Text("Surprise me")
                                                  : Container(
                                                      height: 40,
                                                      width: 40,
                                                      child: ComponentMicLoading(),
                                                    ))),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                ResponsiveWrapper.of(context).isSmallerThan(TABLET)
                                    ? SizedBox(
                                        height: 20,
                                        width: Get.width,
                                      )
                                    : SizedBox.shrink(),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 8.0, top: 16, bottom: 16),
                                        child: TextField(
                                          onTap: () {},
                                          controller: controller.textEditingController,
                                          decoration: InputDecoration(
                                            hintText: 'Type prompt ...',
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: kcButtonColor,
                                                width: 1.0,
                                              ),
                                              borderRadius: BorderRadius.circular(14),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: kcButtonColor,
                                                width: 1.0,
                                              ),
                                              borderRadius: BorderRadius.circular(14),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    CustomBounceWidget(
                                      duration: Duration(milliseconds: 200),
                                      scaleFactor: 1.5,
                                      onPressed: () {
                                        controller.createImage();
                                       
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 8.0, top: 0, right: 8),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: kcButtonColor,
                                            borderRadius: BorderRadius.only(
                                              bottomRight: Radius.circular(8.0),
                                              bottomLeft: Radius.circular(8.0),
                                              topLeft: Radius.circular(8.0),
                                              topRight: Radius.circular(8.0),
                                            ),
                                          ),
                                          height: 40,
                                          width: 100,
                                          child: Center(
                                              child: Obx(() => controller.isLoading.value != true
                                                  ? Text("Generate")
                                                  : Container(
                                                      height: 40,
                                                      width: 40,
                                                      child: ComponentMicLoading(),
                                                    ))),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Wrap(
                                  // mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 12.0, top: 20, bottom: 20),
                                      child: Text("Or,"),
                                    ),
                                    CustomBounceWidget(
                                      duration: Duration(milliseconds: 200),
                                      scaleFactor: 1.5,
                                      onPressed: () {
                                        controller.customImage();
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 8.0, top: 20, bottom: 20),
                                        child: Text(
                                          "upload an image",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            decoration: TextDecoration.underline,
                                            decorationStyle: TextDecorationStyle.wavy,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0, top: 20, bottom: 20),
                                      child: Text("to edit."),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ).asGlass(),
                        ),
                      ],
                    ),
                  ),
                ),
                DelayedDisplay(
                  slidingBeginOffset: const Offset(0.0, 0.35),
                  delay: Duration(milliseconds: 200),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 16.0,
                      right: 16,
                      bottom: 16,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(14.0),
                          topLeft: Radius.circular(14.0),
                          bottomLeft: Radius.circular(14.0),
                          bottomRight: Radius.circular(14.0),
                        ),
                      ),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "Latest creations",
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    height: 400,
                                    width: Get.width,
                                    child: ScrollConfiguration(
                                      behavior: MyCustomScrollBehavior(),
                                      child: ListView.builder(
                                        physics: BouncingScrollPhysics(),
                                        itemCount: controller.imageList.length,
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context, index) {
                                          return Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Stack(
                                              children: [
                                                Container(
                                                  height: 400,
                                                  width: 400,
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(14),
                                                  ),
                                                  child: Image.asset(
                                                    controller.imageList[index],
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                                Container(
                                                  width: 400,
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(14),
                                                  ),
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Text(
                                                      controller.samplePrompts[index].toString(),
                                                      style: TextStyle(color: Colors.white, fontSize: 16),
                                                    ),
                                                  ),
                                                ).asGlass()
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "More creations",
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    height: 400,
                                    width: Get.width,
                                    child: ScrollConfiguration(
                                      behavior: MyCustomScrollBehavior(),
                                      child: ListView.builder(
                                        reverse: true,
                                        physics: BouncingScrollPhysics(),
                                        itemCount: controller.imageList.length,
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context, index) {
                                          return Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Stack(
                                              children: [
                                                Container(
                                                  height: 400,
                                                  width: 400,
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(14),
                                                  ),
                                                  child: Image.asset(
                                                    controller.imageList[index],
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                                Container(
                                                  width: 400,
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(14),
                                                  ),
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Text(
                                                      controller.samplePrompts[index].toString(),
                                                      style: TextStyle(color: Colors.white, fontSize: 16),
                                                    ),
                                                  ),
                                                ).asGlass()
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
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
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}
