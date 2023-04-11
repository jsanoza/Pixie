import 'dart:developer';

import 'package:flutter/material.dart';

class ShapeScreen extends StatefulWidget {
  final Function onPlay;
  final Function onStop;
  final double? height;
  final double? width;
  final double? iconSize;
  const ShapeScreen({Key? key, required this.onPlay, required this.onStop, this.height, this.width, this.iconSize}) : super(key: key);

  @override
  State<ShapeScreen> createState() => _ShapeScreenState();
}

class _ShapeScreenState extends State<ShapeScreen> with TickerProviderStateMixin {
  /// when playing, animation will be played
  bool playing = false;

  /// animation controller for the play pause button
  late AnimationController _playPauseAnimationController;

  /// animation & animation controller for the top-left and bottom-right bubbles
  late Animation<double> _topBottomAnimation;
  late AnimationController _topBottomAnimationController;

  /// animation & animation controller for the top-right and bottom-left bubbles
  late Animation<double> _leftRightAnimation;
  late AnimationController _leftRightAnimationController;

  var white = Colors.white;
  // var purple = Color(0xff3C64B9);
  var blue = Color(0xff50EF7);
  var pink = Color(0xff50ECE8);

  @override
  void initState() {
    super.initState();

    _playPauseAnimationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));

    _topBottomAnimationController = AnimationController(vsync: this, duration: const Duration(seconds: 1));

    _leftRightAnimationController = AnimationController(vsync: this, duration: const Duration(seconds: 1));

    _topBottomAnimation = CurvedAnimation(parent: _topBottomAnimationController, curve: Curves.decelerate).drive(Tween<double>(begin: 5, end: -5));
    _leftRightAnimation = CurvedAnimation(parent: _leftRightAnimationController, curve: Curves.easeInOut).drive(Tween<double>(begin: 5, end: -5));

    _leftRightAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _leftRightAnimationController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _leftRightAnimationController.forward();
      }
    });

    _topBottomAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _topBottomAnimationController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _topBottomAnimationController.forward();
      }
    });
  }

  @override
  void dispose() {
    _playPauseAnimationController.dispose();
    _topBottomAnimationController.dispose();
    _leftRightAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = 60;
    double height = 60;
    _topBottomAnimationController.forward();
    _leftRightAnimationController.forward();
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        // bottom right dark pink
        AnimatedBuilder(
          animation: _topBottomAnimation,
          builder: (context, _) {
            return Positioned(
              bottom: _topBottomAnimation.value,
              right: _topBottomAnimation.value,
              child: Container(
                width: widget.width ?? width * 0.9,
                height: widget.height ?? height * 0.9,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [pink, blue],
                    begin: Alignment.centerRight,
                    end: Alignment.centerLeft,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: pink.withOpacity(0.5),
                      blurRadius: 10,
                      spreadRadius: 5,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        // top left pink
        AnimatedBuilder(
            animation: _topBottomAnimation,
            builder: (context, _) {
              return Positioned(
                top: _topBottomAnimation.value,
                left: _topBottomAnimation.value,
                child: Container(
                  width: widget.width ?? width * 0.9,
                  height: widget.height ?? height * 0.9,
                  decoration: BoxDecoration(
                    color: pink.withOpacity(0.5),
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [pink, blue],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    boxShadow: playing
                        ? [
                            BoxShadow(
                              color: pink.withOpacity(0.5),
                              blurRadius: 10,
                              spreadRadius: 5,
                            ),
                          ]
                        : [],
                  ),
                ),
              );
            }), // light pink
        // bottom left blue
        AnimatedBuilder(
            animation: _leftRightAnimation,
            builder: (context, _) {
              return Positioned(
                bottom: _leftRightAnimation.value,
                left: _leftRightAnimation.value,
                child: Container(
                  width: widget.width ?? width * 0.9,
                  height: widget.height ?? height * 0.9,
                  decoration: BoxDecoration(
                    color: blue,
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [pink, blue],
                      begin: Alignment.centerRight,
                      end: Alignment.centerLeft,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: blue.withOpacity(0.5),
                        blurRadius: 15,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                ),
              );
            }),
        // top right dark blue
        AnimatedBuilder(
          animation: _leftRightAnimation,
          builder: (context, _) {
            return Positioned(
              top: _leftRightAnimation.value,
              right: _leftRightAnimation.value,
              child: Container(
                width: widget.width ?? width * 0.9,
                height: widget.height ?? height * 0.9,
                decoration: BoxDecoration(
                  color: blue,
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [pink, blue],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  boxShadow: playing
                      ? [
                          BoxShadow(
                            color: blue.withOpacity(0.5),
                            blurRadius: 10,
                            spreadRadius: 5,
                          ),
                        ]
                      : [],
                ),
              ),
            );
          },
        ),
        // play button
        GestureDetector(
          onTap: () {
            playing = !playing;

            if (playing) {
              widget.onPlay();
              _playPauseAnimationController.forward();
              _topBottomAnimationController.forward();
              Future.delayed(const Duration(milliseconds: 500), () {
                _leftRightAnimationController.forward();
              });
              setState(() {});
            } else {
              widget.onStop();
              _playPauseAnimationController.reverse();
              _topBottomAnimationController.stop();
              _leftRightAnimationController.stop();
              setState(() {});
            }
          },
          child: Container(
            width: widget.width ?? width,
            height: widget.width ?? height,
            padding: EdgeInsets.all(2.0),
            decoration: BoxDecoration(
              color: Color(0xff50EF7),
              shape: BoxShape.circle,
            ),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: !playing
                  ? Center(
                      child: Icon(
                      Icons.mic_off,
                      color: Colors.green,
                      size: widget.iconSize ?? widget.iconSize,
                    ))
                  : Center(
                      child: Icon(
                        Icons.mic_sharp,
                        color: Colors.green,
                        size: widget.iconSize ?? widget.iconSize,
                      ),
                    ),
            ),
          ),
        ),
      ],
    );
  }
}
