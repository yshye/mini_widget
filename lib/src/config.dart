import 'package:flutter/cupertino.dart';

class MiniWidget {
  static String? appName;
  static Widget? appLogo;
  static String? authorName;
  static String? baiduIosAuthAK;

  static void config({
    String? appName,
    Widget? appLogo,
    String? authorName,
    String? baiduIosAuthAK,
  }) {
    MiniWidget.authorName = authorName;
    MiniWidget.appLogo = appLogo;
    MiniWidget.authorName = authorName;
    MiniWidget.baiduIosAuthAK = baiduIosAuthAK;
  }
}
