import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mini_extension/mini_extension.dart';

import '../../util/_.dart';
import '../res/styles.dart';

class ImagesViewPage extends StatefulWidget {
  final int defaultIndex;
  final List<String> imgUrls;
  final double width;

  const ImagesViewPage(
      {super.key,
      this.defaultIndex = 0,
      required this.imgUrls,
      required this.width})
      : assert(defaultIndex < imgUrls.length);

  @override
  State createState() => _ImageViewPageState();
}

class _ImageViewPageState extends State<ImagesViewPage> {
  // var image;
  // var w;
  int index = 1;
  late ScrollController _scrollController;
  var down = 0.0; //触开始的时候的left
  var half = false; //是否超过一半

  last() {
    if (1 == index) {
    } else {
      setState(() {
        // image = widget.imgUrls[index - 2];
        index = index - 1;
      });
    }
  }

  next() {
    if (widget.imgUrls.length == index) {
    } else {
      setState(() {
        // image = widget.imgUrls[index];
        index = index + 1;
      });
    }
  }

  delete() {
    Navigator.pop(context);
  }

  @override
  void initState() {
    //页面初始化
    super.initState();
    _scrollController = ScrollController(
        initialScrollOffset: widget.width * (widget.defaultIndex));
    setState(() {
      // image = widget.imgUrls[widget.defaultIndex];
      index = widget.defaultIndex + 1;
    });
  }

  nextPage(double w) {
    setState(() {
      index = index + 1;
      _scrollController.animateTo(
        (index - 1) * w,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeIn,
      );
    });
  }

  lastPage(double w) {
    setState(() {
      index = index - 1;
      _scrollController.animateTo(
        (index - 1) * w,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeIn,
      );
    });
  }

  moveEnd(e, double w, size) {
    var end = e.primaryVelocity;
    if (end > 10 && index > 1) {
      lastPage(w);
    } else if (end < -10 && index < size) {
      nextPage(w);
    } else if (half == true) {
      if (down > w / 2 && index < size) {
        //右边开始滑动超过一半,则下一张
        nextPage(w);
      } else if (down < w / 2 && index > 1) {
        lastPage(w);
      } else {
        _scrollController.animateTo(
          (index - 1) * w,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeIn,
        );
      }
    } else {
      _scrollController.animateTo(
        (index - 1) * w,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeIn,
      );
    }
  }

  imgMove(e, double w, size) {
    //down 为起点
    var left = e.position.dx;
    var now = (index - 1) * w;
    var move = left - down; //移动距离
    if (left - down > w / 2 || down - left > w / 2) {
      half = true;
    } else {
      half = false;
    }
    _scrollController.jumpTo(now - move);
  }

  Widget list(double w, size) {
    List<Widget> array = [];
    for (var url in widget.imgUrls) {
      array.add(
        Listener(
          onPointerMove: (e) => imgMove(e, w, size),
          onPointerDown: (e) => down = e.position.dx,
          child: GestureDetector(
            onHorizontalDragEnd: (e) => moveEnd(e, w, size),
            onTap: () => Navigator.pop(context),
            child: SizedBox(
              width: w,
              child: url.isUrl ? Image.network(url) : Image.file(File(url)),
            ),
          ),
        ),
      );
    }
    return ListView(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        children: array);
  }

  @override
  Widget build(BuildContext context) {
    var size = widget.imgUrls.length;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          list(MediaQuery.of(context).size.width, size),
          Positioned(
            left: 0.0,
            right: 0.0,
            top: 24.0,
            child: Container(
              alignment: Alignment.center,
              width: double.infinity,
              height: 35,
              color: Colors.black12,
              child: Text(
                '$index/$size',
                style: MiniStyle.textTitle.copyWith(color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }
}
