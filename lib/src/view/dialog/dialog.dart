import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../router/navigator_util.dart';
import '../typedef.dart';
import 'bottom_sheet_dialog.dart';
import 'customize_dialog.dart';

Future showCustomizeDialog(
  BuildContext context,
  Widget widget, {
  bool barrierDismissible = true,
  Future<bool> Function()? onWillPop,
}) {
  return showDialog(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (ctx) => PopScope(
        canPop: barrierDismissible,
        onPopInvoked: (value) {
          onWillPop?.call();
        },
        child: CustomizeDialog(
          barrierDismissible: barrierDismissible,
          child: widget,
        )),
  );
}

Future<int?> showBottomPopup<T>(
    BuildContext context, String title, List<T> items,
    {String? message,
    BuildCheckChild<T>? buildCheckChild,
    double? height,
    double? width,
    bool autoHeight = false}) async {
  if (autoHeight && height == null) {
    if (items.length < 5) {
      height = 40 + items.length * MediaQuery.of(context).size.height * 4 / 45;
    }
  }
  return await showCupertinoModalPopup<int>(
    context: context,
    builder: (ctx) => BottomSheetDialog(
      height: height ?? MediaQuery.of(context).size.height * 4 / 9,
      width: width,
      titleLeft: Container(),
      titleRight: CupertinoButton(
        padding: const EdgeInsets.all(10),
        onPressed: () => NavigatorUtil.pop(ctx),
        child: const Icon(Icons.clear, color: Colors.grey),
      ),
      title: Text(title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      children: items
          .map((item) => ListTile(
                title: buildCheckChild != null
                    ? buildCheckChild(ctx, item)
                    : Text('$item', style: const TextStyle(fontSize: 16)),
                onTap: () => Navigator.pop(ctx, items.indexOf(item)),
              ))
          .toList(),
    ),
  );
}
