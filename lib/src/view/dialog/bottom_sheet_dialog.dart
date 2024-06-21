import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BottomSheetDialog extends StatelessWidget {
  final Widget title;
  final Widget? titleLeft;
  final Widget? titleRight;
  final Color backgroundColor;
  final List<Widget> children;
  final Widget? operation;
  final VoidCallback? onOk;
  final double height;
  final double? width;
  final VoidCallback? onClose;
  final EdgeInsetsGeometry padding;
  final double? offsetWithEnd;
  final ScrollController _controller = ScrollController();

  BottomSheetDialog({
    super.key,
    required this.title,
    this.children = const [],
    this.padding = const EdgeInsets.only(left: 5, right: 5, bottom: 10),
    this.operation,
    this.titleLeft,
    this.titleRight,
    this.height = 300,
    this.width,
    this.onOk,
    this.onClose,
    this.backgroundColor = Colors.white,
    this.offsetWithEnd,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      onEnd: () {
        if (offsetWithEnd != null) {
          // var sorH = _controller.position.maxScrollExtent;
          // var bottom = MediaQuery.of(context).viewInsets.bottom;
          _controller.animateTo(
            offsetWithEnd!,
            duration: const Duration(milliseconds: 100),
            curve: Curves.linear,
          );
        }
      },
      height: height,
      duration: const Duration(milliseconds: 100),
      child: Container(
        alignment: Alignment.bottomCenter,
        child: SizedBox(
          width: width,
          child: Padding(
            padding: padding,
            child: Material(
              color: backgroundColor,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              child: Container(
                height: height,
                margin: const EdgeInsets.only(left: 10, right: 10, top: 8),
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                  child: Column(
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          Positioned(
                            left: 8.0,
                            child: titleLeft ??
                                CupertinoButton(
                                  padding: const EdgeInsets.all(5),
                                  onPressed:
                                      onClose ?? () => Navigator.pop(context),
                                  child: const Text('取消',
                                      style: TextStyle(
                                          color: Colors.black54, fontSize: 18)),
                                ),
                          ),
                          Container(
                            width: double.infinity,
                            alignment: Alignment.center,
                            height: 40,
                            child: title,
                          ),
                          Positioned(
                            right: 8.0,
                            child: titleRight ??
                                CupertinoButton(
                                  padding: const EdgeInsets.all(5),
                                  onPressed: onOk,
                                  child: const Text('确认',
                                      style: TextStyle(
                                          color: Colors.blue, fontSize: 18)),
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Expanded(
                        child: SingleChildScrollView(
                          controller: _controller,
                          child: Column(children: children),
                        ),
                      ),
                      Container(child: operation ?? Container(height: 15))
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
