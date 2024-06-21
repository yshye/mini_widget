import 'dart:async';

import 'package:flutter/material.dart';

import '../cell/ink_cell.dart';

class ExpansionPanelController {
  bool expansion;

  ExpansionPanelController([this.expansion = false]);

  final StreamController<bool> _controller = StreamController.broadcast();

  void change(bool value) {
    expansion = value;
    _controller.sink.add(value);
  }

  void add(ValueChanged<bool> listen) => _controller.stream.listen(listen);

  void close() {
    _controller.close();
  }
}

class ExpansionPanelWidget extends StatefulWidget {
  final Widget header;
  final Widget body;
  final double iconRight;
  final Color iconColor;
  final ExpansionPanelController? controller;

  const ExpansionPanelWidget({
    super.key,
    required this.header,
    required this.body,
    this.iconRight = 30,
    this.iconColor = const Color(0xe6b5b5b5),
    this.controller,
  });

  @override
  State<StatefulWidget> createState() => _ExpansionPanelWidgetState();
}

class _ExpansionPanelWidgetState extends State<ExpansionPanelWidget> {
  bool isExpansion = false;

  @override
  void initState() {
    if (widget.controller != null) {
      isExpansion = widget.controller!.expansion;
      widget.controller!.add((value) {
        isExpansion = value;
        setState(() {});
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        InkCell(
          onTap: () {
            if (widget.controller != null) {
              widget.controller!.change(!isExpansion);
            } else {
              isExpansion = !isExpansion;
              setState(() {});
            }
          },
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              widget.header,
              Positioned(
                  right: widget.iconRight,
                  child: Icon(
                    isExpansion ? Icons.keyboard_arrow_up : Icons.expand_more,
                    color: widget.iconColor,
                  ))
            ],
          ),
        ),
        Visibility(visible: isExpansion, child: widget.body)
      ],
    );
  }
}
