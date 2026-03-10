import 'package:flutter/material.dart';
import '../components/premium_btn_component.dart';
import '../extensions/colors.dart';
import '../extensions/extension_util/context_extensions.dart';
import '../extensions/extension_util/string_extensions.dart';
import '../extensions/extension_util/widget_extensions.dart';
import '../extensions/price_widget.dart';
import '../extensions/common.dart';
import '../extensions/decorations.dart';
import '../extensions/extension_util/int_extensions.dart';
import '../extensions/text_styles.dart';
import '../main.dart';
import '../models/dashBoard_response.dart';
import '../network/RestApis.dart';
import '../utils/app_common.dart';
import '../utils/colors.dart';
import '../utils/images.dart';

class PropertyComponents extends StatefulWidget {
  final Property? property;

  //  final String? propertyName;
  //  final String? propertyCategory;
  //  final int? propertyTFor;
  //  final String? propertyAddress;
  //  final String? propertyImg;
  //  final int? propertyPrice;
  // final int? isFav;
  //  final int? propertyId;
  //  final int? isPremium;

  PropertyComponents(
      {
      // this.propertyImg,
      // this.propertyCategory,
      // this.propertyPrice,
      // this.propertyName,
      // this.propertyAddress,
      // this.propertyTFor,
      // this.isFav,
      // this.propertyId,
      // this.isPremium,
      this.property});

  @override
  State<PropertyComponents> createState() => _PropertyComponentsState();
}

class _PropertyComponentsState extends State<PropertyComponents> {
  bool select = true;

  setFavouriteApi(int? id) async {
    appStore.setLoading(true);
    Map req = {
      "property_id": id,
    };
    setFavouriteProperty(req).then((value) {
      appStore.setLoading(false);
      if (widget.property!.isFavourite == 1) {
        widget.property!.isFavourite = 0;
      } else {
        widget.property!.isFavourite = 1;
      }
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
      decoration: boxDecorationRoundedWithShadow(12, backgroundColor: appStore.isDarkModeOn ? cardDarkColor : primaryExtraLight),
      width: MediaQuery.of(context).size.width * 0.6,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              cachedImage(widget.property!.propertyImage, fit: BoxFit.cover, width: MediaQuery.of(context).size.width * 0.6, height: 140).cornerRadiusWithClipRRectOnly(topRight: 12, topLeft: 12),
              Positioned(
                left: 8,
                right: 8,
                top: 8,
                child: Row(
                  mainAxisAlignment: userStore.subscription == "1" && widget.property!.premiumProperty == 1 ? MainAxisAlignment.spaceBetween :MainAxisAlignment.end,
                  children: [
                    if (userStore.subscription == "1" && widget.property!.premiumProperty == 1) PremiumBtn(pDetail: false),
                    fevIconWidget(widget.property!.isFavourite,context).onTap(() {
                      setState(() {
                        setFavouriteApi(widget.property!.id);
                      });
                    }),
                  ],
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  PriceWidget(price: formatNumberString(widget.property!.price.validate()), textStyle: boldTextStyle(size: 18, color: primaryColor)).expand(),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                    decoration: boxDecorationWithRoundedCorners(borderRadius: radius(4), backgroundColor: context.cardColor),
                    child: Text(
                      widget.property!.propertyFor == 0
                          ? language.forRent
                          : widget.property!.propertyFor == 1
                              ? language.forSell
                              : language.pgCoLiving,
                      style: primaryTextStyle(size: 12, color: primaryColor),
                    ),
                  )
                ],
              ),
              4.height,
              Text(widget.property!.name.toString().capitalizeFirstLetter(), style: primaryTextStyle(size: 16)),
              4.height,
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(ic_property, height: 18, width: 18,color: primaryColor),
                  4.width,
                  Text(widget.property!.category.toString(), style: secondaryTextStyle()),
                ],
              ),
              4.height,
              if (!widget.property!.address.isEmptyOrNull)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Image.asset(ic_map_point, height: 18, width: 18),
                    4.width,
                    Text(widget.property!.address.toString(), style: secondaryTextStyle(), maxLines: 1, overflow: TextOverflow.ellipsis).expand(),
                  ],
                )
            ],
          ).paddingAll(8)
        ],
      ),
    );
  }
}
