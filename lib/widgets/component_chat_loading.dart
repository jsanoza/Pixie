import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:rive/rive.dart';
import 'dart:html' as html;

class ComponentLoadingChat extends StatefulWidget {
  const ComponentLoadingChat({super.key});

  @override
  State<ComponentLoadingChat> createState() => _ComponentLoadingChatState();
}

class _ComponentLoadingChatState extends State<ComponentLoadingChat> {
  bool get isPlaying => _controller?.isActive ?? false;

  Artboard? _riveArtboard;
  StateMachineController? _controller;

  SMITrigger? triggerNext;
  SMITrigger? triggerBack;
  var asset = "chat.riv".obs;

  @override
  void initState() {
    super.initState();

    rootBundle.load("${asset.value}").then(
      (data) async {
        final file = RiveFile.import(data);
        final artboard = file.mainArtboard;
        var controller = StateMachineController.fromArtboard(artboard, 'State Machine 1');
        if (controller != null) {
          artboard.addController(controller);

          triggerNext = controller.findSMI('Trigger 2') as SMITrigger;
        }
        setState(() {
          _riveArtboard = artboard;
          triggerNext!.fire();
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: _riveArtboard == null
          ? const SizedBox()
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Rive(
                    fit: BoxFit.contain,
                    artboard: _riveArtboard!,
                  ),
                ),
              ],
            ),
    );
  }
}
