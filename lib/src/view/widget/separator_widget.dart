import 'package:flutter/material.dart';

import '../../util/theme_util.dart';

/// 间隔线条
class SeparatorWidget extends StatelessWidget {
  /// 颜色
  final Color? color;

  /// 间隔长度
  final double dash;

  /// 间隔间长度
  final double emptyDash;

  /// 方向
  final Axis direction;

  /// 线宽
  final double lineWidth;

  const SeparatorWidget(
      {super.key,
      this.color,
      this.dash = 4.0,
      this.direction = Axis.vertical,
      this.emptyDash = 4.0,
      this.lineWidth = 1.0});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final height = constraints.constrainHeight();
        final width = constraints.constrainWidth();
        if (emptyDash <= 0) {
          return SizedBox(
            width: direction == Axis.vertical ? lineWidth : width,
            height: direction == Axis.horizontal ? lineWidth : height,
            child: DecoratedBox(
              decoration: BoxDecoration(
                  color: color ?? ThemeUtil.getAccentColor(context)),
            ),
          );
        }
        List<Widget> items = [];
        double sum = 0;
        while (true) {
          sum += dash;
          if (sum < (direction == Axis.vertical ? height : width)) {
            items.add(SizedBox(
              width: direction == Axis.vertical ? lineWidth : dash,
              height: direction == Axis.horizontal ? lineWidth : dash,
              child: DecoratedBox(
                decoration: BoxDecoration(
                    color: color ?? ThemeUtil.getAccentColor(context)),
              ),
            ));
          } else {
            break;
          }
          sum += emptyDash;
          if (sum < (direction == Axis.vertical ? height : width)) {
            items.add(SizedBox(
              width: direction == Axis.vertical ? lineWidth : emptyDash,
              height: direction == Axis.horizontal ? lineWidth : emptyDash,
            ));
          } else {
            break;
          }
        }

        return Flex(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            direction: direction,
            children: items);
      },
    );
  }
}
