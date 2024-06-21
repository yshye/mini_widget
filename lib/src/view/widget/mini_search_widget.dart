import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'mini_text_field.dart';

class MiniSearchWidget extends StatelessWidget {
  final TextEditingController controller;
  final double? width;
  final String hintText;
  final TextStyle? hintTextStyle;
  final Color? color;
  final bool autoFocus;
  final double height;
  final BorderRadiusGeometry? borderRadius;
  final bool showIcon;
  final int maxLength;
  final bool isIWork = false;

  const MiniSearchWidget({
    super.key,
    required this.controller,
    this.hintText = '快速搜索',
    this.hintTextStyle,
    this.width,
    this.height = 34,
    this.color,
    this.autoFocus = true,
    this.borderRadius,
    this.showIcon = true,
    this.maxLength = 20,
    // this.isIWork = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: height,
      width: width ??
          (isIWork ? getMaxWidth(context) - 215 : getMaxWidth(context) * 0.75),
      decoration: BoxDecoration(
        color: color ?? Theme.of(context).colorScheme.surface,
        borderRadius: borderRadius ?? BorderRadius.circular(4.0),
      ),
      child: MiniTextField(
        autoFocus: autoFocus,
        controller: controller,
        maxLength: maxLength,
        contentPadding: const EdgeInsets.only(
            top: 0.0, left: -8.0, right: -16.0, bottom: 12.0),
        icon: showIcon
            ? Icon(
                Icons.search,
                color: hintTextStyle?.color,
                size: 25,
              )
            : null,
        focusedBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
        hintText: hintText,
        hintTextStyle: hintTextStyle,
      ),
    );
  }

  double getMaxWidth(BuildContext context) {
    return (![TargetPlatform.iOS, TargetPlatform.android]
            .contains(defaultTargetPlatform))
        ? min(MediaQuery.of(context).size.width, 720)
        : MediaQuery.of(context).size.width;
  }
}
