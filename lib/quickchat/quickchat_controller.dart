import 'dart:developer';

import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../models/messages_model.dart';

class QuickChatController extends GetxController {
  late BuildContext context;

  final RxList<ChatMessage> chatHistory = <ChatMessage>[].obs;

  late ScrollController scrollController;

  scrollToBottom() {
    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 500),
      curve: Curves.fastOutSlowIn,
    );
    log("IM here");
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

  @override
  void onInit() {
    scrollController = ScrollController(keepScrollOffset: true);
    super.onInit();
  }
}

Widget buildQuickChatMessage(String message, bool isUser, Function onTap, QuickChatController controller) {
  List<String> messageParts = message.split('```');
  List<Widget> messageWidgets = [];

  for (int i = 0; i < messageParts.length; i++) {
    String part = messageParts[i];
    if (i % 2 == 0) {
      messageWidgets.add(Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            part.trim(),
            overflow: TextOverflow.visible,
            style: TextStyle(
              color: isUser ? Colors.white : Colors.black,
            ),
          )));
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
                          BouncingWidget(
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
