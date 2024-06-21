import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../util/_.dart';

abstract class MiniDetailPage extends StatelessWidget {
  const MiniDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: Container(
        color: getBackgroundColor(context),
        alignment: Alignment.topLeft,
        child: buildBody(context) ?? buildLoadingWidget(),
      ),
      endDrawer: buildEndDrawer(context),
      bottomNavigationBar: buildBottomAppBar(context),
      floatingActionButton: buildFloatingActionButton(context),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(MdiIcons.arrowLeft),
        color: Colors.blue,
        onPressed: () => Navigator.of(context).pop(),
      ),
      centerTitle: true,
      title: buildTitle(context) ?? const Text(''),
    );
  }

  bool isEmpty(value) => StringUtil.isEmpty(value);

  Color getBackgroundColor(BuildContext context) =>
      Theme.of(context).colorScheme.surface;

  Widget? buildTitle(BuildContext context);

  Widget? buildBody(BuildContext context);

  Widget? buildEndDrawer(BuildContext context);

  BottomAppBar? buildBottomAppBar(BuildContext context) {
    Widget? widget = buildNavigationButton(context);
    if (widget == null) return null;

    return BottomAppBar(
        color: Theme.of(context).bottomAppBarTheme.color,
        elevation: 0.5,
        child: widget);
  }

  Widget? buildNavigationButton(BuildContext context);

  Widget? buildFloatingActionButton(BuildContext context) {
    return null;
  }

  void back(BuildContext context, {bool success = false}) {
    if (isEmpty(success)) {
      Navigator.pop(context);
    } else {
      Navigator.pop(context, success);
    }
  }

  Widget buildLoadingWidget() {
    return Center(
      child: Theme(
        data: ThemeData(
            cupertinoOverrideTheme:
                const CupertinoThemeData(brightness: Brightness.light)),
        child: const CupertinoActivityIndicator(radius: 14.0),
      ),
    );
  }
}
