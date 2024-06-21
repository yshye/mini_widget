import 'package:flutter/material.dart';

class EmptyWidget extends StatelessWidget {
  final Widget? child;
  final String? emptyImageAsset;
  final String emptyMessage;
  final Color? emptyMessageColor;

  const EmptyWidget({
    super.key,
    this.emptyImageAsset,
    this.emptyMessage = '暂无内容！',
    this.child,
    this.emptyMessageColor,
  }) : assert(child != null || emptyImageAsset != null);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 1,
      itemBuilder: (ctx, index) =>
          child ??
          SizedBox(
            height: 400,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Image.asset(emptyImageAsset!, width: 100, height: 100),
                const SizedBox(height: 10),
                Text(
                  emptyMessage,
                  style: TextStyle(
                    color: emptyMessageColor ??
                        Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.color
                            ?.withAlpha(100),
                  ),
                ),
              ],
            ),
          ),
    );
  }
}
