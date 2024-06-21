import 'package:flutter/material.dart';
import 'gzx_dropdown_menu_controller.dart';

class GZXDropDownHeader extends StatefulWidget {
  /// 头部背景颜色
  final Color color;

  /// 头部边框宽度
  final double borderWidth;

  /// 头部边框颜色
  final Color borderColor;

  /// 文字样式
  final TextStyle style;

  /// 下拉时文字样式
  final TextStyle? dropDownStyle;

  /// 图标大小
  final double iconSize;

  /// 图标颜色
  final Color iconColor;

  /// 下拉时图标颜色
  final Color? iconDropDownColor;

//  final List<String> menuStrings;
  /// 头部的高度
  final double height;

  /// 分割线高度
  final double dividerHeight;

  /// 分割线颜色
  final Color dividerColor;

  /// controller用于控制menu的显示或隐藏
  final GZXDropdownMenuController controller;

  /// 当点击头部项的事件，在这里可以进行页面跳转或openEndDrawer
  final void Function(int)? onItemTap;

  /// 下拉的头部项
  final List<GZXDropDownHeaderItem> items;

  /// GZXDropDownHeader对应第一父级Stack的key
  final GlobalKey stackKey;

  /// 最大宽度
  final double? headerWidth;

  const GZXDropDownHeader({
    super.key,
    required this.items,
    required this.controller,
    required this.stackKey,
    this.style = const TextStyle(color: Color(0xFF666666), fontSize: 13),
    this.dropDownStyle,
    this.height = 40,
    this.iconColor = const Color(0xFFafada7),
    this.iconDropDownColor,
    this.iconSize = 20,
    this.borderWidth = 1,
    this.borderColor = const Color(0xFFeeede6),
    this.dividerHeight = 20,
    this.dividerColor = const Color(0xFFeeede6),
    this.onItemTap,
    this.color = Colors.white,
    this.headerWidth,
  });

  @override
  createState() => _GZXDropDownHeaderState();
}

