import 'package:flutter/material.dart';
import '../../util/_.dart';

class HeightKeyWidget extends StatelessWidget {
  final String content;
  final String? heightKey;
  final Color heightColor;
  final TextStyle? textStyle;
  final int? makLines;

  const HeightKeyWidget({
    super.key,
    required this.content,
    this.heightKey,
    this.heightColor = Colors.pink,
    this.textStyle = const TextStyle(color: Colors.black),
    this.makLines,
  });

  @override
  Widget build(BuildContext context) {
    if (StringUtil.isEmpty(heightKey)) {
      return Text(
        content,
        maxLines: makLines,
        style: textStyle,
        overflow: TextOverflow.ellipsis,
      );
    }
    int startIndex = content.indexOf(heightKey!);
    int endIndex = -1;
    if (startIndex > -1) {
      endIndex = startIndex + heightKey!.length;
      return RichText(
        text: TextSpan(
          text: content.substring(0, startIndex),
          style: textStyle,
          children: [
            // 获取剩下的字符串，并让它变成灰色
            TextSpan(
                text: heightKey,
                style: textStyle?.copyWith(color: heightColor)),
            // 获取剩下的字符串，并让它变成灰色
            TextSpan(text: content.substring(endIndex), style: textStyle)
          ],
        ),
      );
    } else {
      return Text(
        content,
        maxLines: makLines,
        style: textStyle,
        overflow: TextOverflow.ellipsis,
      );
    }
  }
}
