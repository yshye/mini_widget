import 'package:flutter/material.dart';

import 'ink_cell.dart';

class ErrorLineCell extends StatelessWidget {
  final String? errorText;
  final IconData errorIcon;
  final Color errorColor;
  final double? height;
  final Color? backgroundColor;
  final VoidCallback? onTap;
  final bool center;

  const ErrorLineCell({
    super.key,
    this.errorText,
    this.errorIcon = Icons.info_outline,
    this.errorColor = Colors.red,
    this.height,
    this.backgroundColor,
    this.onTap,
    this.center = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkCell(
      onTap: onTap,
      height: height,
      color: backgroundColor ?? errorColor.withAlpha(60),
      padding: const EdgeInsets.only(left: 10, top: 10, bottom: 10, right: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Icon(errorIcon, color: errorColor, size: 20),
          const SizedBox(width: 5),
          if (center) ...{
            Text(errorText ?? '', style: TextStyle(color: errorColor)),
          } else ...{
            Expanded(
              child: Text(errorText ?? '', style: TextStyle(color: errorColor)),
            )
          }
        ],
      ),
    );
  }
}
