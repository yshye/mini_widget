import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../config.dart';
import '../base/mixin_state.dart';
import '../widget/scrawl_location_widget.dart';
import 'package:flutter_bmflocation/flutter_bmflocation.dart';

class ScrawlLocationPage extends StatefulWidget {
  final String filePath;
  final List<Color> colors;
  final Color backColor;
  final bool showTop;
  final bool enableTransform;

  const ScrawlLocationPage(
    this.filePath, {
    super.key,
    this.colors = const [Colors.redAccent, Colors.lightBlueAccent],
    this.backColor = Colors.black12,
    this.showTop = true,
    this.enableTransform = true,
  });

  @override
  State<ScrawlLocationPage> createState() => _ScrawlLocationPageState();
}

class _ScrawlLocationPageState extends State<ScrawlLocationPage>
    with StateMixin {
  final GlobalKey<ScrawlWithLocationState> _key = GlobalKey();
  LocationFlutterPlugin myLocPlugin = LocationFlutterPlugin();

  /// 申请定位权限
  /// 授予定位权限返回true， 否则返回false
  Future<bool> requestLocationPermission() async {
    //获取当前的权限
    var status = await Permission.location.status;
    if (status == PermissionStatus.granted) {
      //已经授权
      return true;
    } else {
      //未授权则发起一次申请
      status = await Permission.location.request();
      if (status == PermissionStatus.granted) {
        return true;
      } else {
        return false;
      }
    }
  }

  @override
  void afterBuild(Duration timestamp) {}

  @override
  Widget build(BuildContext context) {
    return ScrawlWithLocationWidget(
      widget.filePath,
      saveImage: (file) {},
      key: _key,
      appLogo: MiniWidget.appLogo,
      appName: MiniWidget.appName,
      authorName: MiniWidget.authorName,
      enableTransform: widget.enableTransform,
      showTop: widget.showTop,
      backColor: widget.backColor,
      colors: widget.colors,
    );
  }
}
