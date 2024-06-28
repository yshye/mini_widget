import 'package:flutter/services.dart';

class UsNumberTextInputFormatter extends TextInputFormatter {
  static const defaultDouble = 0.001;
  bool decimal;
  num? max;

  /// 小数位（[decimal]=true时生效）
  int? placesLength;

  /// 固定小数位,范围 null || [1-9]且[placesLength]=1时可用，
  int? onlyNumValue;

  UsNumberTextInputFormatter(
      {this.max, this.decimal = true, this.placesLength, this.onlyNumValue})
      : assert(onlyNumValue == null || (onlyNumValue > 0 && onlyNumValue < 10));

  static double strToFloat(String str, [double defaultValue = defaultDouble]) {
    if (str.isEmpty) return 0;
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
    // int selectionIndex = newValue.selection.end;
    if (decimal) {
      if (value == '.') {
        value = '0.';
      } else if (value != '' &&
          value != defaultDouble.toString() &&
          strToFloat(value, defaultDouble) == defaultDouble) {
        value = oldValue.text;
        // selectionIndex = oldValue.selection.end;
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
    } else {
      if (strToFloat(value, defaultDouble) == defaultDouble) {
        value = oldValue.text;
        // selectionIndex = oldValue.selection.end;
      }
    }
    if (max != null && value.isNotEmpty && num.parse(value) > max!) {
      value = '$max';
    }
    // selectionIndex = value.length;
    return TextEditingValue(
      text: value,
      selection: TextSelection.collapsed(offset: value.length),
    );
  }
}

/// [placesLength] 小数位（[decimal]=true时生效）<br/>
/// [onlyNumValue] 固定小数位,范围 null || [1-9]且[placesLength]=1时可用
getInputFormatter(TextInputType keyboardType,
    {int? maxLength,
    num? maxNum,
    int? placesLength,
    int? onlyNumValue,
    String? allowSource}) {
  if (keyboardType == const TextInputType.numberWithOptions(decimal: true)) {
    return [
      UsNumberTextInputFormatter(
        max: maxNum,
        onlyNumValue: onlyNumValue,
        placesLength: placesLength,
        decimal: keyboardType ==
            const TextInputType.numberWithOptions(decimal: true),
      )
    ];
  } else if (keyboardType == TextInputType.number) {
    return [
      UsNumberTextInputFormatter(max: maxNum, decimal: false),
      FilteringTextInputFormatter.digitsOnly,
      LengthLimitingTextInputFormatter(maxLength),
    ];
  } else if (keyboardType == TextInputType.phone) {
    return [
      FilteringTextInputFormatter.digitsOnly,
      LengthLimitingTextInputFormatter(maxLength)
    ];
  } else if (allowSource != null) {
    return [
      FilteringTextInputFormatter.allow(RegExp(allowSource))
      // [\u4e00-\u9fa5a-zA-Z0-9、，。、：；,.:;]
    ];
  }
  return null;
}
