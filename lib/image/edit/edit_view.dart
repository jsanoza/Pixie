import 'dart:convert';

import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bouncing_widgets/custom_bounce_widget.dart';
import 'package:get/get.dart';
import 'package:glass/glass.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../widgets/component_image_edit.dart';
import '../image/image_view.dart';
import 'edit_controller.dart';

class EditView extends GetView<EditController> {
  @override
  Widget build(BuildContext context) {
    controller.context = context;
    return Scaffold(
      backgroundColor: Colors.transparent,
      bottomNavigationBar: DelayedDisplay(
        slidingBeginOffset: const Offset(0.0, 0.35),
        delay: Duration(milliseconds: 1000),
        child: Container(
          height: 80,
          width: Get.width,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(14.0),
              topLeft: Radius.circular(14.0),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  BouncingWidget(
                    duration: Duration(milliseconds: 200),
                    scaleFactor: 1.5,
                    onPressed: () {
                      controller.undo();
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0, top: 0, right: 8),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xFF15ECE5),
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(8.0),
                            bottomLeft: Radius.circular(8.0),
                            topLeft: Radius.circular(8.0),
                            topRight: Radius.circular(8.0),
                          ),
                        ),
                        height: 40,
                        child: Center(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.undo_outlined,
                            color: Colors.white,
                          ),
                        )),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  CustomBounceWidget(
                    duration: Duration(milliseconds: 200),
                    scaleFactor: 1.5,
                    onPressed: () {
                      controller.isLoading.value = true;
                      controller.showProgressDialog();
                      controller.saveImage();
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0, top: 0, right: 8),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xFF15ECE5),
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(8.0),
                            bottomLeft: Radius.circular(8.0),
                            topLeft: Radius.circular(8.0),
                            topRight: Radius.circular(8.0),
                          ),
                        ),
                        height: 40,
                        child: Center(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.save,
                            color: Colors.white,
                          ),
                        )),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  CustomBounceWidget(
                    duration: Duration(milliseconds: 200),
                    scaleFactor: 1.5,
                    onPressed: () {
                      controller.undo();
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0, top: 0, right: 8),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xFF15ECE5),
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(8.0),
                            bottomLeft: Radius.circular(8.0),
                            topLeft: Radius.circular(8.0),
                            topRight: Radius.circular(8.0),
                          ),
                        ),
                        height: 40,
                        child: Center(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.share,
                            color: Colors.white,
                          ),
                        )),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
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
                                child: Image.asset("assets/kcBot2.png"),
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
                                    "Editor",
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
            ResponsiveRowColumn(
              columnCrossAxisAlignment: CrossAxisAlignment.center,
              columnPadding: EdgeInsets.all(8),
              rowPadding: EdgeInsets.all(8),
              rowCrossAxisAlignment: CrossAxisAlignment.start,
              layout: ResponsiveWrapper.of(context).isSmallerThan(DESKTOP) ? ResponsiveRowColumnType.COLUMN : ResponsiveRowColumnType.ROW,
              children: [
                ResponsiveRowColumnItem(
                  child: DelayedDisplay(
                    slidingBeginOffset: const Offset(0.0, 0.35),
                    delay: Duration(milliseconds: 1000),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 0.0),
                      child: Container(
                        height: 500,
                        width: !ResponsiveWrapper.of(context).isSmallerThan(TABLET) ? 300 : Get.width,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(14.0),
                            bottomLeft: Radius.circular(14.0),
                            topLeft: Radius.circular(14),
                            topRight: Radius.circular(14),
                          ),
                        ),
                        child: Column(children: [
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Controls",
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Generate more variations",
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              CustomBounceWidget(
                                duration: Duration(milliseconds: 200),
                                scaleFactor: 1.5,
                                onPressed: () {
                                  controller.generateVariations();
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8.0, top: 0, right: 8),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Color(0xFF15ECE5),
                                      borderRadius: BorderRadius.only(
                                        bottomRight: Radius.circular(8.0),
                                        bottomLeft: Radius.circular(8.0),
                                        topLeft: Radius.circular(8.0),
                                        topRight: Radius.circular(8.0),
                                      ),
                                    ),
                                    height: 40,
                                    child: Center(
                                        child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text("Generate Variations"),
                                    )),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 100,
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Custom prompt",
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8.0, top: 0, bottom: 16, right: 8),
                                  child: TextField(
                                    minLines: 7,
                                    maxLines: 7,
                                    onTap: () {},
                                    controller: controller.textEditingController,
                                    decoration: InputDecoration(
                                      hintText: 'Type prompt ...',
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
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomBounceWidget(
                                duration: Duration(milliseconds: 200),
                                scaleFactor: 1.5,
                                onPressed: () {
                                  controller.generateVariationsBaseOnPrompt();
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8.0, top: 0, right: 8),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Color(0xFF15ECE5),
                                      borderRadius: BorderRadius.only(
                                        bottomRight: Radius.circular(8.0),
                                        bottomLeft: Radius.circular(8.0),
                                        topLeft: Radius.circular(8.0),
                                        topRight: Radius.circular(8.0),
                                      ),
                                    ),
                                    height: 40,
                                    width: 100,
                                    child: Center(child: Text("Generate")),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ]),
                      ),
                    ),
                  ),
                ),
                ResponsiveRowColumnItem(
                  rowFit: FlexFit.tight,
                  child: Column(
                    children: [
                      DelayedDisplay(
                        slidingBeginOffset: const Offset(0.0, 0.35),
                        delay: Duration(milliseconds: 300),
                        child: Container(
                          height: !ResponsiveWrapper.of(context).isSmallerThan(TABLET) ? 700 : Get.width,
                          width: !ResponsiveWrapper.of(context).isSmallerThan(TABLET) ? Get.width : Get.width,
                          child: FittedBox(
                            child: RepaintBoundary(
                              key: controller.screenshotKey,
                              child: Obx(
                                () => Container(
                                  decoration: controller.removeBg.value == false
                                      ? BoxDecoration(
                                          image: DecorationImage(
                                            fit: BoxFit.contain,
                                            image: AssetImage("assets/kcTransparent.jpeg"),
                                          ),
                                        )
                                      : null,
                                  width: controller.image.width.toDouble(),
                                  height: controller.image.height.toDouble(),
                                  child: GestureDetector(
                                    onPanStart: (details) {
                                      controller.startEdit(details.localPosition);
                                    },
                                    onPanUpdate: (details) {
                                      controller.updateEdit(details.localPosition);
                                    },
                                    child: Container(
                                      color: Colors.transparent,
                                      child: Stack(
                                        children: [
                                          Positioned.fill(
                                            child: RepaintBoundary(
                                              key: controller.bgImageKey,
                                              child: ImageEditPaint(
                                                canvasPaths: [],
                                                image: controller.bgImage,
                                              ),
                                            ),
                                          ),
                                          Positioned.fill(
                                            child: GetBuilder<EditController>(
                                              builder: (editController) {
                                                return RepaintBoundary(
                                                  key: editController.imageEraserKey,
                                                  child: ImageEditPaint(
                                                    canvasPaths: editController.eraserPath,
                                                    image: editController.image,
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                ResponsiveRowColumnItem(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 0.0),
                    child: DelayedDisplay(
                      slidingBeginOffset: const Offset(0.0, 0.35),
                      delay: Duration(milliseconds: 1000),
                      child: Container(
                        height: 500,
                        // width: 300,

                        width: !ResponsiveWrapper.of(context).isSmallerThan(TABLET) ? 350 : Get.width,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(14.0),
                            bottomLeft: Radius.circular(14.0),
                            topLeft: Radius.circular(14),
                            topRight: Radius.circular(14),
                          ),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "History",
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                                  ),
                                ),
                              ],
                            ),
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Container(
                                      height: 500,
                                      width: Get.width,
                                      child: Obx(
                                        () => controller.historyList.isNotEmpty
                                            ? ScrollConfiguration(
                                                behavior: MyCustomScrollBehavior(),
                                                child: ListView.builder(
                                                  shrinkWrap: true,
                                                  itemCount: controller.historyList.length,
                                                  itemBuilder: (BuildContext context, int index) {
                                                    return Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        index == 0
                                                            ? Row(
                                                                children: [
                                                                  Padding(
                                                                    padding: const EdgeInsets.all(8.0),
                                                                    child: Text(
                                                                      "Image source",
                                                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                                                    ),
                                                                  ),
                                                                ],
                                                              )
                                                            : Row(
                                                                children: [
                                                                  Padding(
                                                                    padding: const EdgeInsets.all(8.0),
                                                                    child: Text(
                                                                      "Iteration ${index}",
                                                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                        Container(
                                                          height: 100,
                                                          width: Get.width,
                                                          child: ListView.builder(
                                                            shrinkWrap: true,
                                                            scrollDirection: Axis.horizontal,
                                                            physics: ClampingScrollPhysics(),
                                                            itemCount: controller.historyList[index].length,
                                                            itemBuilder: (BuildContext context, int innerIndex) {
                                                              return Padding(
                                                                padding: const EdgeInsets.all(8.0),
                                                                child: Column(
                                                                  children: [
                                                                    CustomBounceWidget(
                                                                      duration: Duration(milliseconds: 200),
                                                                      scaleFactor: 1.5,
                                                                      onPressed: () {
                                                                        controller.replaceImageFocus(controller.historyList[index][innerIndex]);
                                                                      },
                                                                      child: Container(
                                                                        height: 70,
                                                                        width: 70,
                                                                        child: Image.memory(
                                                                          base64.decode(controller.historyList[index][innerIndex]),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                ),
                                              )
                                            : SizedBox.shrink(),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
