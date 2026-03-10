import 'package:flutter/material.dart';
import '../extensions/extension_util/context_extensions.dart';
import '../extensions/extension_util/int_extensions.dart';
import '../extensions/extension_util/string_extensions.dart';
import '../extensions/extension_util/widget_extensions.dart';
import '../models/dashBoard_response.dart';
import '../screens/slider_details_screen.dart';
import '../extensions/common.dart';
import '../utils/app_common.dart';

class SlidesComponents extends StatefulWidget {
  final List<MSlider>? data;

  SlidesComponents({required this.data});

  @override
  State<SlidesComponents> createState() => _SlidesComponentsState();
}

class _SlidesComponentsState extends State<SlidesComponents> {
  PageController pageController = PageController();
  List<MSlider> slider = [];
  int currentIndex = 0;

  void initState() {
    super.initState();
    init();
  }

  void init() async {
    setState(() {});
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    double mHeight = context.height() * 0.2;
    return Column(
      children: [
        16.height,
        SizedBox(
          height: mHeight,
          width: context.width(),
          child: PageView.builder(
            itemCount: widget.data!.length,
            controller: pageController,
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, i) {
              return cachedImage(widget.data![i].sliderImage.validate(), height: context.height() * 0.2, fit: BoxFit.cover, width: context.width())
                  .cornerRadiusWithClipRRect(16)
                  .paddingOnly(right: 16, bottom: 8, left: 16)
                  .onTap(() {
                SliderDetailsScreen(slider: widget.data![i]).launch(context);
              });
            },
            onPageChanged: (int i) {
              currentIndex = i;
              setState(() {});
            },
          ),
        ),
        dotIndicator(widget.data!, currentIndex).paddingTop(4),
      ],
    );
  }
}
