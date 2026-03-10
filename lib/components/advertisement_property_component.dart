import 'package:flutter/material.dart';
import '../extensions/colors.dart';
import '../extensions/extension_util/context_extensions.dart';
import '../extensions/extension_util/int_extensions.dart';
import '../extensions/extension_util/string_extensions.dart';
import '../extensions/extension_util/widget_extensions.dart';
import '../utils/app_common.dart';
import '../utils/images.dart';
import '../extensions/common.dart';
import '../extensions/decorations.dart';
import '../extensions/price_widget.dart';
import '../extensions/text_styles.dart';
import '../main.dart';
import '../models/dashBoard_response.dart';
import '../network/RestApis.dart';
import '../utils/colors.dart';
import 'premium_btn_component.dart';

class AdvertisementPropertyComponent extends StatefulWidget {
  final Property? property;
  final bool? isFullWidth;
  final Function? onCall;

  AdvertisementPropertyComponent({this.property, this.isFullWidth = false, this.onCall});

  @override
  State<AdvertisementPropertyComponent> createState() => _AdvertisementPropertyComponentState();
}

class _AdvertisementPropertyComponentState extends State<AdvertisementPropertyComponent> {
  setFavouriteApi(int? id) async {
    appStore.setLoading(true);
    Map req = {
      "property_id": id,
    };
    setFavouriteProperty(req).then((value) {
      appStore.setLoading(false);

      if (widget.property!.isFavourite == 1) {
        widget..property!.isFavourite = 0;
      } else {
        widget..property!.isFavourite = 1;
      }
      widget.onCall!.call();
      toast(value.message);
      setState(() {});
    }).catchError((error) {
      appStore.setLoading(false);
    });

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.isFullWidth == true ? context.width() : context.width() * 0.8,
      height: 150,
      decoration: boxDecorationWithRoundedCorners(
        borderRadius: radius(12),
        backgroundColor: appStore.isDarkModeOn ? cardDarkColor : primaryExtraLight,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              cachedImage(widget.property!.propertyImage.validate(), height: 150, fit: BoxFit.cover, width: 130).cornerRadiusWithClipRRectOnly(topLeft: 12, bottomLeft: 12),
              if (userStore.subscription == "1" && widget.property!.premiumProperty == 1) Positioned(top: 0, left: 0, child: PremiumBtn(pDetail: true)),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  PriceWidget(price: formatNumberString(widget.property!.price.validate()), textStyle: boldTextStyle(size: 18, color: primaryColor)).expand(),
                  fevIconWidget(widget.property!.isFavourite, context).onTap(() {
                    setState(() {
                      setFavouriteApi(widget.property!.id);
                    });
                  }
                  ),
                ],
              ),
              2.height,
              Text(widget.property!.name.validate().capitalizeFirstLetter(), style: primaryTextStyle(size: 16, color: appStore.isDarkModeOn ? lightBackgroundColor : Colors.black)),
              8.height,
              Row(
                children: [
                  Image.asset(ic_property, height: 18, width: 18, color: primaryColor),
                  4.width,
                  Text(widget.property!.category.validate(), style: secondaryTextStyle()),
                ],
              ),
              8.height,
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(ic_map_point, width: 16, height: 16, color: grey),
                  4.width,
                  Text(widget.property!.address.validate(), maxLines: 3, overflow: TextOverflow.ellipsis, style: secondaryTextStyle()).expand(),
                ],
              ),
            ],
          ).paddingSymmetric(horizontal: 14, vertical: 8).expand(),
        ],
      ),
    );
  }
}
