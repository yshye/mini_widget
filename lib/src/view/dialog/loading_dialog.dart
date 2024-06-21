import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingDialog extends StatelessWidget {
  const LoadingDialog({
    super.key,
    this.hintText = '正在处理...',
  });

  final String hintText;

  @override
  Widget build(BuildContext context) {
    return AnimatedPadding(
      padding: MediaQuery.of(context).viewInsets +
          const EdgeInsets.symmetric(horizontal: 40.0, vertical: 24.0),
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeInCubic,
      child: MediaQuery.removeViewInsets(
        removeLeft: true,
        removeTop: true,
        removeRight: true,
        removeBottom: true,
        context: context,
        child: Center(
          child: Material(
            color: Colors.transparent,
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
                            brightness: Brightness.dark)),
                    child: const CupertinoActivityIndicator(radius: 14.0),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    hintText,
                    style: const TextStyle(color: Colors.white),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

void showLoadingDialog(
  BuildContext context, {
  String hintText = '正在处理…',
  bool barrierDismissible = false,
  Future<bool> Function()? onWillPop,
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => WillPopScope(
      onWillPop: onWillPop ?? () => Future.value(barrierDismissible),
      child: LoadingDialog(hintText: hintText),
    ),
  );
}