class _GZXDropDownHeaderState extends State<GZXDropDownHeader>
    with SingleTickerProviderStateMixin {
  bool _isShowDropDownItemWidget = false;

  // late double _screenWidth;
  // late int _menuCount;
  final GlobalKey _keyDropDownHeader = GlobalKey();
  TextStyle? _dropDownStyle;
  Color? _iconDropDownColor;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onController);
  }

  _onController() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    _dropDownStyle = widget.dropDownStyle ??
        TextStyle(color: Theme.of(context).primaryColor, fontSize: 13);
    _iconDropDownColor =
        widget.iconDropDownColor ?? Theme.of(context).primaryColor;

    // MediaQueryData mediaQuery = MediaQuery.of(context);
    // _screenWidth = widget.headerWidth ?? mediaQuery.size.width;
    // _menuCount = widget.items.length;

    // var gridView = GridView.count(
    //   physics: const NeverScrollableScrollPhysics(),
    //   crossAxisCount: _menuCount,
    //   childAspectRatio: (_screenWidth / _menuCount) / widget.height,
    //   children: widget.items.map<Widget>((item) {
    //     return _menu(item);
    //   }).toList(),
    // );

    var rowView =
        Row(children: widget.items.map<Widget>((e) => _buildItem(e)).toList());

    return Container(
      key: _keyDropDownHeader,
      width: widget.headerWidth ?? MediaQuery.of(context).size.width,
      height: widget.height,
//      padding: EdgeInsets.only(top: 1, bottom: 1),
      decoration: BoxDecoration(
        border:
            Border.all(color: widget.borderColor, width: widget.borderWidth),
      ),
      child: rowView,
    );
  }

  _menu(GZXDropDownHeaderItem item) {
    int index = widget.items.indexOf(item);
    int menuIndex = widget.controller.menuIndex;
    _isShowDropDownItemWidget = index == menuIndex && widget.controller.isShow;

    return GestureDetector(
      onTap: () {
        final RenderBox? overlay =
            widget.stackKey.currentContext!.findRenderObject() as RenderBox?;

        final RenderBox dropDownItemRenderBox =
            _keyDropDownHeader.currentContext!.findRenderObject() as RenderBox;

        var position =
            dropDownItemRenderBox.localToGlobal(Offset.zero, ancestor: overlay);
//        print("POSITION : $position ");
        var size = dropDownItemRenderBox.size;
//        print("SIZE : $size");

        widget.controller.dropDownHeaderHeight = size.height + position.dy;

        if (index == menuIndex) {
          if (widget.controller.isShow) {
            widget.controller.hide();
          } else {
            widget.controller.show(index);
          }
        } else {
          if (widget.controller.isShow) {
            widget.controller.hide(isShowHideAnimation: false);
          }
          widget.controller.show(index);
        }

        if (widget.onItemTap != null) {
          widget.onItemTap!(index);
        }

        setState(() {});
      },
      child: Container(
        color: widget.color,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    child: Text(
                      item.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: _isShowDropDownItemWidget
                          ? _dropDownStyle
                          : widget.style.merge(item.style),
                    ),
                  ),
                  Icon(
                    !_isShowDropDownItemWidget
                        ? item.iconData ?? Icons.arrow_drop_down
                        : item.iconData ?? Icons.arrow_drop_up,
                    color: _isShowDropDownItemWidget
                        ? _iconDropDownColor
                        : item.style?.color ?? widget.iconColor,
                    size: item.iconSize ?? widget.iconSize,
                  ),
                ],
              ),
            ),
            index == widget.items.length - 1
                ? Container()
                : Container(
                    height: widget.dividerHeight,
                    decoration: BoxDecoration(
                      border: Border(
                        right: BorderSide(color: widget.dividerColor, width: 1),
                      ),
                    ),
                  )
          ],
        ),
      ),
    );
  }

  _buildItem(GZXDropDownHeaderItem item) {
    int index = widget.items.indexOf(item);
    int menuIndex = widget.controller.menuIndex;
    _isShowDropDownItemWidget = index == menuIndex && widget.controller.isShow;

    onTop() {
      final RenderBox? overlay =
          widget.stackKey.currentContext!.findRenderObject() as RenderBox?;

      final RenderBox dropDownItemRenderBox =
          _keyDropDownHeader.currentContext!.findRenderObject() as RenderBox;

      var position =
          dropDownItemRenderBox.localToGlobal(Offset.zero, ancestor: overlay);
      var size = dropDownItemRenderBox.size;

      widget.controller.dropDownHeaderHeight = size.height + position.dy;

      if (index == menuIndex) {
        if (widget.controller.isShow) {
          widget.controller.hide();
        } else {
          widget.controller.show(index);
        }
      } else {
        if (widget.controller.isShow) {
          widget.controller.hide(isShowHideAnimation: false);
        }
        widget.controller.show(index);
      }

      if (widget.onItemTap != null) {
        widget.onItemTap!(index);
      }

      setState(() {});
    }

    if (item.sort) {
      return GestureDetector(
        onTap: onTop,
        child: Row(
          children: [
            SizedBox(
              width: 50,
              height: widget.height,
              child: Icon(Icons.swap_vert, color: widget.iconColor),
            ),
            if (index != widget.items.length - 1) ...{
              Container(
                height: widget.dividerHeight,
                decoration: BoxDecoration(
                  border: Border(
                    right: BorderSide(color: widget.dividerColor, width: 1),
                  ),
                ),
              )
            }
          ],
        ),
      );
    }

    return Expanded(
      flex: 1,
      child: GestureDetector(
        onTap: onTop,
        child: Container(
          color: widget.color,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Flexible(
                      child: Text(
                        item.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: _isShowDropDownItemWidget
                            ? _dropDownStyle
                            : widget.style.merge(item.style),
                      ),
                    ),
                    Icon(
                      !_isShowDropDownItemWidget
                          ? item.iconData ?? Icons.arrow_drop_down
                          : item.iconData ?? Icons.arrow_drop_up,
                      color: _isShowDropDownItemWidget
                          ? _iconDropDownColor
                          : item.style?.color ?? widget.iconColor,
                      size: item.iconSize ?? widget.iconSize,
                    ),
                  ],
                ),
              ),
              if (index != widget.items.length - 1) ...{
                Container(
                  height: widget.dividerHeight,
                  decoration: BoxDecoration(
                    border: Border(
                      right: BorderSide(color: widget.dividerColor, width: 1),
                    ),
                  ),
                )
              }
            ],
          ),
        ),
      ),
    );
  }
}

class GZXDropDownHeaderItem {
  String title;
  final IconData? iconData;
  final double? iconSize;
  final TextStyle? style;

  /// 是否是排序头部
  final bool sort;

  GZXDropDownHeaderItem(
    this.title, {
    this.iconData,
    this.iconSize,
    this.style,
    this.sort = false,
  });
}
