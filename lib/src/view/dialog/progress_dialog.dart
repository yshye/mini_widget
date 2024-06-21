import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../res/gaps.dart';

/// 加载中的弹框
class ProgressDialog extends Dialog {
  const ProgressDialog({
    super.key,
    this.hintText = '正在处理...',
  });

  final String hintText;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Center(
        child: Container(
          height: 120.0,
          width: 120.0,
          decoration: const ShapeDecoration(
              color: Color(0xFF3A3A3A),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8.0)))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Theme(
                data: ThemeData(
                  cupertinoOverrideTheme: const CupertinoThemeData(
                    brightness: Brightness.dark,
                  ),
                ),
                child: const CupertinoActivityIndicator(radius: 14.0),
              ),
              Gaps.vGap12,
              Text(
                hintText,
                style: const TextStyle(color: Colors.white),
              )
            ],
          ),
        ),
      ),
    );
  }
}
