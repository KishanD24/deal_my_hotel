import 'package:flutter/material.dart';
import '../components/premium_btn_component.dart';
import '../utils/app_common.dart';
import '../utils/colors.dart';
import '../extensions/common.dart';
import '../extensions/decorations.dart';
import '../extensions/extension_util/int_extensions.dart';
import '../extensions/extension_util/widget_extensions.dart';
import '../extensions/price_widget.dart';
import '../extensions/text_styles.dart';
import '../main.dart';
import '../network/RestApis.dart';
import '../utils/images.dart';

class SuggestionComponents extends StatefulWidget {
  final String? img;
  final int? price;
  final String? name;
  final String? address;
  final int? propertyTFor;
  int? isFav;
  final int? propertyId;
  final int? isPremium;
  final Function(int)? onFavChanged;

  SuggestionComponents({
    super.key,
    this.imageFull,
    this.name,
    this.address,
    this.price,
    this.img,
    this.propertyTFor,
    this.isFav,
    this.propertyId,
    this.isPremium,
    required this.onFavChanged,
  });

  final bool? imageFull;

  @override
  State<SuggestionComponents> createState() => _SuggestionComponentsState();
}

class _SuggestionComponentsState extends State<SuggestionComponents> {
  bool select = false;

  setFavouriteApi(int? id) async {
    appStore.setLoading(true);

    Map req = {
      "property_id": id,
    };

    setFavouriteProperty(req).then((value) async {
      if (widget.isFav == 1) {
        widget.isFav = 0;
      } else {
        widget.isFav = 1;
      }

      setState(() {});

      widget.onFavChanged?.call(widget.isFav!);

      toast(value.message);
    }).catchError((error) {
      toast(error.toString());
    }).whenComplete(() => appStore.setLoading(false));
  }


  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        cachedImage(widget.img.toString(), height: 300, fit: BoxFit.fill).cornerRadiusWithClipRRect(12.0),
        Positioned(
          bottom: 8,
          left: 8,
          right: 8,
          child: Container(
            padding: EdgeInsets.all(8),
            decoration: boxDecorationWithRoundedCorners(borderRadius: BorderRadius.circular(8.0), backgroundColor: appStore.isDarkModeOn ? iconColor : primaryExtraLight),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    PriceWidget(price: formatNumberString(widget.price!), textStyle: primaryTextStyle(size: 16)).expand(),
                    Container(
                      padding: EdgeInsets.all(5),
                      decoration: boxDecorationWithRoundedCorners(borderRadius: radius(4), backgroundColor: primaryVariant),
                      child: Text(
                        widget.propertyTFor == 0
                            ? language.forRent
                            : widget.propertyTFor == 1
                                ? language.forSell
                                : language.pgCoLiving,
                        style: primaryTextStyle(size: 12, color: primaryColor),
                      ),
                    )
                  ],
                ),
                5.height,
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(ic_property, height: 18, width: 18, color: primaryColor),
                    4.width,
                    Text(widget.name.toString(), style: primaryTextStyle(color: grayColor), maxLines: 2, overflow: TextOverflow.ellipsis).expand(),
                  ],
                ),
                5.height,
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Image.asset(ic_map_point, height: 18, width: 18),
                    4.width,
                    Text(widget.address.toString(), style: secondaryTextStyle(), maxLines: 1, overflow: TextOverflow.ellipsis).expand(),
                  ],
                )
              ],
            ),
          ),
        ),
        if (userStore.subscription == "1" && widget.isPremium == 1) Positioned(left: 0, child: PremiumBtn(pDetail: false)),
        Positioned(
            right: 8.0,
            top: 8.0,
            child: fevIconWidget(widget.isFav, context).onTap(() {
              setState(() {
                setFavouriteApi(widget.propertyId);
              });
            }
            ),
        )
      ],
    );
  }
}
