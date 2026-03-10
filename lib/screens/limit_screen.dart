import 'package:flutter/material.dart';
import '../components/app_bar_components.dart';
import '../extensions/colors.dart';
import '../extensions/common.dart';
import '../extensions/decorations.dart';
import '../extensions/extension_util/context_extensions.dart';
import '../extensions/extension_util/int_extensions.dart';
import '../extensions/extension_util/widget_extensions.dart';
import '../extensions/price_widget.dart';
import '../extensions/text_styles.dart';
import '../main.dart';
import '../screens/payment_screen.dart';
import '../utils/colors.dart';
import '../utils/images.dart';
import '../extensions/app_button.dart';
import '../extensions/widgets.dart';
import '../models/limit_property_response.dart';
import '../network/RestApis.dart';
import '../utils/app_common.dart';

class LimitScreen extends StatefulWidget {
  final String? limit;

  LimitScreen({super.key, this.limit});

  @override
  State<LimitScreen> createState() => _LimitScreenState();
}

class _LimitScreenState extends State<LimitScreen> {
  bool select = false;
  int _selectedIndex = -1;
  String? title;
  int? paymentId;
  num? paymentPrice;

  @override
  void initState() {
    super.initState();
    if (widget.limit == "add_property") {
      title = language.addPropertyLimit;
    } else if (widget.limit == "view_property") {
      title = language.contactInfoLimit;
    } else if (widget.limit == "advertisement_property") {
      title = language.addAdvertisementLimit;
    } else {
      title = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(title.toString(), context1: context, titleSpace: 0),
      bottomNavigationBar: AppButton(
        text: language.purchase,
        width: context.width(),
        color: primaryColor,
        elevation: 0,
        onTap: () {
          if (_selectedIndex != -1) {
            PaymentScreen(
              id: paymentId,
              price: paymentPrice,
              isFromLimit: true,
            ).launch(context);
          } else {
            toast(language.pleaseSelectLimit);
          }
        },
      ).paddingOnly(right: 16, bottom: 16, left: 16, top: 0),
      body: FutureBuilder(
          future: getExtraPropertyLimit(widget.limit),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              LimitPropertyResponse mLimitPropertyResponse = snapshot.data!;
              return ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  shrinkWrap: true,
                  itemCount: mLimitPropertyResponse.data!.length,
                  itemBuilder: (context, i) {
                    return Container(
                      margin: EdgeInsets.only(bottom: 16),
                      padding: EdgeInsets.all(16),
                      decoration: boxDecorationWithRoundedCorners(
                          borderRadius: radius(8),
                          backgroundColor: appStore.isDarkModeOn
                              ? _selectedIndex == i
                                  ? primaryVariant
                                  : cardDarkColor
                              : _selectedIndex == i
                                  ? primaryVariant
                                  : primaryExtraLight),
                      child: Row(children: [
                        Image.asset(_selectedIndex == i ? ic_radio_fill : ic_radio, height: 18, width: 18,
                            color: primaryColor
                        ),
                        10.width,
                        Text(mLimitPropertyResponse.data![i].limit.toString() + " " + language.limit,
                                style: primaryTextStyle(
                                    color: appStore.isDarkModeOn
                                        ? _selectedIndex == i
                                            ? Colors.black
                                            : cardLightColor
                                        : Colors.black))
                            .expand(),
                        PriceWidget(
                            price: formatNumberString(mLimitPropertyResponse.data![i].price!),
                            textStyle: boldTextStyle(
                                size: 18,
                                color: appStore.isDarkModeOn
                                    ? _selectedIndex == i
                                        ? Colors.black
                                        : Colors.white
                                    : _selectedIndex == i
                                        ? Colors.black
                                        : Colors.black)),
                      ]),
                    ).onTap(() {
                      paymentId = mLimitPropertyResponse.data![i].id;
                      paymentPrice = mLimitPropertyResponse.data![i].price;
                      select = !select;
                      _selectedIndex = i;
                      setState(() {});
                    });
                  });
            }
            return snapWidgetHelper(snapshot);
          }),
    );
  }
}
