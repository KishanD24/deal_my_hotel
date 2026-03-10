import 'package:flutter/material.dart';
import '../extensions/extension_util/bool_extensions.dart';
import '../extensions/extension_util/string_extensions.dart';
import '../extensions/extension_util/widget_extensions.dart';
import '../extensions/text_styles.dart';

class DropDownComponent extends StatefulWidget {
  final int? amenityId;
  final Function(int?, String?) onUpdate;
  final List<dynamic>? dropdownValues;
  final bool? isUpdateProperty;
  final dynamic selectedDropDownValue;

  const DropDownComponent({this.dropdownValues, this.amenityId, required this.onUpdate, this.selectedDropDownValue, this.isUpdateProperty});

  @override
  State<DropDownComponent> createState() => _DropDownComponentState();
}

class _DropDownComponentState extends State<DropDownComponent> {
  int? finalDropDownId;
  String? finalDropDownValue;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    setState(() {});

    widget.dropdownValues!.map((e) => print(e)).toList();
    if (widget.isUpdateProperty.validate()) {
      finalDropDownValue = !widget.selectedDropDownValue.toString().isEmptyOrNull ? widget.selectedDropDownValue : widget.dropdownValues!.first;
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  void sendRadioData() {
    widget.onUpdate(finalDropDownId!, finalDropDownValue!);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        DropdownButtonFormField<String>(
            decoration: InputDecoration(enabledBorder: InputBorder.none, focusedBorder: InputBorder.none),
            value: finalDropDownValue ?? widget.dropdownValues!.first,
            onChanged: (value) {
              finalDropDownId = widget.amenityId;
              finalDropDownValue = value;
              sendRadioData();
              setState(() {});
            },
            items: widget.dropdownValues!.map<DropdownMenuItem<String>>((value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value, style: primaryTextStyle()).paddingSymmetric(horizontal: 10),
              );
            }).toList()),
      ],
    ).paddingSymmetric(horizontal: 16);
  }
}
