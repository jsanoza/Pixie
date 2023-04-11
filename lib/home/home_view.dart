import 'dart:developer';
import 'package:coastrial/chat/chat_view.dart';
import 'package:coastrial/route/routes.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rive/rive.dart' as riv;
import 'package:siri_wave/siri_wave.dart';
import 'home_controller.dart';

class HomeView extends GetView<HomeController> {
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
                colors: [Color.fromARGB(255, 25, 178, 238), Color.fromARGB(255, 21, 236, 229)],
              ),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      "Pixie",
                      style: GoogleFonts.monoton(fontSize: 50, color: Colors.white),
                    ),
                  ],
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: SizedBox(
                        child: DelayedDisplay(
                          delay: Duration(milliseconds: 1000),
                          child: Text(
                            "Where chat meets magic.",
                            style: GoogleFonts.karla(fontSize: 20, color: Colors.white),
                            overflow: TextOverflow.visible,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: 300,
                  child: Image.asset(
                    "assets/kcBot1.png",
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: SizedBox(
                        child: DelayedDisplay(
                          delay: Duration(milliseconds: 1500),
                          child: Text(
                            "Let's create something amazing.",
                            style: GoogleFonts.karla(fontSize: 20, color: Colors.white),
                            overflow: TextOverflow.visible,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: SizedBox(
                        child: DelayedDisplay(
                          delay: Duration(milliseconds: 2000),
                          child: Text(
                            "What do you have in mind?",
                            style: GoogleFonts.karla(fontSize: 20, color: Colors.white),
                            overflow: TextOverflow.visible,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                DelayedDisplay(
                  delay: Duration(milliseconds: 1000),
                  child: Container(
                    height: 150,
                    child: ScrollConfiguration(
                      behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 2,
                        itemBuilder: (itemBuilder, index) {
                          return GestureDetector(
                            onTap: () {
                              index == 1 ? goToImageView() : goToChatView();
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: GlassContainer(
                                  width: 130,
                                  blur: 4,
                                  color: Colors.white.withOpacity(0.1),
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Colors.white.withOpacity(0.2),
                                      Colors.blue.withOpacity(0.3),
                                    ],
                                  ),
                                  shadowStrength: 5,
                                  shape: BoxShape.circle,
                                  borderRadius: BorderRadius.circular(16),
                                  shadowColor: Colors.white.withOpacity(0.24),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: 50.0,
                                            height: 50.0,
                                            padding: EdgeInsets.all(2.0),
                                            decoration: BoxDecoration(
                                              color: Color.fromARGB(255, 21, 236, 229),
                                              shape: BoxShape.circle,
                                            ),
                                            child: Obx(
                                              () => CircleAvatar(
                                                backgroundColor: Colors.white,
                                                child: controller.riveArtboard == null
                                                    ? const SizedBox()
                                                    : index == 1
                                                        ? riv.Rive(
                                                            fit: BoxFit.contain,
                                                            artboard: controller.riveArtboard.value,
                                                          )
                                                        : riv.Rive(
                                                            fit: BoxFit.contain,
                                                            artboard: controller.riveArtboard2.value,
                                                          ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: SizedBox(
                                              child: DelayedDisplay(
                                                  delay: Duration(milliseconds: 2000),
                                                  child: index == 0
                                                      ? Text(
                                                          "Start new chat",
                                                          style: GoogleFonts.karla(fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold),
                                                          overflow: TextOverflow.visible,
                                                        )
                                                      : Text(
                                                          "Image processor",
                                                          style: GoogleFonts.karla(fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold),
                                                          overflow: TextOverflow.visible,
                                                        )),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 100,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
