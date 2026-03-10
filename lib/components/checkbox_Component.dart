import 'package:flutter/material.dart';
import '../extensions/extension_util/bool_extensions.dart';
import '../extensions/extension_util/context_extensions.dart';
import '../extensions/extension_util/int_extensions.dart';
import '../extensions/extension_util/widget_extensions.dart';
import '../extensions/animatedList/animated_wrap.dart';
import '../extensions/decorations.dart';
import '../extensions/text_styles.dart';
import '../utils/colors.dart';

class CheckBoxComponent<T> extends StatefulWidget {
  final int? amenityId;
  final int? propertyId;
  final int? pId;
  final List<dynamic>? checkboxValues;
  final List<dynamic>? newCheckboxValues;

  final bool? isUpdateProperty;

  final Function(List<String>?, int? id) onUpdate;

  const CheckBoxComponent({this.checkboxValues, this.amenityId, required this.onUpdate, this.propertyId, this.pId, this.newCheckboxValues, this.isUpdateProperty = false});

  @override
  State<CheckBoxComponent> createState() => _CheckBoxComponentState();
}

class _CheckBoxComponentState<T> extends State<CheckBoxComponent<T>> {
  int? finalCheckBoxId;
  List<dynamic> selectedIndexes = [];
  List<String> checkBoxQuotedStrings = [];

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    if (widget.isUpdateProperty.validate() && widget.newCheckboxValues!.isNotEmpty) selectedIndexes = widget.newCheckboxValues!;
    setState(() {});
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  void sendRadioData(List<String>? data, int? cId) {
    widget.onUpdate(data!, finalCheckBoxId!);
  }

  void checkBoxSelection(String value) {
    if (selectedIndexes.contains(value)) {
      selectedIndexes.remove(value);
    } else {
      selectedIndexes.add(value);
    }
    checkBoxQuotedStrings = selectedIndexes.map((str) => '"$str"').toList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedWrap(
            runSpacing: 8,
            spacing: 8,
            crossAxisAlignment: WrapCrossAlignment.start,
            alignment: WrapAlignment.start,
            runAlignment: WrapAlignment.start,
            children: widget.checkboxValues!.map((e) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: boxDecorationWithRoundedCorners(backgroundColor: selectedIndexes.contains(e) ? primaryColor : context.scaffoldBackgroundColor, borderRadius: BorderRadius.circular(8.0)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(selectedIndexes.contains(e) ? Icons.check : Icons.add, color: selectedIndexes.contains(e) ? Colors.white : grayColor),
                    10.width,
                    Text(e.toString(), style: secondaryTextStyle(size: 16, color: selectedIndexes.contains(e) ? Colors.white : grayColor)),
                  ],
                ),
              ).onTap(() {
                checkBoxSelection(e);
                finalCheckBoxId = widget.amenityId;
                sendRadioData((checkBoxQuotedStrings), finalCheckBoxId);
                setState(() {});
              });
            }).toList()),
        16.height
      ],
    );
  }
}
