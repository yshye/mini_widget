import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../router/navigator_util.dart';
import '../../util/theme_util.dart';
import '../model/tag_value_model.dart';
import '../toast.dart';
import 'ink_cell.dart';

class TagValueCell extends StatelessWidget {
  final TagValueModel data;
  final Color? color;

  final double tagWidth;

  final double miniHeight;

  final double fontSize;
  final BuildContext? context;
  final EdgeInsetsGeometry padding;
  final TextAlign textAlign;
  final double paddingRight;

  const TagValueCell({
    super.key,
    this.context,
    required this.data,
    this.color,
    this.tagWidth = 70,
    this.miniHeight = 15,
    this.fontSize = 16,
    this.padding = const EdgeInsets.all(1),
    this.textAlign = TextAlign.left,
    this.paddingRight = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Padding(
        padding: padding,
        child: data.tag2 == null
            ? _buildOneLine(
                data.tag ?? '',
                data.value ?? '',
                tagHeight: data.tagHeight,
                tagColor: data.tagColor,
                valueColor: data.valueColor,
                clip: data.clip,
                clipTap: data.clipTap,
                inputType: data.inputType ?? TextInputType.text,
                child: data.child,
                valueMaxLines: data.maxLines,
                tagWidth: tagWidth,
                miniHeight: miniHeight,
                fontSize: fontSize,
                context: context,
                textAlign: textAlign,
                direction: data.axis ?? Axis.horizontal,
                paddingRight: paddingRight,
              )
            : Flex(
                direction: Axis.horizontal,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                      flex: 1,
                      child: _buildOneLine(
                        data.tag ?? '',
                        data.value ?? '',
                        tagColor: data.tagColor,
                        tagHeight: data.tagHeight,
                        valueColor: data.valueColor,
                        inputType: data.inputType ?? TextInputType.text,
                        valueMaxLines: data.maxLines,
                        tagWidth: tagWidth,
                        miniHeight: miniHeight,
                        fontSize: fontSize,
                        context: context,
                        direction: Axis.horizontal,
                        paddingRight: paddingRight,
                      )),
                  Expanded(
                      flex: 1,
                      child: _buildOneLine(
                        data.tag2 ?? '',
                        data.value2 ?? '',
                        tagColor: data.tagColor2,
                        valueColor: data.valueColor2,
                        inputType: data.inputType2 ?? TextInputType.text,
                        valueMaxLines: data.maxLines2,
                        tagWidth: tagWidth,
                        miniHeight: miniHeight,
                        clip: data.clip,
                        fontSize: fontSize,
                        context: context,
                        direction: Axis.horizontal,
                        paddingRight: paddingRight,
                      )),
                ],
              ),
      ),
      data.showLine ? const Divider() : Container(),
    ]);
  }

  _buildOneLine(
    String tag,
    String value, {
    Color? tagColor = Colors.grey,
    bool tagHeight = false,
    Color? valueColor,
    TextInputType inputType = TextInputType.text,
    bool clip = false,
    VoidCallback? clipTap,
    Widget? child,
    double tagWidth = 70,
    double miniHeight = 20,
    double? fontSize,
    int? valueMaxLines,
    required BuildContext context,
    TextAlign textAlign = TextAlign.left,
    Axis direction = Axis.horizontal,
    double paddingRight = 0.0,
  }) {
    bool flag = false;
    String url = '';
    IconData? iconData;
    if (value.isNotEmpty) {
      if (clip) iconData = Icons.content_copy;
      if (inputType == TextInputType.phone) {
        flag = true;
        url = 'tel:$value';
        iconData = Icons.phone;
      } else if (inputType == TextInputType.emailAddress) {
        flag = true;
        url = 'mailto:$value';
        iconData = Icons.email;
      } else if (inputType == TextInputType.url) {
        flag = true;
        url = value;
        iconData = Icons.web;
      }
    }

    Widget valueWidget = Container(
      alignment: Alignment.centerLeft,
      child: child ??
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  value,
                  overflow: valueMaxLines == 1 ? TextOverflow.ellipsis : null,
                  maxLines: valueMaxLines,
                  textAlign: textAlign,
                  style: TextStyle(
                      height: 1.1,
                      fontSize: fontSize,
                      color: valueColor ??
                          (flag
                              ? ThemeUtil.getAccentColor(context)
                              : ThemeUtil.getBodyTextColor(context))),
                ),
              ),
              if (iconData != null) ...{
                Icon(iconData,
                    size: 12, color: ThemeUtil.getAccentColor(context))
              },
              SizedBox(width: paddingRight)
            ],
          ),
    );

    return InkCell(
      padding: const EdgeInsets.only(top: 5, bottom: 5, left: 5, right: 5),
      circular: 0,
      onTap: (flag || clip)
          ? () {
              if (flag) {
                NavigatorUtil.launchUrl(url);
              } else {
                if (clipTap != null) {
                  clipTap();
                } else {
                  if (value.isNotEmpty) {
                    Clipboard.setData(ClipboardData(text: value));
                    ToastUtil.show('已复制');
                  }
                }
              }
            }
          : null,
      child: Flex(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        direction: direction,
        children: <Widget>[
          SizedBox(height: direction == Axis.horizontal ? miniHeight : 0),
          Container(
            alignment: Alignment.topLeft,
            width: direction == Axis.horizontal ? tagWidth : double.infinity,
            child: Text(
              tag,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: TextStyle(
                  color: tagColor,
                  height: 1.1,
                  fontSize: fontSize,
                  fontWeight: tagHeight ? FontWeight.bold : FontWeight.normal),
            ),
          ),
          direction == Axis.horizontal
              ? Expanded(child: valueWidget)
              : valueWidget,
        ],
      ),
    );
  }
}
