import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;

class BadgeWidget extends StatelessWidget {
  final Widget child;
  final int? count;
  final bool flag;
  final double fontSize;
  final double? positionTop;
  final double? positionRight;
  final double? positionLeft;
  final double? positionBottom;

  const BadgeWidget(
      {super.key,
      this.count = 0,
      this.flag = false,
      this.fontSize = 14,
      required this.child,
      this.positionTop,
      this.positionRight,
      this.positionLeft,
      this.positionBottom});

  @override
  Widget build(BuildContext context) {
    if (!flag && count == null) {
      return child;
    }
    return badges.Badge(
      position: badges.BadgePosition.custom(
        start: positionLeft,
        end: positionRight,
        top: positionTop,
        bottom: positionBottom,
      ),
      badgeContent: Text(
        flag ? '!' : (count! > 99 ? '99+' : '$count'),
        style: TextStyle(
          color: Colors.white,
          fontSize: fontSize,
        ),
      ),
      child: child,
    );
  }
}

/// 顶部提示组件
class BadgeTipWidget extends StatelessWidget {
  final int count;
  final bool flag;
  final double fontSize;

  const BadgeTipWidget(
      {super.key, this.count = 0, this.flag = false, this.fontSize = 14});

  @override
  Widget build(BuildContext context) {
    if (count < 1 && !flag) return Container();
    return Container(
      decoration: const BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.all(
          Radius.circular(18.0),
        ),
      ),
      padding: const EdgeInsets.only(left: 5, right: 5),
      child: Text(
        flag ? '!' : (count > 99 ? '99+' : '$count'),
        style: TextStyle(
          color: Colors.white,
          fontSize: fontSize,
        ),
      ),
    );
  }
}
