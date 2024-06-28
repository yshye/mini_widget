import 'package:flutter/material.dart';
import 'package:mini_extension/mini_extension.dart';
import '../base/_.dart';

/// 启动图封装
class LaunchPage extends StatefulWidget {
  /// 启动图片
  final String launchBackgroundPath;

  /// 结束后回调
  final ValueChanged<BuildContext> endCallback;

  /// 动画持续时间
  final Duration splashTimes;

  const LaunchPage({
    super.key,
    required this.launchBackgroundPath,
    required this.endCallback,
    this.splashTimes = const Duration(seconds: 3),
  });

  @override
  State createState() => _LaunchPageState();
}

class _LaunchPageState extends MiniDetailState<LaunchPage> {
  @override
  void afterBuild(Duration timestamp) {
    Future.delayed(widget.splashTimes).then((value) {
      widget.endCallback(context);
    });
  }

  @override
  Widget? buildBody() {
    return AnimatedOpacity(
      opacity: 1,
      duration: widget.splashTimes,
      child: widget.launchBackgroundPath.isUrl
          ? Image.network(widget.launchBackgroundPath,
              width: double.infinity,
              fit: BoxFit.cover,
              height: double.infinity)
          : Image.asset(widget.launchBackgroundPath,
              width: double.infinity,
              fit: BoxFit.cover,
              height: double.infinity),
    );
  }

  @override
  Widget? buildTitle() => null;
}
