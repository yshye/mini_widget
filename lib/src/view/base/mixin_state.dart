import 'dart:async';

import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../router/navigator_util.dart';
import '../../util/string_util.dart';
import '../dialog/_.dart';

import '../toast.dart';
import '../../router/pop_param.dart';
import '../typedef.dart';

mixin StateMixin<T extends StatefulWidget> on State<T> {
  List<TextEditingController> textControllers = [];
  bool _isShowDialog = false;

  @override
  initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback(afterBuild);
  }

  /// 页面首次构建结束回调
  @protected
  void afterBuild(Duration timestamp) {}

  @override
  void dispose() {
    for (var controller in textControllers) {
      controller.dispose();
    }
    textControllers.clear();
    super.dispose();
  }

  void pop() => NavigatorUtil.pop(context);

  @protected
  void back({bool success = false, dynamic data}) =>
      NavigatorUtil.pop(context, success: success, data: data);

  @protected
  Future<PopParam> pushPage(Widget page) => NavigatorUtil.push(context, page);

  @protected
  Future<PopParam> pushRouter(
    String path, {
    bool replace = false,
    bool clearStack = false,
    TransitionType transition = TransitionType.inFromRight,
    Map<String, dynamic> params = const {},
  }) =>
      NavigatorUtil.pushRouter(
        context,
        path,
        replace: replace,
        clearStack: clearStack,
        transition: transition,
        params: params,
      );

  /// 显示自定义对话框
  // Future showCustomDialog(Widget dialog, {bool barrierDismissible = true}) =>
  //     showCustomizeDialog(context, dialog,
  //         barrierDismissible: barrierDismissible);

  void showProgress([String hintText = '正在处理...']) {
    /// 避免重复弹出
    if (mounted && !_isShowDialog) {
      _isShowDialog = true;
      showLoadingDialog(context, hintText: hintText, onWillPop: () async {
        _isShowDialog = false;
        return Future.value(true);
      });
    }
  }

  void closeProgress() {
    if (mounted && _isShowDialog) {
      _isShowDialog = false;
      NavigatorUtil.pop(context);
    }
  }

  void showToast(String string, {TextStyle? textStyle}) =>
      ToastUtil.show(string, textStyle: textStyle);

  void showError(String error) => ToastUtil.showError(error);

  bottomSheetListMenu<M>(String title, List<M> item,
      {required ValueChanged<int?> voidItemCallback,
      BuildCheckChild<M>? buildCheckChild}) {
    showBottomPopup(context, title, item, buildCheckChild: buildCheckChild)
        .then(voidItemCallback);
  }

  void massageDialog(String content,
          {String? title,
          String? colorContent,
          String buttonText = '知道了',
          VoidCallback? onPressed,
          bool left = false}) =>
      showMassageDialog(
        context,
        content,
        title: title,
        colorContent: colorContent,
        buttonText: buttonText,
        onPressed: onPressed,
        left: left,
      );

  void confirmDialog(String content,
          {String? title,
          String? colorContent,
          String? cancelText,
          onCancelPressed,
          String? okText,
          VoidCallback? onOkPressed,
          bool left = false}) =>
      showConfirmDialog(
        context,
        content,
        title: title,
        colorContent: colorContent,
        cancelText: cancelText,
        onCancelPressed: onCancelPressed,
        okText: okText,
        onOkPressed: onOkPressed,
        left: left,
      );

  bool isEmpty(value) =>
      value == null ||
      (value is String && value.isEmpty) ||
      (value is List && value.isEmpty);

  bool isNotEmpty(value) => !isEmpty(value);

  bool isTrue(value) => value != null && value is bool && value;

  Widget buildLoadingWidget() {
    return Center(
      child: Theme(
        data: ThemeData(
            cupertinoOverrideTheme:
                const CupertinoThemeData(brightness: Brightness.light)),
        child: const CupertinoActivityIndicator(radius: 14.0),
      ),
    );
  }

  Widget buildBackButton({Function? onTap}) => IconButton(
        icon: Icon(MdiIcons.arrowLeft),
        color: Colors.blue,
        onPressed: () => onTap != null ? onTap() : Navigator.of(context).pop(),
      );

  double getMaxWidth() => MediaQuery.of(context).size.width;

  Widget buildButton({
    Function()? onPressed,
    Widget? child,
    String? text,
    Color? textColor,
    Color? color,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(color),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: DefaultTextStyle(
          style: TextStyle(color: textColor, fontSize: 16),
          child: child ?? Text(text ?? ''),
        ),
      ),
    );
  }
}
