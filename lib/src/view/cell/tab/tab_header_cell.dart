import 'package:flutter/material.dart';
import 'model/tab_model.dart';

/// 表头
class TabHeaderCell extends StatelessWidget {
  final List<TabModel> data;
  final AlignmentGeometry? alignment;
  final Color? color;
  final TextStyle? textStyle;
  final double itemHeight;
  final bool action;
  final Widget? actionChild;
  final double actionWidth;
  final ScrollController? controller;

  const TabHeaderCell(this.data,
      {super.key,
      this.color,
      this.textStyle,
      this.itemHeight = 40,
      this.action = false,
      this.actionChild,
      this.actionWidth = 80,
      this.controller,
      this.alignment});

  @override
  Widget build(BuildContext context) {
    if (data.length < 6) {
      return buildTabHeader(context);
    }
    return buildLongTabHeader(context);
  }

  /// 表头
  Widget buildTabHeader(BuildContext context) {
    List<Widget> items = [];
    for (var element in data) {
      items.add(Expanded(
        flex: element.width == null ? (element.flex ?? 1) : 1,
        child: Container(
          padding: element.padding,
          width: element.width,
          alignment: element.alignment ?? alignment ?? Alignment.centerLeft,
          child: Text(
            element.label,
            style: element.textStyle ??
                textStyle ??
                const TextStyle(color: Colors.white, fontSize: 14),
          ),
        ),
      ));
    }

    if (action) {
      items.add(Container(
        width: actionWidth,
        alignment: alignment ?? Alignment.center,
        child: actionChild ??
            Text('操作',
                style: textStyle ??
                    const TextStyle(color: Colors.white, fontSize: 14)),
      ));
    }
    return Container(
      color: color ?? Colors.blue,
      height: itemHeight,
      alignment: Alignment.center,
      child: Flex(direction: Axis.horizontal, children: items),
    );
  }

  /// 长表头
  Widget buildLongTabHeader(BuildContext context) {
    List<Widget> items = [];
    for (var value in data) {
      items.add(Container(
        width: value.width,
        alignment: Alignment.center,
        child: Text(value.label,
            style: value.textStyle ??
                const TextStyle(color: Colors.white, fontSize: 14)),
      ));
    }
    if (action) {
      items.add(Container(
        width: actionWidth,
        alignment: Alignment.center,
        child: actionChild ??
            Text('操作',
                style: textStyle ??
                    const TextStyle(color: Colors.white, fontSize: 14)),
      ));
    }
    return SingleChildScrollView(
      controller: controller,
      scrollDirection: Axis.horizontal,
      child: Container(
        color: color ?? Colors.blue,
        height: itemHeight,
        child: Row(children: items),
      ),
    );
  }
}
