import 'package:flutter/material.dart';
import 'tag_panel_widget.dart';

class GroupTagPanelWidget extends StatelessWidget {
  final String? groupTitle;
  final TextStyle? groupTitleStyle;
  final Color? groupTitleColor;
  final EdgeInsets? groupTitlePadding;
  final EdgeInsets? panelPadding;
  final List items;
  final double tagWidth;
  final Color tagColor;
  final Color valueColor;
  final Color panelColor;
  final TextAlign textAlign;
  final double fontSize;
  final Color? titlePrefixColor;
  final Widget? rightTitle;

  const GroupTagPanelWidget({
    super.key,
    this.groupTitle,
    this.groupTitleStyle,
    this.groupTitleColor,
    this.items = const [],
    this.groupTitlePadding,
    this.panelPadding,
    this.tagWidth = 100,
    this.tagColor = const Color(0xff939baf),
    this.valueColor = const Color(0xff5d6478),
    this.panelColor = Colors.white,
    this.textAlign = TextAlign.left,
    this.fontSize = 16,
    this.titlePrefixColor,
    this.rightTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            padding: groupTitlePadding ??
                const EdgeInsets.only(bottom: 5, left: 10, top: 5),
            width: double.infinity,
            color: groupTitleColor,
            child: Row(
              children: [
                if (titlePrefixColor != null) ...{
                  Container(
                    width: 3,
                    height: 20,
                    color: titlePrefixColor,
                    margin: const EdgeInsets.only(right: 5),
                  ),
                },
                Expanded(
                  child: Text(
                    groupTitle ?? '',
                    style: groupTitleStyle?.copyWith(fontSize: 18) ??
                        const TextStyle(
                          fontSize: 18,
                          color: Color(0xff9fa7b7),
                        ),
                  ),
                ),
                if (rightTitle != null) ...{
                  rightTitle!,
                },
              ],
            )),
        TagPanelWidget(
          items,
          tagWidth: tagWidth,
          tagColor: tagColor,
          valueColor: valueColor,
          panelColor: panelColor,
          padding: panelPadding ??
              const EdgeInsets.only(bottom: 5, left: 10, top: 5, right: 5),
          fontSize: fontSize,
          textAlign: textAlign,
        )
      ],
    );
  }
}
