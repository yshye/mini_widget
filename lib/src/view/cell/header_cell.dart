import 'package:flutter/material.dart';
import 'package:mini_extension/mini_extension.dart';

import '../../util/_.dart';
import '../model/_.dart';
import '../res/colors.dart';
import '../res/styles.dart';
import 'tag_value_cell.dart';
import 'tag_edit_cell.dart';

/// 抬头
Widget buildHeaderCell(
    {String? imagePath,
    Widget? ledging,
    String? title = '',
    String? title2 = '',
    TextStyle? textStyle,
    TextStyle? textStyle2,
    EdgeInsetsGeometry padding = const EdgeInsets.all(10),
    BuildContext? context,
    VoidCallback? onMoreTop,
    VoidCallback? onMoreLongPress}) {
  textStyle =
      textStyle ?? const TextStyle(fontWeight: FontWeight.bold, fontSize: 16);
  textStyle2 = textStyle2 ??
      (onMoreTop == null ? MiniStyle.textNormal : MiniStyle.textUrl);
  return Padding(
    padding: padding,
    child: Stack(
      alignment: AlignmentDirectional.bottomStart,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.only(left: 5, right: 5),
          width: 30,
          alignment: Alignment.centerLeft,
          child: ledging ??
              (imagePath != null
                  ? imagePath.isUrl
                      ? Image.network(imagePath, height: 20, width: 20)
                      : Image.asset(imagePath, height: 20, width: 20)
                  : Container()),
        ),
        Container(
            padding: EdgeInsets.only(
                left: (imagePath == null && ledging == null) ? 0 : 30),
            alignment: Alignment.centerLeft,
            child: Text(title ?? '',
                style: textStyle, overflow: TextOverflow.ellipsis)),
        Container(
          padding: const EdgeInsets.only(left: 5),
          alignment: Alignment.centerRight,
          child: Container(
            width: 200,
            alignment: Alignment.bottomRight,
            child: GestureDetector(
                onLongPress: onMoreLongPress,
                onTap: onMoreTop,
                child: Text(
                  title2 ?? '',
                  style: textStyle2,
                  overflow: TextOverflow.ellipsis,
                )),
          ),
        ),
      ],
    ),
  );
}

/// 列表带更多抬头
Widget buildListMoreCell(
    {String? title,
    int allSize = 0,
    int size = -1,
    VoidCallback? onMoreTop,
    VoidCallback? onLongPress,
    String moreText = '更多   '}) {
  return Padding(
    padding: const EdgeInsets.only(left: 18, top: 8, bottom: 5, right: 10),
    child: Row(children: <Widget>[
      Expanded(
        child: Text.rich(
          TextSpan(children: [
            TextSpan(text: '$title (', style: MiniStyle.textTitle),
            TextSpan(
                text: '$allSize',
                style: MiniStyle.textTitle.copyWith(color: MiniColor.deepPink)),
            const TextSpan(text: ')', style: MiniStyle.textTitle),
          ]),
        ),
      ),
      GestureDetector(
        onTap: onMoreTop,
        onLongPress: onLongPress,
        child: Text((allSize > size && size > -1) ? moreText : '',
            style: MiniStyle.textUrl),
      ),
    ]),
  );
}

/// 构建头部+卡片
Widget buildHeadCardCell(
    {String? headText,
    String? rightHeadText,
    TextStyle? headTextStyle,
    TextStyle? rightHeadTextStyle,
    BuildContext? context,
    Widget? headChild,
    Widget? child,
    List? values,
    Color color = Colors.white,
    double tagWidth = 80,
    double miniHeight = 30,
    double fontSize = 16,
    EdgeInsetsGeometry valuePadding = const EdgeInsets.all(1),
    EdgeInsetsGeometry childPadding = const EdgeInsets.all(5),
    double paddingRight = 0.0,
    VoidCallback? onMoreTop,
    VoidCallback? onMoreLongPress}) {
  values ??= [];
  return Container(
    margin: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
    padding: const EdgeInsets.all(8.0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8.0),
      color: Colors.white,
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        headChild ??
            buildHeaderCell(
                title: headText ?? '',
                title2: rightHeadText ?? '',
                onMoreLongPress: onMoreLongPress,
                textStyle: headTextStyle,
                textStyle2: rightHeadTextStyle,
                onMoreTop: onMoreTop),
        const Divider(indent: 10, endIndent: 10),
        Container(
          color: color,
          width: double.infinity,
          padding: childPadding,
          child: child ??
              Column(
                children: values.map((data) {
                  if (data is TagValueModel) {
                    return TagValueCell(
                        data: data,
                        fontSize: fontSize,
                        padding: valuePadding,
                        paddingRight: paddingRight,
                        tagWidth: tagWidth,
                        miniHeight: miniHeight,
                        context: context);
                  }
                  if (data is EditValueModel) {
                    data.tagWidth = tagWidth;
                    return EditCell(
                        data: data,
                        minHeight: miniHeight,
                        padding: valuePadding);
                  }
                  if (data is Widget) {
                    return data;
                  }
                  return Container();
                }).toList(),
              ),
        ),
      ],
    ),
  );
}
