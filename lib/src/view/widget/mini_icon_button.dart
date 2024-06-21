import 'package:flutter/material.dart';

class MiniIconButton extends StatelessWidget {
  const MiniIconButton(
    this.text, {
    super.key,
    required this.onPressed,
    this.iconData,
    this.color,
    this.textColor,
  });

  final String text;
  final VoidCallback onPressed;
  final IconData? iconData;

  /// 按钮颜色，默认[textTheme.bodyText2.color]
  final Color? color;

  /// 字体颜色，默认
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.0),
        color: Colors.grey.withOpacity(0.3),
      ),
      child: TextButton(
        // padding: EdgeInsets.all(10.0),
        onPressed: onPressed,
        // padding: EdgeInsets.all(10.0),
        child: Stack(
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              child: Icon(iconData ?? Icons.apps,
                  color: textColor ?? Colors.white),
            ),
            Container(
                alignment: Alignment.center,
                child: Text(
                  text,
                  style: TextStyle(color: textColor ?? Colors.white),
                )),
          ],
        ),
      ),
    );
  }
}
