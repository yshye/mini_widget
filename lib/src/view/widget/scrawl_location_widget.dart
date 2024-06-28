import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:io';
import 'package:mini_extension/mini_extension.dart';

import '../../util/string_util.dart';
import '../base/mixin_state.dart';
import '../painter/scrawl_painter.dart';
import '../res/colors.dart';
import '../res/styles.dart';
import '../toast.dart';

/// 图片涂鸦+显示地理位置, 获取图片
class ScrawlWithLocationWidget extends StatefulWidget {
  final String? appName;
  final String filePath;
  final List<Color> colors;
  final Color backColor;
  final bool showTop;
  final bool enableTransform;
  final Widget? appLogo;
  final String? authorName;

  /// 保存图片
  final void Function(Uint8List data) saveImage;

  const ScrawlWithLocationWidget(
    this.filePath, {
    super.key,
    this.colors = const [Colors.redAccent, Colors.lightBlueAccent],
    this.backColor = Colors.black12,
    this.appLogo,
    this.showTop = true,
    this.enableTransform = true,
    this.appName,
    this.authorName = '',
    required this.saveImage,
  });

  @override
  State<StatefulWidget> createState() => ScrawlWithLocationState();
}

class ScrawlWithLocationState extends State<ScrawlWithLocationWidget>
    with StateMixin {
  final List<double> lineWidths = [5.0, 8.0, 10.0];
  double rotateX = 0;
  double scale = 1;
  String? location;
  File? imageFile;
  int selectedLine = 0;
  late Color selectedColor;
  late List<PaintModel> paints;

  final GlobalKey _repaintKey = GlobalKey();

  double get strokeWidth => lineWidths[selectedLine];

  /// 更新定位信息
  void updateLocationInfo(
      {double? latitude, double? longitude, String? address}) {
    location = address;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    selectedColor = widget.colors[0];
    paints = [
      PaintModel(
          sPoint: [], strokeColor: selectedColor, strokeWidth: strokeWidth)
    ];
    imageFile = widget.filePath.isEmpty ? null : File(widget.filePath);
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidthDp = MediaQuery.of(context).size.width;
    final double screenHeightDp = MediaQuery.of(context).size.height;
    return Material(
      child: Stack(
        children: <Widget>[
          Container(
            color: Colors.black,
            child: RepaintBoundary(
              key: _repaintKey,
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Container(
                      alignment: Alignment.center,
                      color: Colors.black,
                      child: Transform.scale(
                        scale: scale,
                        child: Transform(
                          transform: Matrix4.identity()..rotateZ(rotateX),
                          origin: Offset(screenWidthDp / 2, screenHeightDp / 2),
                          child: imageFile == null
                              ? Container()
                              : Image.file(imageFile!,
                                  fit: BoxFit.fitWidth,
                                  width: screenWidthDp,
                                  height: screenHeightDp),
                        ),
                      )),
                  Positioned(
                    top: 0.0,
                    bottom: 0.0,
                    left: 0.0,
                    right: 0.0,
                    child: Container(
                      alignment: Alignment.center,
                      color: widget.backColor,
                    ),
                  ),
                  Positioned(
                    top: 0.0,
                    bottom: 0.0,
                    left: 0.0,
                    right: 0.0,
                    child: _buildCanvas(),
                  ),
                  if (location != null) ...{
                    Positioned(
                      bottom: 15.0,
                      right: 10.0,
                      child: _buildLocal(),
                    ),
                  },
                  if (widget.showTop) ...{
                    Positioned(
                      top: 30.0,
                      left: 15.0,
                      child: _buildTop(),
                    )
                  },
                ],
              ),
            ),
          ),
          Positioned(
            top: 0.0,
            right: 0.0,
            child: _buildCanvasTool(screenHeightDp),
          ),
          Positioned(
            top: 0.0,
            left: 0.0,
            child: widget.enableTransform
                ? _buildTransformTool(screenHeightDp)
                : Container(),
          )
        ],
      ),
    );
  }

  Widget _buildTop() {
    return SizedBox(
      width: 200,
      child: Row(children: <Widget>[
        Container(
            width: 2,
            height: 70,
            color: Colors.white,
            alignment: Alignment.center),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                DateTime.now().getDateStr(format: "HH:mm"),
                style: MiniStyle.textTitle
                    .copyWith(color: Colors.white, fontSize: 24),
              ),
              Text(
                "${DateTime.now().getDateStr()}  ${DateTime.now().getDateStr(format: "EEEE")}",
                style: MiniStyle.textNormal.copyWith(color: Colors.white),
              ),
              Row(
                children: <Widget>[
                  Container(
                    height: 30,
                    width: 30,
                    padding: const EdgeInsets.all(5),
                    child: widget.appLogo,
                  ),
                  Text(
                    widget.appName ?? '',
                    style:
                        MiniStyle.textTag.copyWith(color: MiniColor.lightGray),
                  ),
                ],
              ),
            ],
          ),
        )
      ]),
    );
  }

  Widget _buildLocal() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        if (widget.authorName != null) ...{
          Row(
            children: <Widget>[
              const Icon(Icons.person, color: Colors.white, size: 16),
              Text(widget.authorName!,
                  softWrap: true,
                  maxLines: 2,
                  style: MiniStyle.textTag.copyWith(color: Colors.white))
            ],
          ),
          const SizedBox(height: 5),
        },
        if (location != null) ...{
          Row(
            children: <Widget>[
              const Icon(Icons.person_pin_circle,
                  color: Colors.white, size: 16),
              Text(location!,
                  softWrap: true,
                  maxLines: 2,
                  style: MiniStyle.textTag.copyWith(color: Colors.white))
            ],
          ),
        },
      ],
    );
  }

  Widget _buildCanvas() {
    return StatefulBuilder(builder: (context, state) {
      return CustomPaint(
        painter: ScrawlPainter(paints: paints),
        child: GestureDetector(
          onPanUpdate: (details) {
            RenderBox referenceBox = context.findRenderObject() as RenderBox;
            Offset localPosition =
                referenceBox.globalToLocal(details.globalPosition);
            state(() {
              paints.last.sPoint.add(localPosition);
            });
          },
          onPanStart: (details) {
            paints.add(PaintModel(
                sPoint: [],
                strokeWidth: strokeWidth,
                strokeColor: selectedColor));
          },
        ),
      );
    });
  }

  Widget _buildCanvasTool(double height) {
    return Container(
      width: 60,
      height: height,
      alignment: Alignment.center,
      child: Container(
        height: 320,
        alignment: Alignment.center,
        color: Colors.black54,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
                child: Column(
              children: <Widget>[
                GestureDetector(
                  child: Container(
                    height: 40,
                    alignment: Alignment.center,
                    child: Text(
                      '取消',
                      style: MiniStyle.textTitle.copyWith(color: Colors.white),
                    ),
                  ),
                  onTap: () => back(success: false),
                ),
                GestureDetector(
                  child: SizedBox(
                    width: 35,
                    height: 35,
                    child: Icon(
                      Icons.brightness_1,
                      size: 10.0,
                      color: selectedLine == 0
                          ? Colors.white
                          : Colors.grey.withOpacity(0.5),
                    ),
                  ),
                  onTap: () {
                    if (selectedLine == 0) return;
                    selectedLine = 0;
                    setState(() {});
                  },
                ),
                GestureDetector(
                  child: SizedBox(
                    width: 35,
                    height: 35,
                    child: Icon(
                      Icons.brightness_1,
                      size: 15.0,
                      color: selectedLine == 1
                          ? Colors.white
                          : Colors.grey.withOpacity(0.5),
                    ),
                  ),
                  onTap: () {
                    if (selectedLine == 1) return;
                    selectedLine = 1;
                    setState(() {});
                  },
                ),
                GestureDetector(
                  child: SizedBox(
                    width: 35,
                    height: 35,
                    child: Icon(
                      Icons.brightness_1,
                      size: 20.0,
                      color: selectedLine == 2
                          ? Colors.white
                          : Colors.grey.withOpacity(0.5),
                    ),
                  ),
                  onTap: () {
                    if (selectedLine == 2) return;
                    selectedLine = 2;
                    setState(() {});
                  },
                ),
                GestureDetector(
                  child: Container(
                    width: 35,
                    height: 35,
                    color: selectedColor == widget.colors[0]
                        ? Colors.grey.withOpacity(0.2)
                        : Colors.transparent,
                    child: Icon(
                      Icons.create,
                      color: widget.colors[0],
                    ),
                  ),
                  onTap: () {
                    if (selectedColor == widget.colors[0]) return;
                    selectedColor = widget.colors[0];
                    setState(() {});
                  },
                ),
                GestureDetector(
                  child: Container(
                    width: 35,
                    height: 35,
                    color: selectedColor == widget.colors[1]
                        ? Colors.grey.withOpacity(0.2)
                        : Colors.transparent,
                    child: Icon(
                      Icons.create,
                      color: widget.colors[1],
                    ),
                  ),
                  onTap: () {
                    if (selectedColor == widget.colors[1]) return;
                    selectedColor = widget.colors[1];

                    setState(() {});
                  },
                ),
              ],
            )),
            GestureDetector(
              child: SizedBox(
                height: 40,
                child: Text('重绘',
                    style:
                        MiniStyle.textTitle.copyWith(color: Colors.pinkAccent)),
              ),
              onTap: () {
                setState(() {
                  reset();
                });
              },
            ),
            GestureDetector(
              child: SizedBox(
                height: 40,
                child: Text('确认',
                    style: MiniStyle.textTitle.copyWith(color: Colors.white)),
              ),
              onTap: () {
                showProgress();
                RenderRepaintBoundary boundary = _repaintKey.currentContext!
                    .findRenderObject() as RenderRepaintBoundary;
                capturePng2List(boundary).then((Uint8List? item) {
                  closeProgress();
                  if (item == null || item.isEmpty) {
                    ToastUtil.showError('绘制失败，请退出重试！');
                    return;
                  }
                  widget.saveImage(item);
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransformTool(double height) {
    return Container(
      width: 50,
      height: height,
      alignment: Alignment.center,
      child: Container(
        height: 200,
        color: Colors.black54,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              child: const SizedBox(
                width: 35,
                height: 45,
                child: Icon(Icons.add_box, color: Colors.white),
              ),
              onTap: () {
                scale = scale + 0.1;
                setState(() {});
              },
            ),
            GestureDetector(
              child: const SizedBox(
                width: 35,
                height: 45,
                child: Icon(Icons.indeterminate_check_box, color: Colors.white),
              ),
              onTap: () {
                scale = scale - 0.1;
                setState(() {});
              },
            ),
            GestureDetector(
              child: const SizedBox(
                width: 35,
                height: 45,
                child: Icon(Icons.rotate_right, color: Colors.white),
              ),
              onTap: () {
                rotateX += pi / 2;
                setState(() {});
              },
            ),
            GestureDetector(
              child: const SizedBox(
                width: 35,
                height: 45,
                child: Icon(Icons.rotate_left, color: Colors.white),
              ),
              onTap: () {
                rotateX -= pi / 2;
                setState(() {});
              },
            ),
          ],
        ),
      ),
    );
  }

  void reset() {
    paints.clear();
  }

  Future<Uint8List?> capturePng2List(RenderRepaintBoundary boundary) async {
    ui.Image image = await boundary.toImage(pixelRatio: 3.0);
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List? pngBytes = byteData?.buffer.asUint8List();
    return pngBytes;
  }
}
