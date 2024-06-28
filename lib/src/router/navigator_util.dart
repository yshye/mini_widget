import 'package:fluro/fluro.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart' as launcher;
import 'package:x5_webview/x5_sdk.dart';

import '../view/page/webview_page.dart';
import 'application.dart';
import 'pop_param.dart';

class NavigatorUtil {
  static Future<PopParam> pushRouter(
    BuildContext context,
    String path, {
    bool replace = false,
    bool clearStack = false,
    TransitionType transition = TransitionType.inFromBottom,
    Map<String, dynamic> params = const {},
  }) async {
    FocusScope.of(context).requestFocus(FocusNode());
    if (params.isNotEmpty) {
      StringBuffer str = StringBuffer();
      params.forEach((key, value) {
        str
          ..write("&")
          ..write(key)
          ..write('=')
          ..write(value is String ? Uri.encodeComponent(value) : value);
      });
      path = "$path?${str.toString().substring(1)}";
    }

    var result = await Application.router?.navigateTo(
      context,
      path,
      replace: replace,
      clearStack: clearStack,
      transition: transition,
      transitionDuration: const Duration(milliseconds: 300),
    );
    if (result != null && result is PopParam) return result;
    return PopParam(false, null);
  }

  static Future<PopParam> push(BuildContext context, Widget page) async {
    FocusScope.of(context).requestFocus(FocusNode());
    var result = await Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (ctx, animation, secondaryAnimation) => SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: const Offset(0.0, 0.0),
          ).animate(animation),
          child: page,
        ),
      ),
    );
    if (result != null && result is PopParam) return result;
    return PopParam(false, null);
  }

  static Future<dynamic> pushPage(BuildContext context, Widget page,
      {String? pageName}) async {
    FocusScope.of(context).requestFocus(FocusNode());
    return await Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (ctx, animation, secondaryAnimation) => SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: const Offset(0.0, 0.0),
          ).animate(animation),
          child: page,
        ),
      ),
    );
  }

  static void pop(BuildContext context, {bool? success, dynamic data}) {
    FocusScope.of(context).requestFocus(FocusNode());
    if (Navigator.canPop(context)) {
      if (success == null) {
        Navigator.pop(context);
      } else {
        Navigator.pop(context, PopParam(success, data));
      }
    }
  }

  static Future pushWeb(BuildContext context,
      {String? title,
      String? url,
      bool isHome = false,
      bool openWithBrowser = true}) async {
    if (url?.isEmpty ?? true) return;
    if (url!.endsWith(".apk")) {
      launchInBrowser(url, title: title);
    } else {
      if (defaultTargetPlatform == TargetPlatform.android) {
        if (openWithBrowser) {
          launchInBrowser(url, title: title);
          return;
        }
        await X5Sdk.openWebActivity(url, title: title, callback: (name, data) {
          debugPrint(name);
          debugPrint(data.toString());
        });
        return;
      }
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (ctx) => WebViewPage(title: title ?? '', url: url),
        ),
      );
    }
  }

  static Future<void> launchInBrowser(String url, {String? title}) async {
    Uri? uri = Uri.tryParse(url);
    if (uri == null) {
      return;
    }
    if (await launcher.canLaunchUrl(uri)) {
      launcher.launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }

  /// 拨打号码
  static void launchTel(String tel) =>
      launcher.launchUrl(Uri(path: "tel:$tel"));

  static void launchUrl(String path) => launcher.launchUrl(Uri(path: path));

  ///  发送邮件
  static void launchMail(String email) =>
      launcher.launchUrl(Uri(path: "mailto:$email"));
}
