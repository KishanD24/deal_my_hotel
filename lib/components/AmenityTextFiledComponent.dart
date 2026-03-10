import 'package:flutter/material.dart';
import '../extensions/extension_util/bool_extensions.dart';
import '../extensions/extension_util/string_extensions.dart';
import '../main.dart';
import '../utils/constants.dart';
import '../extensions/app_text_field.dart';
import '../extensions/decorations.dart';
import '../utils/colors.dart';

class AmenityTextFiledComponent extends StatefulWidget {
  final String? amenityValueData;
  final int? amenityID;
  final bool? isUpdate;
  final String? updatedValue;
  final String? amenityType;
  final Function(int?, String? id) onUpdate;

  AmenityTextFiledComponent({this.amenityValueData, this.amenityID, this.isUpdate = false, this.updatedValue, this.amenityType, required this.onUpdate});

  @override
  State<AmenityTextFiledComponent> createState() => _AmenityTextFiledComponentState();
}

class _AmenityTextFiledComponentState extends State<AmenityTextFiledComponent> {
  TextEditingController textBoxController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.isUpdate.validate()) {
      textBoxController.text = widget.updatedValue.validate();
    }
    setState(() {});
  }

  void sendRadioData(finalRadioId, finalRadioValue) {
    widget.onUpdate(finalRadioId, finalRadioValue);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Divider(color: dividerColor, height: 0),
        AppTextField(
          controller: textBoxController,
          textFieldType: widget.amenityType == AMENITY_TYPE_NUMBER
              ? TextFieldType.PHONE
              : widget.amenityType == AMENITY_TYPE_TEXTAREA
                  ? TextFieldType.MULTILINE
                  : TextFieldType.NAME,
          isValidationRequired: true,
          decoration: defaultInputDecoration(context, fillColor: primaryExtraLight, label: language.enter + " " + widget.amenityValueData!.validate()),
          onFieldSubmitted: (value) {
            if (textBoxController.text.isNotEmpty) {
              sendRadioData(widget.amenityID, textBoxController.text);
              setState(() {});
            }
          },
          onChanged: (v) {
            sendRadioData(widget.amenityID, textBoxController.text);
            setState(() {});
          },
        )
      ],
    );
  }
}
