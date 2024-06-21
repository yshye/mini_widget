import 'package:flutter/material.dart';

class BaseDialog extends StatelessWidget {
  const BaseDialog({
    super.key,
    this.title,
    this.onClick1,
    this.onClick2,
    this.onlyOneButton = true,
    this.hiddenTitle = false,
    this.bottomChild,
    this.titleStyle = const TextStyle(),
    required this.child,
    this.button1,
    this.button2,
    this.button1Text,
    this.button2Text,
    this.width,
  });

  final String? title;
  final VoidCallback? onClick1;
  final VoidCallback? onClick2;
  final bool onlyOneButton;
  final bool hiddenTitle;
  final Widget child;
  final Widget? bottomChild;
  final TextStyle? titleStyle;
  final Widget? button1;
  final Widget? button2;
  final String? button1Text;
  final String? button2Text;
  final double? width;

  @override
  Widget build(BuildContext context) {
    Widget dialogTitle = Visibility(
      visible: !hiddenTitle,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Text(title ?? '', style: titleStyle),
      ),
    );
    Widget? bottomButton = bottomChild;
    if (bottomButton == null) {
      if (onlyOneButton) {
        bottomButton = button1 ??
            _DialogButton(
              text: button1Text ?? '知道了',
              textColor: Colors.blue,
              onPressed: onClick1,
            );
      } else {
        bottomButton = Row(children: <Widget>[
          button1 ??
              _DialogButton(
                text: button1Text ?? '取消',
                textColor: Colors.grey,
                onPressed: onClick1,
              ),
          SizedBox(
            height: 48.0,
            width: 0.6,
            child: VerticalDivider(
                color: Colors.grey[200], indent: 2, endIndent: 2),
          ),
          button2 ??
              _DialogButton(
                text: button2Text ?? '确认',
                textColor: Theme.of(context).primaryColor,
                onPressed: onClick2,
              )
        ]);
      }
    }
    var body = Material(
      borderRadius: BorderRadius.circular(8.0),
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const SizedBox(height: 18),
          dialogTitle,
          Flexible(child: child),
          const SizedBox(height: 12),
          Divider(color: Colors.grey[200], height: 0.8),
          bottomButton,
        ],
      ),
    );
    return AnimatedPadding(
      padding: MediaQuery.of(context).viewInsets + const EdgeInsets.all(25),
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeInCubic,
      child: MediaQuery.removeViewInsets(
        removeLeft: true,
        removeTop: true,
        removeRight: true,
        removeBottom: true,
        context: context,
        child: Center(
          child:
              SizedBox(width: width != null ? width! - 50 : null, child: body),
        ),
      ),
    );
  }
}

class _DialogButton extends StatelessWidget {
  const _DialogButton({
    required this.text,
    this.textColor,
    this.onPressed,
  });

  final String text;
  final Color? textColor;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
        height: 48.0,
        child: MaterialButton(
          textColor: textColor,
          onPressed: onPressed,
          child: Text(text, style: const TextStyle(fontSize: 18)),
        ),
      ),
    );
  }
}
