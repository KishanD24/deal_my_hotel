import 'package:flutter/material.dart';
import '../extensions/extension_util/context_extensions.dart';
import '../../components/app_bar_components.dart';
import '../extensions/animatedList/animated_wrap.dart';
import '../extensions/decorations.dart';
import '../extensions/extension_util/widget_extensions.dart';
import '../extensions/text_styles.dart';
import '../main.dart';
import '../models/dashBoard_response.dart';
import '../utils/app_common.dart';
import '../utils/colors.dart';

class SelectPropertyListScreen extends StatefulWidget {
  SelectPropertyListScreen({super.key, required this.mDashboardResponse});

  final List<DashboardResponse> mDashboardResponse;

  @override
  State<SelectPropertyListScreen> createState() => _SelectPropertyListScreenState();
}

class _SelectPropertyListScreenState extends State<SelectPropertyListScreen> {
  List<PropertyType> mPropertyType = [];

  void initState() {
    super.initState();
    init();
  }

  void init() async {
    for (int i = 0; i < widget.mDashboardResponse.length; i++) {
      mPropertyType.addAll(widget.mDashboardResponse[i].propertyType!);
    }
    setState(() {});
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBarWidget(language.selectPropertyType, context1: context,titleSpace: 0),
        body: AnimatedWrap(
          runSpacing: 16,
          spacing: 16,
          children: List.generate(mPropertyType.length, (i) {
            return Stack(
              children: [
                cachedImage(
                  mPropertyType[i].propertyTypeImage.toString(),
                  height: context.height() * 0.25,
                  fit: BoxFit.fill,
                  width: (context.width() - 56) / 2,
                ).cornerRadiusWithClipRRect(12),
                Positioned(
                  bottom: 10,
                  left: 10,
                  right: 10,
                  child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: boxDecorationWithRoundedCorners(borderRadius: radius(4), backgroundColor: primaryExtraLight),
                      child: Text(mPropertyType[i].name.toString(), style: primaryTextStyle(size: 18, color: appStore.isDarkModeOn ? scaffoldColorDark : primaryColor)).center()),
                ),
              ],
            );
          }),
        ).paddingSymmetric(horizontal: 16));
  }
}
