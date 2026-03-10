import 'package:flutter/material.dart';
import 'package:mighty_properties/extensions/extension_util/bool_extensions.dart';
import 'package:mighty_properties/extensions/extension_util/list_extensions.dart';
import '../extensions/extension_util/int_extensions.dart';
import '../extensions/extension_util/string_extensions.dart';
import '../extensions/text_styles.dart';
import '../utils/colors.dart';

class RadioComponent extends StatefulWidget {
  final List<dynamic>? radioValues;
  final int? amenityId;
  final Function(int?, String?) onUpdate;
  final String? selectedRadioValue;
  final bool? isUpdateProperty;

  RadioComponent({this.radioValues, this.amenityId, required this.onUpdate, this.selectedRadioValue, this.isUpdateProperty = false});

  @override
  State<RadioComponent> createState() => _RadioComponentState();
}

class _RadioComponentState extends State<RadioComponent> {
  int? currentRIndex;
  int? finalRadioId;
  String? finalRadioValue;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    print(currentRIndex);
    print(widget.selectedRadioValue);
    widget.radioValues!.forEach((element) {
      if (widget.selectedRadioValue == element) currentRIndex = widget.radioValues!.indexOf(element);
    });

    setState(() {});
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  void sendRadioData() {
    widget.onUpdate(finalRadioId.validate(), finalRadioValue.validate());
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      primary: true,
      shrinkWrap: true,
      padding: EdgeInsets.only(bottom: 16, top: 0),
      itemCount: widget.radioValues!.length,
      itemBuilder: (BuildContext context, int i) {
        return RadioListTile(
          dense: true,
          value: i,
          selected: true,
          fillColor: MaterialStateProperty.all(primaryColor),
          activeColor: primaryColor,
          groupValue: currentRIndex,
          title: Text(widget.radioValues![i].toString().capitalizeFirstLetter(), style: primaryTextStyle(size: 16)),
          onChanged: (dynamic val) {
            currentRIndex = val;
            finalRadioId = widget.amenityId;
            finalRadioValue = widget.radioValues![i].toString().replaceAll('[', '').replaceAll(']', '');
            sendRadioData();
            setState(() {});
          },
        );
      },
    );
  }
}
