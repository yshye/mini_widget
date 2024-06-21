import 'package:flutter/material.dart';
import 'model/tab_model.dart';

class TabRowCell extends StatelessWidget {
  final List<TabModel> data;
  final Color color;
  final TextStyle? textStyle;
  final bool action;
  final Widget? actionChild;
  final double actionWidth;
  final double? minHeight;
  final ScrollController? controller;
  final VoidCallback? onTap;
  final AlignmentGeometry? alignment;
  final int? maxLines;
  final Color shapeColor;

  const TabRowCell(
    this.data, {
    super.key,
    this.color = const Color(0xFFE3F2FD),
    this.textStyle,
    this.action = false,
    this.actionChild,
    this.actionWidth = 80,
    this.minHeight,
    this.controller,
    this.onTap,
    this.alignment,
    this.shapeColor = const Color(0xffD4D6DE),
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    if (data.length < 6) {
      return buildTabRow();
    }
    return buildLongTabRow();
  }

  /// 表行
  Widget buildTabRow() {
    List<Widget> items = [];
    for (var value in data) {
      items.add(Expanded(
        flex: value.width == null ? (value.flex ?? 1) : 1,
        child: Tooltip(
          message: value.showTooltip ? value.label : '',
          child: Material(
            color: Colors.transparent,
            shape: BorderDirectional(
              start: BorderSide(
                color: value.showLeft ? shapeColor : Colors.transparent,
                width: value.showLeft ? 1 : 0,
              ),
              top: BorderSide.none,
              end: BorderSide(
                color: value.showRight ? shapeColor : Colors.transparent,
                width: value.showRight ? 1 : 0,
              ),
              bottom: BorderSide(
                color: value.showBottom ? shapeColor : Colors.transparent,
                width: value.showBottom ? 1 : 0,
              ),
            ),
            child: Container(
              alignment: value.alignment ?? alignment ?? Alignment.centerLeft,
              height: minHeight,
              width: value.width,
              padding: value.padding,
              child: value.child ??
                  Text(
                    value.label,
                    style: value.textStyle ??
                        textStyle ??
                        const TextStyle(fontSize: 12, color: Colors.black),
                    maxLines: maxLines,
                    overflow: TextOverflow.ellipsis,
                  ),
            ),
          ),
        ),
      ));
    }
    if (action) {
      items.add(Container(
        width: actionWidth,
        height: minHeight,
        alignment: alignment ?? Alignment.center,
        child: Center(child: actionChild ?? Container()),
      ));
    }
    return Material(
      child: Ink(
        color: color,
        padding: EdgeInsets.zero,
        child: InkWell(
          onTap: onTap,
          child: Container(
            alignment: Alignment.centerLeft,
            child: Flex(direction: Axis.horizontal, children: items),
          ),
        ),
      ),
    );
  }

  /// 长表行
  Widget buildLongTabRow() {
    List<Widget> items = [];
    for (var value in data) {
      items.add(Container(
        width: value.width,
        padding: value.padding ??
            const EdgeInsets.only(top: 5, bottom: 5, right: 3, left: 3),
        alignment: Alignment.center,
        child: value.child ??
            Text(
              value.label,
              style: value.textStyle ??
                  textStyle ??
                  const TextStyle(fontSize: 12, color: Colors.black),
            ),
      ));
    }
    if (action) {
      items.add(Container(
        width: actionWidth,
        alignment: Alignment.center,
        child: Center(child: actionChild ?? Container()),
      ));
    }
    return Material(
      child: Ink(
        color: color,
        child: InkWell(
          onTap: onTap,
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            controller: controller,
            scrollDirection: Axis.horizontal,
            child: Container(
                alignment: Alignment.centerLeft, child: Row(children: items)),
          ),
        ),
      ),
    );
  }
}
