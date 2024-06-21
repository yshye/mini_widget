import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../util/string_util.dart';
// import '../cell/tag_edit_cell.dart';
import '../toast.dart';
import 'base_dialog.dart';

class InputDialog extends StatefulWidget {
  const InputDialog({
    super.key,
    required this.title,
    required this.onPressed,
    this.cancelCallback,
    this.content,
    this.hintText,
    this.message,
    this.inputType,
    this.maxLength,
    this.button1Text,
    this.button2Text,
    this.hasRequired = false,
    this.maxLines,
    this.titleTextStyle,
    this.minLength,
    this.width,
    this.maxNum,
  });

  final String title;
  final TextStyle? titleTextStyle;
  final Function(String)? cancelCallback;
  final Function(String) onPressed;
  final String? content;
  final String? hintText;
  final String? message;
  final int? maxLength;
  final TextInputType? inputType;
  final String? button1Text;
  final String? button2Text;
  final int? maxLines;
  final int? minLength;
  final double? width;
  final int? maxNum;

  /// 必填
  final bool hasRequired;

  @override
  State<StatefulWidget> createState() => _InputDialog();
}

class _InputDialog extends State<InputDialog> {
  late TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController(text: widget.content);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget messageWidget = StringUtil.isEmpty(widget.message)
        ? Container()
        : Container(
            margin: const EdgeInsets.only(left: 16, right: 16),
            child: Text(
              widget.message!,
              textAlign: TextAlign.left,
              style: const TextStyle(
                  height: 1.2, color: Colors.pinkAccent, fontSize: 14),
            ),
          );
    return BaseDialog(
      title: widget.title,
      titleStyle: widget.titleTextStyle,
      width: widget.width,
      onlyOneButton: false,
      button1Text: widget.button1Text,
      onClick1: () {
        if (widget.cancelCallback != null) {
          widget.cancelCallback!(_controller.text);
        } else {
          Navigator.pop(context);
        }
      },
      button2Text: widget.button2Text,
      onClick2: () {
        if (widget.hasRequired && _controller.text.trim().isEmpty) {
          ToastUtil.showError(widget.hintText ?? '输入${widget.title}');
          return;
        }
        if (widget.minLength != null) {
          if (_controller.text.trim().length < widget.minLength!) {
            ToastUtil.showError('${widget.title}不可少于${widget.minLength}个字!');
            return;
          }
        }
        Navigator.pop(context);
        widget.onPressed(_controller.text);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          messageWidget,
          Container(
            height: 34.0 * (widget.maxLines ?? 1),
            alignment: Alignment.center,
            margin: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0.0),
            decoration: BoxDecoration(
              color: const Color(0xFFF6F6F6),
              borderRadius: BorderRadius.circular(2.0),
            ),
            child: TextField(
              key: const Key('price_input'),
              autofocus: true,
              controller: _controller,
              maxLines: widget.maxLines ?? 1,
              maxLength: widget.maxLength,
              textInputAction: TextInputAction.done,
              keyboardType: widget.inputType ?? TextInputType.text,
              inputFormatters: _getInputFormatter(
                widget.inputType ?? TextInputType.text,
                widget.maxLength,
                maxNum: widget.maxNum,
              ),
              decoration: InputDecoration(
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                  border: InputBorder.none,
                  hintText: widget.hintText ?? '输入${widget.title}',
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  counterText: ''
                  //hintStyle: TextStyles.textGrayC14,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

void showInputDialog(
  BuildContext context,
  ValueChanged<String> okCallback, {
  ValueChanged<String>? cancelCallback,
  String? hintText,
  required String title,
  TextStyle? titleTextStyle,
  String? message,
  int? maxLength,
  String? okText,
  String? cancelText,
  bool required = true,
  String? content,
  TextInputType? inputType,
  int? maxLines,
  int? minLength,
  double? width,
  int? maxNum,
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => InputDialog(
      title: title,
      width: width,
      hintText: hintText,
      onPressed: okCallback,
      message: message,
      cancelCallback: cancelCallback,
      maxLength: maxLength,
      button1Text: cancelText,
      button2Text: okText,
      hasRequired: required,
      content: content,
      maxLines: maxLines,
      titleTextStyle: titleTextStyle,
      minLength: minLength,
      maxNum: maxNum,
      inputType: inputType,
    ),
  );
}

_getInputFormatter(TextInputType keyboardType, int? maxLength,
    {num? maxNum, int? placesLength, int? onlyNumValue}) {
  if (keyboardType == const TextInputType.numberWithOptions(decimal: true)) {
    return [
      _UsNumberTextInputFormatter(
        max: maxNum,
        onlyNumValue: onlyNumValue,
        placesLength: placesLength,
        decimal: keyboardType ==
            const TextInputType.numberWithOptions(decimal: true),
      )
    ];
  } else if (keyboardType == TextInputType.number) {
    return [
      _UsNumberTextInputFormatter(max: maxNum, decimal: false),
      FilteringTextInputFormatter.digitsOnly,
      LengthLimitingTextInputFormatter(maxLength),
    ];
  } else if (keyboardType == TextInputType.phone) {
    return [
      FilteringTextInputFormatter.digitsOnly,
      LengthLimitingTextInputFormatter(maxLength)
    ];
  }
  return null;
}

class _UsNumberTextInputFormatter extends TextInputFormatter {
  static const defaultDouble = 0.001;
  bool decimal;
  num? max;

  /// 小数位（[decimal]=true时生效）
  int? placesLength;

  /// 固定小数位,范围 null || [1-9]且[placesLength]=1时可用，
  int? onlyNumValue;

  _UsNumberTextInputFormatter(
      {this.max, this.decimal = true, this.placesLength, this.onlyNumValue})
      : assert(onlyNumValue == null || (onlyNumValue > 0 && onlyNumValue < 10));

  static double strToFloat(String str, [double defaultValue = defaultDouble]) {
    try {
      return double.parse(str);
    } catch (e) {
      return defaultValue;
    }
  }

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String value = newValue.text;
    int selectionIndex = newValue.selection.end;
    if (decimal) {
      if (value == '.') {
        value = '0.';
      } else if (value != '' &&
          value != defaultDouble.toString() &&
          strToFloat(value, defaultDouble) == defaultDouble) {
        value = oldValue.text;
        selectionIndex = oldValue.selection.end;
      } else {
        if (placesLength != null) {
          int index = value.indexOf('.');
          if (index > 0 && index + placesLength! < value.length) {
            if (placesLength == 1 && onlyNumValue != null) {
              value = "${value.substring(0, index + 1)}$onlyNumValue";
            } else {
              value = value.substring(0, index + placesLength! + 1);
            }
          }
        }
      }
    }
    if (max != null && value.isNotEmpty && num.parse(value) > max!) {
      value = '$max';
    }
    selectionIndex = value.length;
    return TextEditingValue(
      text: value,
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}
