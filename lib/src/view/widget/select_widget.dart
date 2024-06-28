import 'package:flutter/material.dart';

import '../../util/_.dart';
import '../res/colors.dart';
import '../res/dimens.dart';
import '../typedef.dart';

/// 选择组件，支持单选和多选
class SelectWidget<T> extends StatefulWidget {
  final List<T> data;
  final List<T>? selectedData;
  final Compare<T>? compare;
  final BuildCheckChild<T>? buildCheckChild;

  /// 是否支持多选
  final bool multiple;

  const SelectWidget(this.data,
      {super.key,
      this.buildCheckChild,
      this.selectedData,
      this.compare,
      this.multiple = true});

  @override
  SelectWidgetState<T> createState() => SelectWidgetState<T>();
}

class SelectWidgetState<T> extends State<SelectWidget> {
  final String checkKey = 'check';
  final String itemKey = 'item';
  final String titleKey = 'title';

  List bases = [];
  List items = [];

  List<T> getSelected() {
    List<T> temp = [];
    for (var item in items) {
      if (item[checkKey]) temp.add(item[itemKey]);
    }
    return temp;
  }

  @override
  void initState() {
    super.initState();
    for (var i = 0; i < widget.data.length; ++i) {
      var item = widget.data[i];
      bool flag = false;
      // 匹配已经选择的内容
      if (widget.selectedData != null && widget.selectedData!.isNotEmpty) {
        for (var i = 0; i < widget.selectedData!.length; ++i) {
          if (widget.compare != null) {
            if (widget.compare!(item, widget.selectedData![i]) == 0) {
              flag = true;
              break;
            }
          } else {
            if (widget.selectedData![i][titleKey] == item[titleKey]) {
              flag = true;
              break;
            }
          }
        }
      }
      items.add({checkKey: flag, itemKey: item});
    }
    bases.addAll(items);
  }

  void search(String searchKey) {
    if (searchKey.isEmpty) {
      items.clear();
      items.addAll(bases);
    } else {
      items.clear();
      if (bases.any((i) => i.toString().contains(searchKey))) {
        items.addAll(bases.where((i) => i.toString().contains(searchKey)));
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    bool all = items.any((item) => !item[checkKey]);
    List<Widget> checkItem = [];
    for (var i = 0; i < items.length; ++i) {
      checkItem.add(CheckboxListTile(
        value: items[i][checkKey],
        onChanged: (value) {
          if (widget.multiple) {
            items[i][checkKey] = value;
          } else {
            if (items[i][checkKey] != true) {
              for (var f in items) {
                f[checkKey] = false;
              }
              items[i][checkKey] = true;
            }
          }
          setState(() {});
        },
        title: widget.buildCheckChild != null
            ? widget.buildCheckChild!(context, items[i][itemKey])
            : Text(
                items[i][itemKey][titleKey],
                style: const TextStyle(fontSize: MiniDimen.fontNormal),
              ),
      ));
      checkItem.add(const Divider(height: 1));
    }
    if (widget.multiple) {
      return Column(
        children: <Widget>[
          Container(
            color: MiniColor.white,
            child: CheckboxListTile(
              value: !all,
              title: const Text('全选'),
              onChanged: (value) {
                for (var i = 0; i < items.length; ++i) {
                  items[i][checkKey] = value;
                }
                setState(() {});
              },
            ),
          ),
          const SizedBox(height: 1),
          Expanded(
            child: ListView(children: checkItem),
          )
        ],
      );
    }

    return ListView(children: checkItem);
  }
}
