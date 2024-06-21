import 'package:flutter/material.dart';

class InkCell extends StatelessWidget {
  final Color color;
  final Color splashColor;
  final GestureTapCallback? onTap;
  final GestureTapCallback? onDoubleTap;
  final GestureLongPressCallback? onLongPress;
  final GestureTapDownCallback? onTapDown;
  final GestureTapCancelCallback? onTapCancel;
  final Widget? child;
  final double circular;
  final BorderRadius? radius;
  final double? height;
  final List<Color>? shapeColors;
  final List<double>? shapeWidths;
  final EdgeInsetsGeometry padding;
  final String? tooltip;

  const InkCell({
    super.key,
    this.color = Colors.transparent,
    this.splashColor = const Color(0xFFE0E0E0),
    this.onTap,
    this.circular = 0,
    this.child,
    this.padding = EdgeInsets.zero,
    this.height,
    this.radius,
    this.onLongPress,
    this.onDoubleTap,
    this.onTapDown,
    this.onTapCancel,
    this.shapeColors,
    this.shapeWidths,
    this.tooltip,
  })  : assert(shapeColors == null || shapeColors.length == 4),
        assert(shapeWidths == null || shapeWidths.length == 4);

  @override
  Widget build(BuildContext context) {
    Widget result = ClipRRect(
      borderRadius: radius ?? BorderRadius.all(Radius.circular(circular)),
      child: Material(
        color: color,
        shape: BorderDirectional(
          start: BorderSide(
            color: shapeColors == null ? Colors.transparent : shapeColors![0],
            width: shapeWidths == null ? 0 : shapeWidths![0],
          ),
          top: BorderSide(
            color: shapeColors == null ? Colors.transparent : shapeColors![1],
            width: shapeWidths == null ? 0 : shapeWidths![1],
          ),
          end: BorderSide(
            color: shapeColors == null ? Colors.transparent : shapeColors![2],
            width: shapeWidths == null ? 0 : shapeWidths![2],
          ),
          bottom: BorderSide(
            color: shapeColors == null ? Colors.transparent : shapeColors![3],
            width: shapeWidths == null ? 0 : shapeWidths![3],
          ),
        ),
        child: Ink(
          child: InkWell(
            borderRadius: radius ?? BorderRadius.all(Radius.circular(circular)),
            highlightColor: splashColor.withAlpha(80),
            splashColor: splashColor,
            onTap: onTap,
            onLongPress: onLongPress,
            onDoubleTap: onDoubleTap,
            onTapCancel: onTapCancel,
            onTapDown: onTapDown,
            child: Container(padding: padding, height: height, child: child),
          ),
        ),
      ),
    );
    return tooltip == null
        ? result
        : Tooltip(
            message: tooltip,
            preferBelow: false,
            child: result,
          );
  }
}
