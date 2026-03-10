import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../components/HtmlWidget.dart';
import '../extensions/decorations.dart';
import '../extensions/extension_util/context_extensions.dart';
import '../extensions/extension_util/int_extensions.dart';
import '../extensions/extension_util/string_extensions.dart';
import '../extensions/extension_util/widget_extensions.dart';
import '../utils/colors.dart';
import '../utils/images.dart';
import '../components/app_bar_components.dart';
import '../extensions/text_styles.dart';
import '../main.dart';
import '../models/dashBoard_response.dart';
import '../utils/app_common.dart';
import 'property_detail_screen.dart';

class SliderDetailsScreen extends StatefulWidget {
  final MSlider slider;

  const SliderDetailsScreen({super.key, required this.slider});

  @override
  State<SliderDetailsScreen> createState() => _SliderDetailsScreenState();
}

class _SliderDetailsScreenState extends State<SliderDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: appStore.isDarkModeOn ? Brightness.light : Brightness.light,
        systemNavigationBarIconBrightness: appStore.isDarkModeOn ? Brightness.light : Brightness.light,
      ),
      child: Scaffold(
        appBar: appBarWidget(widget.slider.propertyName.validate(), context1: context, titleSpace: 0),
        body: SingleChildScrollView(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            cachedImage(widget.slider.sliderImage.validate(), height: context.height() * 0.3, width: context.width(), fit: BoxFit.fill).cornerRadiusWithClipRRect(12).paddingSymmetric(horizontal: 16),
            20.height,
            Container(
                padding: EdgeInsets.all(16),
                decoration: boxDecorationWithRoundedCorners(borderRadius: radius(12), backgroundColor: primaryVariant),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(language.tapToView, style: primaryTextStyle(color: Colors.black)),
                        4.height,
                        Text(widget.slider.propertyName.validate(), style: boldTextStyle(size: 18, color: Colors.black)),
                      ],
                    ).expand(),
                    Image.asset(ic_forward_arrow, height: 20, width: 20, fit: BoxFit.fill)
                  ],
                )).onTap(() {
              PropertyDetailScreen(
                propertyId: widget.slider.propertyId,
              ).launch(context);
            }).paddingSymmetric(horizontal: 16),
            HtmlWidget(postContent: widget.slider.description.validate()).paddingSymmetric(horizontal: 10)
          ]),
        ),
      ),
    );
  }
}
