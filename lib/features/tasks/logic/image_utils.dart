import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';

class ImageUtils {
  static Future<Size> getLocalImageSize(File imageFile) async {
    final completer = Completer<Size>();
    final img = Image.file(imageFile);

    img.image
        .resolve(const ImageConfiguration())
        .addListener(
          ImageStreamListener((info, _) {
            completer.complete(
              Size(info.image.width.toDouble(), info.image.height.toDouble()),
            );
          }),
        );

    return completer.future;
  }

  /// لحساب حجم صورة من URL
  static Future<Size> getNetworkImageSize(String url) async {
    final completer = Completer<Size>();
    final img = Image.network(url);

    img.image
        .resolve(const ImageConfiguration())
        .addListener(
          ImageStreamListener((info, _) {
            completer.complete(
              Size(info.image.width.toDouble(), info.image.height.toDouble()),
            );
          }),
        );

    return completer.future;
  }
}
