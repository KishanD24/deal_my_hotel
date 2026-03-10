import 'package:flutter/material.dart';
import '../components/premium_btn_component.dart';
import '../extensions/extension_util/context_extensions.dart';
import '../extensions/extension_util/int_extensions.dart';
import '../extensions/extension_util/string_extensions.dart';
import '../main.dart';
import '../utils/app_common.dart';
import '../extensions/extension_util/widget_extensions.dart';
import '../extensions/decorations.dart';
import '../extensions/text_styles.dart';
import '../models/dashBoard_response.dart';
import '../utils/colors.dart';

class OtherPropertyComponents extends StatefulWidget {
  // final String? img;
  // final String? name;
  // final String? property;
  // final int? isPremium;

  final OwnerProperty? ownerProperty;

  OtherPropertyComponents({/*this.img, this.name, this.property, this.isPremium,*/ this.ownerProperty});

  @override
  State<OtherPropertyComponents> createState() => _OtherPropertyComponentsState();
}

class _OtherPropertyComponentsState extends State<OtherPropertyComponents> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: boxDecorationWithRoundedCorners(backgroundColor: appStore.isDarkModeOn ? iconColor : primaryExtraLight, borderRadius: BorderRadius.circular(12)),
      width: (context.width() - 50) / 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              cachedImage(widget.ownerProperty!.propertyImage.validate(), fit: BoxFit.fill, height: 120, width: (context.width() - 50) / 2).cornerRadiusWithClipRRectOnly(topLeft: 12, topRight: 12),
              if (userStore.subscription == "1" && widget.ownerProperty!.premiumProperty == 1) Positioned(top: 10, left: 10, child: PremiumBtn(pDetail: false)),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.ownerProperty!.name.validate().capitalizeFirstLetter(), style: primaryTextStyle(color: appStore.isDarkModeOn ? selectIconColor : scaffoldColorDark, size: 16)),
              2.height,
              Text(widget.ownerProperty!.category.validate(), style: primaryTextStyle(color: primaryColor, size: 14))
            ],
          ).paddingAll(10),
        ],
      ),
    );
  }
}
