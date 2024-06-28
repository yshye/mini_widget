import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../model/tag_cell_type.dart';
import '../model/tag_edit_model.dart';
import 'us_number_text_input_formatter.dart';

class EditCell extends StatelessWidget {
  final EdgeInsetsGeometry padding;
  final double minHeight;
  final bool showCounter;
  final EditValueModel data;
  final String? allowSource;

  const EditCell({
    super.key,
    this.padding = const EdgeInsets.all(1),
    this.minHeight = 40,
    required this.data,
    this.showCounter = true,
    this.allowSource,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          alignment: Alignment.topLeft,
          padding: padding,
          color: data.color,
          child: data.tag2 == null
              ? _buildOneItem(
                  context,
                  showCounter: showCounter,
                  hintText: data.hintText,
                  valueColor: data.valueColor,
                  fontSize: data.fontSize,
                  tagWidth: data.tagWidth,
                  isEdit: data.isEdit,
                  required: data.required,
                  tag: data.tag,
                  tagColor: data.tagColor,
                  suffix: data.suffix,
                  controller: data.controller,
                  inputType: data.inputType,
                  child: data.child,
                  valueMaxLines: data.maxLines,
                  minHeight: minHeight,
                  maxLength: data.maxLength,
                  maxNum: data.maxNum,
                  placesLength: data.placesLength,
                  onlyNumValue: data.onlyNumValue,
                  style: data.style,
                  direction: data.direction,
                  allowSource: allowSource,
                )
              : _buildTwoItem(
                  context,
                  fontSize: data.fontSize ?? 14,
                  suffix: data.suffix,
                  suffix2: data.suffix2,
                  valueMaxLines: data.maxLines,
                  valueColor: data.valueColor,
                  valueColor2: data.valueColor2,
                  tagWidth: data.tagWidth,
                  tagWidth2: data.tagWidth2,
                  isEdit: data.isEdit,
                  isEdit2: data.isEdit2,
                  required: data.required,
                  required2: data.required2,
                  tag: data.tag,
                  tag2: data.tag2,
                  tagColor: data.tagColor,
                  tagColor2: data.tagColor2,
                  controller: data.controller,
                  controller2: data.controller2,
                  inputType: data.inputType,
                  inputType2: data.inputType2,
                  hintText: data.hintText,
                  hintText2: data.hintText2,
                  minHeight: minHeight,
                  maxLength: data.maxLength,
                  maxLength2: data.maxLength2,
                  maxNum: data.maxNum,
                  maxNum2: data.maxNum2,
                  placesLength2: data.placesLength2,
                  placesLength: data.placesLength,
                  onlyNumValue2: data.onlyNumValue2,
                  onlyNumValue: data.onlyNumValue,
                ),
        ),
        data.showLine ? const Divider(height: 0.5) : Container(height: 0),
      ],
    );
  }

  _buildTwoItem(
    BuildContext context, {
    String? tag,
    double? tagWidth = 90,
    String? tag2,
    double? tagWidth2 = 90,
    double? minHeight = 40,
    String? suffix,
    String? suffix2,
    Color? tagColor = Colors.grey,
    Color? tagColor2 = Colors.grey,
    Color? valueColor = Colors.black,
    Color? valueColor2 = Colors.black,
    FocusNode? focusNode,
    FocusNode? focusNode2,
    bool required = false,
    bool required2 = false,
    int? valueMaxLines = 1,
    int? maxLength,
    int? maxLength2,
    bool isEdit = true,
    bool isEdit2 = true,
    TextEditingController? controller,
    TextEditingController? controller2,
    ValueChanged<String>? onChange,
    ValueChanged<String>? onChange2,
    TextInputType? inputType = TextInputType.text,
    TextInputType? inputType2 = TextInputType.text,
    InputDecoration? inputDecoration,
    InputDecoration? inputDecoration2,
    String? hintText,
    String? hintText2,
    double fontSize = 16,
    num? maxNum,
    num? maxNum2,
    int? placesLength,
    int? onlyNumValue,
    int? placesLength2,
    int? onlyNumValue2,
  }) {
    return Flex(direction: Axis.horizontal, children: <Widget>[
      Container(
        width: tagWidth,
        height: minHeight,
        alignment: Alignment.topLeft,
        child: Row(
          children: <Widget>[
            Expanded(
                flex: 1,
                child: Text(
                  tag ?? '',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(
                      color: tagColor, height: 1.1, fontSize: fontSize),
                )),
            required
                ? Icon(MdiIcons.multiplication, size: 8, color: Colors.red)
                : Container(),
          ],
        ),
      ),
      Expanded(
        flex: 1,
        child: Padding(
          padding: const EdgeInsets.only(top: 5.0, bottom: 5),
          child: TextField(
            maxLines: valueMaxLines,
            enabled: isEdit,
            focusNode: focusNode,
            enableInteractiveSelection: isEdit,
            controller: controller,
            // maxLengthEnforced: true,
            onChanged: onChange,
            keyboardType: inputType,
            maxLength: maxLength,
            inputFormatters: getInputFormatter(
              inputType ?? TextInputType.text,
              maxLength: maxLength,
              maxNum: maxNum,
              placesLength: placesLength,
              onlyNumValue: onlyNumValue,
            ),
            decoration: inputDecoration ??
                InputDecoration(
                    hintText: hintText ?? '请填写$tag',
                    border: isEdit ? null : InputBorder.none,
                    contentPadding: const EdgeInsets.only(left: 3),
                    suffixStyle: const TextStyle(color: Colors.black87),
                    suffixText: suffix ?? ''),
            style:
                TextStyle(height: 1.1, fontSize: fontSize, color: valueColor),
          ),
        ),
      ),
      Container(
        width: tagWidth2,
        height: minHeight,
        padding: const EdgeInsets.only(left: 3),
        alignment: Alignment.topLeft,
        child: Row(
          children: <Widget>[
            Expanded(
                flex: 1,
                child: Text(
                  tag2 ?? '',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(color: tagColor2, height: 1.1),
                )),
            required2
                ? Icon(MdiIcons.multiplication, size: 8, color: Colors.red)
                : Container(),
          ],
        ),
      ),
      Expanded(
        flex: 1,
        child: Padding(
          padding: const EdgeInsets.only(top: 5.0, bottom: 5),
          child: TextField(
            maxLines: valueMaxLines,
            enabled: isEdit,
            focusNode: focusNode2,
            enableInteractiveSelection: isEdit,
            controller: controller2,
            // maxLengthEnforced: true,
            onChanged: onChange2,
            maxLength: maxLength2,
            keyboardType: inputType2,
            inputFormatters: getInputFormatter(
              inputType2 ?? TextInputType.text,
              maxLength: maxLength2,
              maxNum: maxNum2,
              placesLength: placesLength2,
              onlyNumValue: onlyNumValue2,
            ),
            decoration: inputDecoration2 ??
                InputDecoration(
                  hintText: hintText2 ?? '请填写$tag2',
                  border: isEdit2 ? null : InputBorder.none,
                  contentPadding: const EdgeInsets.only(left: 3),
                  suffixText: suffix2 ?? '',
                  suffixStyle: const TextStyle(color: Colors.black87),
                ),
            style: TextStyle(height: 1.1, fontSize: 14, color: valueColor2),
          ),
        ),
      ),
    ]);
  }

  _buildOneItem(
    BuildContext context, {
    String? tag,
    String? suffix,
    bool showCounter = true,
    double? tagWidth = 90,
    double? minHeight = 40,
    int? maxLength,
    Color? valueColor = Colors.black,
    Color? tagColor = Colors.grey,
    bool required = false,
    int? valueMaxLines = 1,
    bool isEdit = true,
    FocusNode? focusNode,
    // KeyboardActionsConfig config,
    TextEditingController? controller,
    ValueChanged<String>? onChange,
    TextInputType? inputType = TextInputType.text,
    InputDecoration? inputDecoration,
    String? hintText,
    double? fontSize = 16,
    Widget? child,
    num? maxNum,
    int? placesLength,
    int? onlyNumValue,
    TagCellStyle? style = TagCellStyle.style2,
    Axis? direction = Axis.horizontal,
    String? allowSource,
  }) {
    Widget tagWidget = Container(
      width: tagWidth,
      height: minHeight,
      alignment: Alignment.centerLeft,
      child: Row(
        children: <Widget>[
          required
              ? Icon(MdiIcons.multiplication, size: 8, color: Colors.red)
              : Container(),
          const SizedBox(width: 5),
          Expanded(
            child: Text(
              tag ?? '',
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style:
                  TextStyle(color: tagColor, height: 1.1, fontSize: fontSize),
            ),
          ),
        ],
      ),
    );
    Widget contentWidget = child ??
        Container(
          alignment: Alignment.topLeft,
          padding: const EdgeInsets.only(top: 5.0, bottom: 5),
          child: (!isEdit)
              ? SelectableText(
                  controller?.text ?? '',
                  cursorColor: Colors.blue,
                  style: const TextStyle(fontSize: 16, height: 1.4),
                  // TODO 选择和复制
                  // toolbarOptions: const ToolbarOptions(
                  //   copy: true,
                  //   selectAll: true,
                  // ),
                  // contextMenuBuilder: (ctx,state){
                  //
                  // },
                  textAlign: style == TagCellStyle.style1
                      ? TextAlign.left
                      : TextAlign.right,
                )
              : TextField(
                  maxLines: valueMaxLines,
                  focusNode: focusNode,
                  enabled: isEdit,
                  enableInteractiveSelection: isEdit,
                  // maxLengthEnforced: true,
                  controller: controller,
                  onChanged: onChange,
                  keyboardType: inputType,
                  // (valueMaxLines != null && valueMaxLines > 1) ? TextInputType.multiline : inputType,
                  maxLength: maxLength,
                  textAlign: style == TagCellStyle.style1
                      ? TextAlign.left
                      : TextAlign.right,
                  inputFormatters: getInputFormatter(
                    inputType ?? TextInputType.text,
                    maxLength: maxLength,
                    maxNum: maxNum,
                    onlyNumValue: onlyNumValue,
                    placesLength: placesLength,
                    allowSource: allowSource,
                  ),
                  textAlignVertical: TextAlignVertical.top,
                  decoration: inputDecoration ??
                      InputDecoration(
                          hintText: hintText ?? '请填写$tag',
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.only(left: 4),
                          labelStyle: TextStyle(fontSize: fontSize),
                          hintStyle: TextStyle(
                              fontSize: fontSize,
                              height: 1.1,
                              color: const Color(0xffd2d2d2)),
                          suffixText: suffix ?? '',
                          counterStyle: TextStyle(
                            fontSize: fontSize,
                            color: valueColor,
                          ),
                          counterText: showCounter ? null : ''),
                  style: TextStyle(
                      height: 1.1, fontSize: fontSize, color: valueColor),
                ),
        );

    return direction == Axis.horizontal
        ? Row(children: <Widget>[
            tagWidget,
            Expanded(child: contentWidget),
            const SizedBox(width: 5)
          ])
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
                tagWidget,
                const SizedBox(height: 5),
                contentWidget
              ]);
  }
}

// enum TagCellStyle { style1, style2 }
