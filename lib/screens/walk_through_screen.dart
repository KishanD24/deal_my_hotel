import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../extensions/app_button.dart';
import '../../extensions/extension_util/context_extensions.dart';
import '../../extensions/extension_util/int_extensions.dart';
import '../../extensions/extension_util/widget_extensions.dart';
import '../extensions/common.dart';
import '../extensions/shared_pref.dart';
import '../extensions/text_styles.dart';
import '../main.dart';
import '../models/walk_through_model.dart';

import '../utils/colors.dart';
import '../utils/constants.dart';
import '../utils/images.dart';
import 'login_screen.dart';

class WalkThroughScreen extends StatefulWidget {
  @override
  _WalkThroughScreenState createState() => _WalkThroughScreenState();
}

class _WalkThroughScreenState extends State<WalkThroughScreen> {
  PageController mPageController = PageController();

  List<WalkThroughModel> mWalkList = [];
  int mCurrentIndex = 0;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    mWalkList.add(WalkThroughModel(
        image: ic_walk1,
        title: language.WALK1_TITLE,
        title1: language.WALK1_TITLE1,
        title2: language.WALK1_TITLE_1));
    mWalkList.add(WalkThroughModel(
        image: ic_walk2,
        title: language.WALK2_TITLE,
        title1: language.WALK2_TITLE2,
        title2: language.WALK2_TITLE_2));
    mWalkList.add(WalkThroughModel(
        image: ic_walk3,
        title: language.WALK3_TITLE,
        title1: language.WALK3_TITLE3,
        title2: language.WALK3_TITLE_3));
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    mPageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness:
            appStore.isDarkModeOn ? Brightness.light : Brightness.dark,
        systemNavigationBarIconBrightness:
            appStore.isDarkModeOn ? Brightness.light : Brightness.dark,
      ),
      child: Scaffold(
          body: Stack(
        children: [
          PageView(
            controller: mPageController,
            children: mWalkList.map((e) {
              return Column(
                children: [
                  Image.asset(mWalkList[mCurrentIndex].image!,
                      height: context.height() * 0.50, fit: BoxFit.fill),
                ],
              ).paddingTop(context.statusBarHeight + 30);
            }).toList(),
            onPageChanged: (i) {
              mCurrentIndex = i;
              setState(() {});
            },
          ),
          Positioned(
            top: context.statusBarHeight,
            right: 4,
            child: TextButton(
                style: ButtonStyle(
                    overlayColor:
                        MaterialStateProperty.all(Colors.transparent)),
                onPressed: () {
                  setValue(IS_FIRST_TIME, true);
                  LoginScreen().launch(context, isNewTask: false);
                },
                child: Text(language.skip,
                    style: boldTextStyle(color: primaryColor))),
          ).visible(mCurrentIndex != 2),
          Positioned(
            right: 24,
            left: 24,
            bottom: context.statusBarHeight + 70,
            child: Column(
              children: [
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                          text: mWalkList[mCurrentIndex]
                              .title1
                              .toString()
                              .toUpperCase(),
                          style: boldTextStyle(size: 20)),
                      TextSpan(
                          text: " " +
                              mWalkList[mCurrentIndex]
                                  .title2
                                  .toString()
                                  .toUpperCase(),
                          style: boldTextStyle(color: primaryColor, size: 20)),
                    ],
                  ),
                ),
                16.height,
                Text(mWalkList[mCurrentIndex].title.toString(),
                    style: secondaryTextStyle(size: 16),
                    textAlign: TextAlign.center),
                16.height,
                dotIndicator(mWalkList, mCurrentIndex),
                40.height,
                AppButton(
                  text:
                      mCurrentIndex == 2 ? language.getStarted : language.next,
                  width: context.width(),
                  color: primaryColor,
                  onTap: () {
                    if (mCurrentIndex.toInt() >= 2) {
                      setValue(IS_FIRST_TIME, true);
                      LoginScreen().launch(context, isNewTask: false);
                    } else {
                      mPageController.nextPage(
                          duration: Duration(seconds: 1),
                          curve: Curves.linearToEaseOut);
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      )),
    );
  }
}
