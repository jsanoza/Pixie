import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<ui.Image> bytesToImage(Uint8List imgBytes) async {
  ui.Codec codec = await ui.instantiateImageCodec(imgBytes);
  ui.FrameInfo frame = await codec.getNextFrame();
  return frame.image;
}

class PlaygroundEraserCanvasPath {
  final List<Offset> drawPoints;

  PlaygroundEraserCanvasPath({
    required this.drawPoints,
  });
}

enum EditType {
  eraser,
  paint,
}

class ImageProcessor {
  static Future<Uint8List> getImageBytesAsset(String path) async {
    WidgetsFlutterBinding.ensureInitialized();
    final byteData = await rootBundle.load(path);
    final uint8List = Uint8List.view(byteData.buffer);
    return uint8List;
  }
}
