import 'package:flutter/material.dart';

import '../cell/tag_value_cell.dart';
import '../model/tag_value_model.dart';

class TagPanelWidget extends StatelessWidget {
  final double tagWidth;
  final double itemHeight;
  final Color panelColor;
  final Color tagColor;
  final Color valueColor;
  final EdgeInsetsGeometry padding;

  /// tag - value 显示形式，只针对单个有效
  final Axis axis;
  final List items;
  final TextAlign textAlign;
  final double fontSize;

  const TagPanelWidget(
    this.items, {
    super.key,
    this.tagWidth = 80,
    this.itemHeight = 15,
    this.panelColor = Colors.transparent,
    this.padding = const EdgeInsets.all(5),
    this.axis = Axis.horizontal,
    this.tagColor = const Color(0xff939baf),
    this.valueColor = const Color(0xff5d6478),
    this.textAlign = TextAlign.left,
    this.fontSize = 16,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: panelColor,
      padding: padding,
      child: Column(
        children: items.map((e) {
          if (e is TagValueModel) {
            e.axis ??= axis;
            e.tagColor ??= tagColor;
            e.valueColor ??= valueColor;
            e.tagColor2 ??= tagColor;
            e.valueColor2 ??= valueColor;
            return TagValueCell(
              data: e,
              tagWidth: tagWidth,
              miniHeight: itemHeight,
              padding: padding,
              textAlign: textAlign,
              fontSize: fontSize,
            );
          }
          if (e is Widget) return Container(padding: padding, child: e);
          return Container();
        }).toList(),
      ),
    );
  }
}
