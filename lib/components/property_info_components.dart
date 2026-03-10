import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import '../extensions/extension_util/string_extensions.dart';
import '../models/property_details_model.dart';
import '../extensions/extension_util/int_extensions.dart';
import '../extensions/text_styles.dart';
import '../main.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';

class PropertyInfoComponents extends StatefulWidget {
  PropertyInfoComponents({super.key, required this.property});

  final PropertyDetail property;

  @override
  State<PropertyInfoComponents> createState() => _PropertyInfoComponentsState();
}

class _PropertyInfoComponentsState extends State<PropertyInfoComponents> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            Text("₹ ${widget.property.price}", style: primaryTextStyle(size: 16)),
            Icon(Ionicons.md_heart, size:20 ,color: primaryColor),
          ],
        ),
        Text("(₹ ${widget.property.securityDeposit})", style: primaryTextStyle(size: 16)),
        Text(widget.property.bhk.toString(), style: secondaryTextStyle()),
        Text(widget.property.address.validate(), style: secondaryTextStyle()),
        4.height,
        Row(
          children: [
            Text(
                (widget.property.furnishedType == FurnishedType.UNFURNISHED.furnishedTypeIndex)
                    ? UNFURNISHED
                    : widget.property.furnishedType == FurnishedType.FULLY.furnishedTypeIndex
                        ? FULLY
                        : SEMI,
                style: primaryTextStyle(color: appStore.isDarkModeOn ? lightBackgroundColor : Colors.black, size: 16)),
            10.width,
            Text(widget.property.sqft.validate(), style: primaryTextStyle(size: 16)),
          ],
        ),
      ],
    );
  }
}
