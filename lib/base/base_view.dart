import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:siri_wave/siri_wave.dart';

import '../helpers/colors.dart';
import '../home/home_controller.dart';
import '../home/home_view.dart';
import '../widgets/component_mic.dart';
import '../widgets/component_mic_loading.dart';
import '../widgets/component_timer.dart';
import 'base_controller.dart';

class BaseView extends GetView<BaseController> {
  @override
  Widget build(BuildContext context) {
    controller.context = context;

    return Scaffold(
      extendBody: true,
      body: HomeView(),
      floatingActionButton: Obx(() => controller.homeController.showLoadingMic.value == true
          ? Container(
              height: 50,
              width: 50,
              child: ComponentMicLoading(),
            )
          : controller.homeController.showPopup.value == false
              ? Container(
                  child: ShapeScreen(
                    onPlay: () async {
                      controller.homeController.showPopup.value = true;
                      controller.homeController.onRecordStart();
                    },
                    onStop: () async {},
                  ),
                )
              : SizedBox.shrink()),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Obx(
        () => controller.homeController.showPopup.value == true
            ? Container(
                height: 100,
                width: Get.width,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      kcPrimaryColor,
                      kcSecondaryColor,
                    ],
                  ),
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
                          ),
                        ),
                      ],
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: GestureDetector(
                        onTap: () {
                          controller.homeController.countdownController.reset();
                          controller.homeController.showPopup.value = false;
                          controller.homeController.showLoadingMic.value = true;
                          controller.homeController.onRecordStop();
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Container(
                            width: 50.0,
                            height: 50.0,
                            padding: EdgeInsets.all(2.0),
                            decoration: BoxDecoration(
                              color: kcPrimaryColor,
                              shape: BoxShape.circle,
                            ),
                            child: CustomPaint(
                              painter: CustomTimerPainter(
                                animation: controller.homeController.countdownController,
                                backgroundColor: Colors.white,
                                color: kcPrimaryColor,
                              ),
                              child: Icon(
                                Icons.stop,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
            : AnimatedBottomNavigationBar.builder(
                blurEffect: true,
                itemCount: controller.iconList.length,
                tabBuilder: (int index, bool isActive) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        controller.iconList[index],
                        size: 0,
                        color: Colors.transparent,
                      ),
                    ],
                  );
                },
                backgroundGradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    kcPrimaryColor,
                    kcOptionalColor,
                  ],
                ),
                activeIndex: 2,
                splashSpeedInMilliseconds: 300,
                notchSmoothness: NotchSmoothness.smoothEdge,
                gapLocation: GapLocation.center,
                leftCornerRadius: 0,
                rightCornerRadius: 0,
                onTap: (index) {},
                shadow: BoxShadow(
                  color: Colors.white,
                  offset: Offset(0, 1),
                  blurRadius: 12,
                  spreadRadius: 0.5,
                ),
              ),
      ),
    );
  }
}
