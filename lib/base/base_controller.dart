import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:siri_wave/siri_wave.dart';

import '../home/home_controller.dart';

class BaseController extends GetxController {
  late BuildContext context;
  HomeController homeController = Get.put(HomeController());

  final waveController = SiriWaveController();
  final iconList = <IconData>[
    Icons.brightness_5,
    Icons.brightness_4,
    Icons.brightness_6,
    Icons.brightness_7,
  ];

  @override
  void onInit() {
    initStates();
    super.onInit();
  }

  initStates() {
    waveController.setAmplitude(1);
  }
}
