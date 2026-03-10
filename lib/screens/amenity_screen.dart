import 'package:flutter/material.dart';
import '../extensions/colors.dart';
import '../extensions/extension_util/int_extensions.dart';
import '../extensions/extension_util/widget_extensions.dart';
import '../main.dart';
import '../models/category_list_model.dart';
import '../extensions/decorations.dart';
import '../extensions/text_styles.dart';
import '../utils/app_common.dart';
import '../utils/colors.dart';

class AmenityScreen extends StatefulWidget {
  final List<AmenityName> amenityValue;

  const AmenityScreen({required this.amenityValue});

  @override
  State<AmenityScreen> createState() => _AmenityScreenState();
}

class _AmenityScreenState extends State<AmenityScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(language.extraFacilities, style: boldTextStyle(size: 18)).paddingSymmetric(horizontal: 16),
        8.height,
        ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: 16),
          physics: ScrollPhysics(),
          itemCount: widget.amenityValue.length,
          shrinkWrap: true,
          itemBuilder: (context, i) {
            return Container(
              margin: EdgeInsets.only(bottom: 8),
              padding: EdgeInsets.all(12),
              decoration: boxDecorationWithRoundedCorners(borderRadius: radius(8.0), backgroundColor: appStore.isDarkModeOn ? cardDarkColor : primaryExtraLight),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  cachedImage(widget.amenityValue[i].amenityImage.toString(), fit: BoxFit.fill, height: 24, width: 24, color: Colors.grey),
                  8.width,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(widget.amenityValue[i].name.toString(), style: boldTextStyle(size: 13)),
                      2.height,
                      Text(widget.amenityValue[i].value.toString().replaceAll('[', '').replaceAll(']', ''), style: secondaryTextStyle(size: 12)),
                    ],
                  ).expand()
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
