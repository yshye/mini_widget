import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mini_extension/mini_extension.dart';

import '../../util/_.dart';
import '../res/_.dart';
import '../widget/border_widget.dart';
import 'height_key_widget.dart';

class LineCell extends StatelessWidget {
  final String? title;
  final Color? color;
  final Widget? titleChild;
  final Widget? leading;
  final IconData? iconData;
  final Color? iconColor;
  final String? iconPath;
  final String? subLabel;
  final Widget? subLabelChild;
  final bool showNext;
  final TextStyle? titleStyle;
  final TextStyle? subLabelStyle;
  final bool? showLine;
  final double? height;
  final String? heightKey;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final EdgeInsetsGeometry? padding;

  const LineCell({
    super.key,
    this.title,
    this.titleChild,
    this.iconData,
    this.subLabel,
    this.showNext = true,
    this.titleStyle,
    this.subLabelStyle,
    this.showLine = true,
    this.onTap,
    this.onLongPress,
    this.iconPath,
    this.color,
    this.subLabelChild,
    this.leading,
    this.height = 55,
    this.heightKey,
    this.iconColor,
    this.padding = const EdgeInsets.symmetric(horizontal: 25),
  });

  @override
  Widget build(BuildContext context) {
    Widget iconWidget = Container();
    if (leading != null) {
      iconWidget = leading!;
    } else if (iconData != null) {
      iconWidget = Icon(iconData, color: iconColor, size: 18);
    } else if (iconPath != null && iconPath!.isNotEmpty) {
      iconWidget = Image.asset(iconPath!);
    }
    return Material(
      color: color ?? Theme.of(context).canvasColor,
      child: Ink(
        color: color ?? Theme.of(context).canvasColor,
        child: InkWell(
          onTap: onTap,
          onLongPress: onLongPress,
          child: Column(
            children: <Widget>[
              Container(
                height: height,
                padding: padding,
                child: Row(
                  children: <Widget>[
                    iconWidget,
                    const SizedBox(width: 15),
                    Expanded(
                      child: titleChild ??
                          HeightKeyWidget(
                            content: title ?? '',
                            textStyle: titleStyle ??
                                Theme.of(context).textTheme.bodyMedium,
                            heightKey: heightKey,
                            makLines: 1,
                          ),
                    ),
                    subLabelChild ??
                        Text(
                          subLabel ?? '',
                          style: subLabelStyle ??
                              Theme.of(context).textTheme.bodyMedium,
                        ),
                    showNext
                        ? const Icon(Icons.navigate_next,
                            color: Color(0xff8c95ac))
                        : Container()
                  ],
                ),
              ),
              Container(
                height: showLine == true ? 0.5 : 0.0,
                color: Theme.of(context).dividerColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget buildLineCell(
    {required String title,
    Widget? titleChild,
    Widget? subTitle,
    Icon? icon,
    String? svgName,
    String? iconName,
    String? numString,
    bool showNext = true,
    Color color = Colors.white,
    Color titleColor = Colors.black,
    bool showLine = false,
    VoidCallback? onPressed}) {
  Widget iconWidget = icon ??
      (svgName != null
          ? SvgPicture.asset(
              svgName,
              width: 24,
              height: 24,
            )
          : (iconName != null ? Image.asset(iconName) : Container()));

  return Material(
    color: color,
    child: Ink(
      color: color,
      child: InkWell(
        onTap: onPressed,
        child: Column(
          children: <Widget>[
            Container(
              height: 60,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: <Widget>[
                  iconWidget,
                  const SizedBox(width: 11),
                  Expanded(
                    child: titleChild ??
                        Text(
                          title,
                          style: TextStyle(fontSize: 18, color: titleColor),
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                        ),
                  ),
                  if (subTitle != null) ...{
                    subTitle,
                  } else if (numString != null) ...{
                    Text(
                      numString,
                      style: const TextStyle(fontSize: 16),
                    ),
                  },
                  if (showNext) ...{
                    Icon(
                      MdiIcons.chevronRight,
                      color: Colors.grey[600],
                    ),
                  },
                ],
              ),
            ),
            Container(
              height: showLine == true ? 1 : 0.0,
              color: MiniColor.lightGray,
              margin: const EdgeInsets.only(left: 60),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget buildErrorLineCell(
    {required String errorText,
    IconData errorIcon = Icons.error,
    Color errorColor = Colors.red,
    double height = 40,
    Color backgroundColor = Colors.white}) {
  return Container(
    height: height,
    color: backgroundColor,
    alignment: Alignment.center,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(errorIcon, color: errorColor),
        const SizedBox(width: 5),
        Text(errorText, style: TextStyle(color: errorColor))
      ],
    ),
  );
}

/// Icon + Text 横向显示
Widget buildIconLineCell({
  required Icon icon,
  required String label,
  Color? labelColor,
  Color? valueColor,
  VoidCallback? voidCallback,
}) {
  return Ink(
    child: InkWell(
      onTap: voidCallback,
      child: Container(
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            icon,
            const SizedBox(width: 10),
            Text(
              label,
              style: TextStyle(color: valueColor ?? MiniColor.black),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    ),
  );
}

Widget build2LineCell({
  required String label,
  required String value,
  Color labelColor = MiniColor.black,
  String? smallLabel,
  Color smallColor = MiniColor.black,
  Color valueColor = MiniColor.black,
  VoidCallback? voidCallback,
}) {
  return Ink(
    child: InkWell(
      onTap: voidCallback,
      child: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              label,
              style: TextStyle(color: labelColor, fontSize: 15),
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text(
                  value,
                  style: TextStyle(
                      color: valueColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  smallLabel ?? '',
                  style: TextStyle(color: smallColor, fontSize: 14),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

Widget buildTimeLineCell(
    {String dealTime = '',
    String dealMan = '',
    String headUrl = '',
    Widget? headDefault,
    String title = '',
    String? memo,
    String? circularLabel,
    Color circularColor = Colors.blue,
    bool isState = false,
    bool isEnd = false}) {
  return Material(
    child: Ink(
      child: InkWell(
        child: Container(
          color: Colors.white,
          child: Flex(
            direction: Axis.horizontal,
            children: <Widget>[
              Container(
                height: 100,
                width: 80,
                alignment: Alignment.center,
                padding: const EdgeInsets.only(top: 10),
                child: Column(
                  children: <Widget>[
                    Text(dealTime.getTimeStr(), style: MiniStyle.textTitle),
                    const SizedBox(height: 5),
                    Text(dealTime.getDateStr(), style: MiniStyle.textTag),
                  ],
                ),
              ),
              SizedBox(
                height: 100,
                width: 30,
                child: Stack(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.center,
                      child: Column(
                        children: <Widget>[
                          Container(
                              height: 15,
                              width: 2,
                              color:
                                  isState ? Colors.transparent : Colors.blue),
                          Container(
                              height: 85,
                              width: 2,
                              color: isEnd ? Colors.transparent : Colors.blue),
                        ],
                      ),
                    ),
                    Container(
                      width: 30,
                      height: 30,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 2.0, vertical: 2.0),
                      decoration: BoxDecoration(
                          border: Border.all(color: circularColor, width: 1.0),
                          color: circularColor,
                          borderRadius: BorderRadius.circular(15.0)),
                      margin: const EdgeInsets.only(top: 2),
                      alignment: Alignment.center,
                      child: UrlUtil.isUrl(headUrl)
                          ? Image.network(headUrl)
                          : Text(circularLabel ?? '',
                              style: MiniStyle.textTag
                                  .copyWith(color: Colors.white)),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  height: 100,
                  alignment: Alignment.topLeft,
                  padding: const EdgeInsets.only(left: 10, right: 5, top: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          BorderWidget(label: title, fontSize: 13)
                        ],
                      ),
                      const SizedBox(height: 5),
                      Text(dealMan,
                          style: const TextStyle(
                              fontSize: MiniDimen.fontSmall,
                              height: 1.1,
                              color: MiniColor.gray)),
                      Expanded(
                          child: Text(memo ?? '',
                              style: const TextStyle(
                                  fontSize: MiniDimen.fontSmall,
                                  height: 1.1,
                                  color: MiniColor.gray))),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    ),
  );
}
