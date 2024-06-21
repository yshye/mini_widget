import 'package:flutter/material.dart';
import '../widget/badge_widget.dart';

class ImageLabelCell extends StatelessWidget {
  final String? label;
  final String imagePath;
  final Color? color;
  final Color? labelColor;
  final double labelSize;
  final VoidCallback? onTap;
  final double iconSize;
  final double interval;
  final bool flag;
  final int? number;
  final double offsetX;
  final double offsetY;
  final bool visible;

  const ImageLabelCell({
    super.key,
    this.label,
    required this.imagePath,
    this.color,
    this.labelColor,
    this.onTap,
    this.labelSize = 12,
    this.iconSize = 25,
    this.interval = 12,
    this.flag = false,
    this.number = 0,
    this.offsetX = -8,
    this.offsetY = -8,
    this.visible = false,
  });

  @override
  Widget build(BuildContext context) {
    int count = number ?? 0;

    return Material(
      child: Ink(
        color: color ?? Theme.of(context).canvasColor,
        child: InkWell(
          onTap: onTap,
          child: Container(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Stack(
                  children: [
                    Container(
                      width: iconSize + 40,
                      height: iconSize + 8,
                      alignment: Alignment.bottomCenter,
                      child: SizedBox(
                        width: iconSize,
                        height: iconSize,
                        child: Image.asset(imagePath),
                      ),
                    ),
                    if (flag || count > 0) ...{
                      Positioned(
                        right: count < 10 ? 13 : (count < 100 ? 10 : 5),
                        top: 0,
                        child: BadgeTipWidget(count: count, flag: flag),
                      ),
                    },
                  ],
                ),
                SizedBox(height: interval),
                Text(label ?? '',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontSize: labelSize,
                          color: labelColor,
                        )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
