import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import '../helpers/functions.dart';
import '../image/edit/edit_controller.dart';

class ImageEditPaint extends StatelessWidget {
  final List<PlaygroundEraserCanvasPath>? canvasPaths;
  final ui.Image? image;

  const ImageEditPaint({
    Key? key,
     this.canvasPaths,
     this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      isComplex: true,
      willChange: true,
      foregroundPainter: EraserPainter(
        canvasPaths: canvasPaths!,
        image: image!,
      ),
    );
  }
}

class EraserPainter extends CustomPainter {
  final List<PlaygroundEraserCanvasPath> canvasPaths;
  final ui.Image image;

  EraserPainter({
    required this.canvasPaths,
    required this.image,
  });

  @override
  void paint(Canvas canvas, Size size) {
    canvas.saveLayer(Rect.fromLTWH(0, 0, size.width, size.height), Paint());
    canvas.drawImage(
      image,
      Offset.zero,
      Paint()..filterQuality = FilterQuality.high,
    );
    if (canvasPaths.isNotEmpty) {
      for (var canvasPath in canvasPaths) {
        if (canvasPath.drawPoints.isNotEmpty) {
          var eraserPaint = Paint()
            ..strokeWidth = 50
            ..style = PaintingStyle.stroke
            ..strokeCap = StrokeCap.round
            ..strokeJoin = StrokeJoin.round
            ..blendMode = BlendMode.clear;
          for (int i = 0; i < canvasPath.drawPoints.length; i++) {
            Offset drawPoint = canvasPath.drawPoints[i];
            if (canvasPath.drawPoints.length > 1) {
              if (i == 0) {
                canvas.drawLine(drawPoint, drawPoint, eraserPaint);
              } else {
                canvas.drawLine(canvasPath.drawPoints[i - 1], drawPoint, eraserPaint);
              }
            } else {
              canvas.drawLine(drawPoint, drawPoint, eraserPaint);
            }
          }
        }
      }
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant EraserPainter oldDelegate) => true;
}
