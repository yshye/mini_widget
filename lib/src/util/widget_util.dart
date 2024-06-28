import 'dart:async';

import 'package:flutter/material.dart';

class WidgetUtil {
  /// 获取图片宽高，加载错误情况返回 Rect.zero.（单位 px）
  static Future<Rect> getImageWH(
      {Image? image, String? url, String? localUrl, String? package}) {
    if (image == null && url == null && localUrl == null) {
      return Future.value(Rect.zero);
    }
    Completer<Rect> completer = Completer<Rect>();
    Image img = image ??
        ((url != null && url.isNotEmpty)
            ? Image.network(url)
            : Image.asset(localUrl!, package: package));
    img.image
        .resolve(const ImageConfiguration())
        .addListener(ImageStreamListener((ImageInfo info, bool _) {
          completer.complete(Rect.fromLTWH(
              0, 0, info.image.width.toDouble(), info.image.height.toDouble()));
        }, onError: (dynamic exception, StackTrace? stackTrace) {
          completer.complete(Rect.zero);
        }));
    return completer.future;
  }
}
