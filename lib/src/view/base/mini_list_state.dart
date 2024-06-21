import 'package:flutter/material.dart';
import 'package:easy_refresh/easy_refresh.dart';
import '../widget/empty_widget.dart';
import 'mixin_state.dart';

abstract class MiniTableListState<T extends StatefulWidget, M> extends State<T>
    with StateMixin, AutomaticKeepAliveClientMixin {
  final EasyRefreshController _controller = EasyRefreshController(
      controlFinishRefresh: true, controlFinishLoad: true);
  bool isEdited = false;
  List<M> list = [];
  int pageIndex = 1;
  bool showEmptyWidget = false;

  @override
  void afterBuild(Duration timestamp) {
    if (hasRefresh() && firstRefresh()) {
      fetchData(false);
    }
  }

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
      child: Material(
        color: getBackgroundColor(),
        child: Column(
          children: [
            buildTableBar(),
            Expanded(
              child: EasyRefresh(
                controller: _controller,
                // header: BallPulseHeader(colorf: Theme.of(context).primaryColor),
                // footer: BallPulseFooter(color: Theme.of(context).primaryColor),
                header: const CupertinoHeader(),
                footer: const CupertinoFooter(),
                // enableControlFinishRefresh: true,
                // enableControlFinishLoad: true,
                onRefresh: hasRefresh()
                    ? () async {
                        await fetchData(false);
                        _controller.finishRefresh();
                        return IndicatorResult.success;
                      }
                    : null,
                onLoad: hasMore()
                    ? () async {
                        await fetchData(true);
                        _controller.finishLoad();
                        return IndicatorResult.success;
                      }
                    : null,
                child: showEmptyWidget
                    ? EmptyWidget(
                        emptyImageAsset: getEmptyImageAsset(),
                        emptyMessage: getEmptyMessage(),
                        child: getEmptyChild())
                    : (list.isEmpty
                        ? buildLoadingWidget()
                        : ListView.builder(
                            controller: ScrollController(),
                            shrinkWrap: true,
                            itemCount: list.length,
                            itemBuilder: (ctx, index) =>
                                buildItemCell(ctx, list[index], index),
                          )),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTableBar();

  Widget? getEmptyChild() => null;

  String? getEmptyImageAsset();

  String getEmptyMessage() => '暂无内容';

  bool firstRefresh() => true;

  bool hasRefresh() => true;

  bool hasMore() => true;

  Color getBackgroundColor() => Theme.of(context).colorScheme.surface;

  fetchData(bool more) async {
    if (more) {
      pageIndex += 1;
    } else {
      pageIndex = 1;
      list.clear();
    }
  }

  void updateListUI(bool more, List<M> value, {bool show = true}) {
    if (value.isNotEmpty) {
      if (!more) list.clear();
      list.addAll(value);
    }
    showEmptyWidget = list.isEmpty;
    if (mounted) {
      if (more) {
        _controller.finishLoad();
      } else {
        _controller.finishRefresh();
      }
      setState(() {});
    }
  }

  Widget buildItemCell(BuildContext ctx, M item, int index);

  @override
  bool get wantKeepAlive => false;

  @protected
  Future<bool> onSystemBack() async {
    pop();
    return false;
  }
}

/// 列表组件
abstract class MiniListState<T extends StatefulWidget, M> extends State<T>
    with StateMixin, AutomaticKeepAliveClientMixin {
  final EasyRefreshController _controller = EasyRefreshController(
      controlFinishLoad: true, controlFinishRefresh: true);
  bool isEdited = false;
  List<M> list = [];
  int pageIndex = 1;
  bool showEmptyWidget = false;

  @override
  void afterBuild(Duration timestamp) {
    if (hasRefresh() && firstRefresh()) {
      fetchData(false);
    }
  }

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
      child: Scaffold(
        backgroundColor: getBackgroundColor(),
        appBar: null,
        body: Material(
          color: getBackgroundColor(),
          child: EasyRefresh(
            controller: _controller,
            header: const CupertinoHeader(),
            footer: const CupertinoFooter(),
            onRefresh: hasRefresh()
                ? () async {
                    await fetchData(false);
                    _controller.finishRefresh();
                    return IndicatorResult.success;
                  }
                : null,
            onLoad: hasMore()
                ? () async {
                    await fetchData(true);
                    _controller.finishLoad();
                    return IndicatorResult.success;
                  }
                : null,
            child: showEmptyWidget
                ? EmptyWidget(
                    emptyImageAsset: getEmptyImageAsset(),
                    emptyMessage: getEmptyMessage(),
                    child: getEmptyChild())
                : (list.isEmpty
                    ? buildLoadingWidget()
                    : ListView.builder(
                        controller: ScrollController(),
                        shrinkWrap: true,
                        itemCount: list.length,
                        itemBuilder: (ctx, index) =>
                            buildItemCell(ctx, list[index], index),
                      )),
          ),
        ),
        floatingActionButton: buildFloatingActionButton(),
      ),
    );
  }

  Widget? getEmptyChild() => null;

  String getEmptyImageAsset();

  String getEmptyMessage() => '暂无内容';

  bool firstRefresh() => true;

  bool hasRefresh() => true;

  bool hasMore() => true;

  Color getBackgroundColor() => Theme.of(context).colorScheme.surface;

  Future<void> fetchData(bool more) async {
    if (more) {
      pageIndex += 1;
    } else {
      pageIndex = 1;
      list.clear();
    }
  }

  void updateListUI(bool more, List<M> value, {bool show = true}) {
    if (value.isNotEmpty) {
      if (!more) list.clear();
      list.addAll(value);
    }
    showEmptyWidget = list.isEmpty;
    finishRefresh();
    setState(() {});
  }

  void finishRefresh() {
    if (pageIndex == 1) {
      _controller.finishRefresh();
    } else {
      _controller.finishLoad();
    }
  }

  Widget buildItemCell(BuildContext ctx, M item, int index);

  @override
  bool get wantKeepAlive => false;

  @protected
  Future<bool> onSystemBack() async {
    pop();
    return false;
  }

  @protected
  Widget? buildFloatingActionButton() => null;
}
