import 'package:flutter/material.dart';
import '../extensions/extension_util/context_extensions.dart';
import '../extensions/price_widget.dart';
import '../extensions/decorations.dart';
import '../extensions/extension_util/int_extensions.dart';
import '../extensions/extension_util/widget_extensions.dart';
import '../extensions/text_styles.dart';
import '../utils/app_common.dart';
import '../utils/colors.dart';

class SubscriptionComponents extends StatefulWidget {
  SubscriptionComponents(
      {super.key,
      required this.mainTitle,
      required this.mainSubTitle,
      required this.price,
      required this.title1,
      required this.title2,
      required this.title3,
      required this.backgroundColor,
      required this.textColor,
      required this.subColor});

  final String mainTitle;
  final String mainSubTitle;
  final int price;
  final String title1;
  final String title2;
  final String title3;
  final Color backgroundColor;
  final Color textColor;
  final Color subColor;

  @override
  State<SubscriptionComponents> createState() => _SubscriptionComponentsState();
}

class _SubscriptionComponentsState extends State<SubscriptionComponents> {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: context.width(),
        margin: EdgeInsets.only(bottom: 16),
        decoration: boxDecorationDefault(color: widget.backgroundColor, borderRadius: BorderRadius.circular(6.0)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(widget.mainTitle, style: primaryTextStyle(color: widget.textColor, size: 20)),
          5.height,
          Text("${widget.mainSubTitle}", style: boldTextStyle(color: widget.subColor, size: 16)),
          Container(
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.all(10),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: primaryColor, width: 1.0), // Set border width
                borderRadius: radius(10), // Set rounded corner radius
                boxShadow: [BoxShadow(blurRadius: 10, color: widget.backgroundColor, offset: Offset(1, 3))] // Make rounded corner of border
                ),
            child: PriceWidget(price: formatNumberString(widget.price), textStyle: boldTextStyle(size: 20)).paddingSymmetric(horizontal: 60),
          ).paddingSymmetric(vertical: 20.0, horizontal: 16),
        ])).paddingSymmetric(horizontal: 28);
  }

  titleWidget(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.circle, size: 8, color: widget.textColor),
        5.width,
        Text(text, style: primaryTextStyle(size: 14, color: widget.textColor)),
      ],
    );
  }
}
