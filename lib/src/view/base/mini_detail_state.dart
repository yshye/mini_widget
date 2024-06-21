import 'dart:async';
import 'package:flutter/material.dart';

import 'mixin_state.dart';

abstract class MiniDetailState<T extends StatefulWidget> extends State<T>
    with StateMixin, AutomaticKeepAliveClientMixin {
  bool bottomOffstage = true;
  bool isEdited = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return PopScope(
      canPop: false,
      onPopInvoked: (value) async {
        bool flag = await onSystemBack();
        if (flag) {
          pop();
        }
      },
      child: Container(
        alignment: Alignment.topCenter,
        color: Colors.black,
        child: SizedBox(
          width: getMaxWidth(),
          height: MediaQuery.of(context).size.height,
          child: Scaffold(
            key: _scaffoldKey,
            appBar: bottomOffstage ? buildAppBar() : null,
            resizeToAvoidBottomInset: resizeToAvoidBottomInset(),
            body: Container(
              alignment: Alignment.topCenter,
              child: Stack(
                children: <Widget>[
                  Container(
                    color: getBackgroundColor(),
                    height: double.infinity,
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () =>
                          FocusScope.of(context).requestFocus(FocusNode()),
                      child: buildBody() ?? buildLoadingWidget(),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Offstage(
                      offstage: bottomOffstage,
                      child: buildBottomOffstage(),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    top: 0,
                    right: 0,
                    bottom: 0,
                    child: buildTopLayout(),
                  ),
                ],
              ),
            ),
            endDrawer: buildEndDrawer(),
            bottomNavigationBar: bottomOffstage ? buildBottomAppBar() : null,
            floatingActionButton:
                bottomOffstage ? buildFloatingActionButton() : null,
            backgroundColor: getBackgroundColor(),
          ),
        ),
      ),
    );
  }

  void openEndDrawer() => _scaffoldKey.currentState?.openEndDrawer();

  Widget? buildBottomAppBar() {
    Widget? widget = buildNavigationButton();
    if (widget == null) return null;
    return BottomAppBar(
        color: Theme.of(context).bottomAppBarTheme.color,
        elevation: 0.5,
        child: widget);
  }

  PreferredSizeWidget? buildAppBar() => buildTitle() == null
      ? null
      : AppBar(
          centerTitle: centerTitle(),
          leading: buildLeading(),
          title: buildTitle() ?? const Text(''),
          elevation: barElevation(),
          actions: buildActions(),
        );

  double barElevation() => 0.5;

  @protected
  bool centerTitle() => true;

  @protected
  List<Widget> buildActions() => [];

  @protected
  Widget? buildTitle();

  @protected
  Widget? buildLeading() => null;

  @protected
  Widget? buildBody();

  @protected
  Widget? buildEndDrawer() => null;

  @protected
  Widget? buildNavigationButton() => null;

  @protected
  Widget? buildFloatingActionButton() => null;

  @protected
  Color getBackgroundColor() => Theme.of(context).colorScheme.surface;

  @protected
  Future<bool> onSystemBack() async {
    pop();
    return false;
  }

  @protected
  Widget buildBottomOffstage() => Container();

  @protected
  void changeBottomOffstage() {
    bottomOffstage = !bottomOffstage;
    setState(() {});
  }

  @protected
  Widget buildTopLayout() => Container();

  bool resizeToAvoidBottomInset() => true;

  @override
  bool get wantKeepAlive => false;
}
