import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';

import '../components/add_property_dialouge.dart';
import '../extensions/extension_util/context_extensions.dart';
import '../extensions/extension_util/string_extensions.dart';
import '../extensions/extension_util/widget_extensions.dart';
import '../screens/profile_screen.dart';
import '../screens/subscribe_screen.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';
import '../components/limit_exceed_dialog.dart';
import '../extensions/LiveStream.dart';
import '../extensions/colors.dart';
import '../extensions/double_press_back_widget.dart';
import '../extensions/shared_pref.dart';
import '../extensions/system_utils.dart';
import '../main.dart';
import '../network/RestApis.dart';
import '../utils/app_common.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';
import '../utils/images.dart';
import 'category_screen.dart';
import 'favourite_screen.dart';
import 'home_screen.dart';
import 'limit_screen.dart';

class DashboardScreen extends StatefulWidget {
  DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int currentIndex = 0;

  late final List<Widget> tabs;

  bool received = true;

  @override
  void initState() {
    super.initState();
    tabs = [HomeScreen(), CategoryScreen(), FavouriteScreen(), ProfileScreen()];
    OneSignal.User.pushSubscription.optIn();
    init();
  }

  void init() async {
    PlatformDispatcher.instance.onPlatformBrightnessChanged = () {
      if (getIntAsync(THEME_MODE_INDEX) == ThemeModeSystem) {
        appStore.setDarkMode(
            MediaQuery.of(context).platformBrightness == Brightness.light);
      }
    };
    getSettingList();

    LiveStream().on("LANGUAGE", (s) {
      setState(() {});
    });
  }

  Future<void> getSettingList() async {
    await getSettingApi().then((value) {
      userStore.setCurrencyCodeID(value.currencySetting!.symbol.validate());
      userStore
          .setCurrencyPositionID(value.currencySetting!.position.validate());

      userStore.setCurrencyCode(value.currencySetting!.code.validate());
      for (int i = 0; i < value.data!.length; i++) {
        switch (value.data![i].key) {
          case "terms_condition":
            {
              userStore.setTermsCondition(value.data![i].value.validate());
            }
          case "privacy_policy":
            {
              userStore.setPrivacyPolicy(value.data![i].value.validate());
            }
          case "ONESIGNAL_APP_ID":
            {
              userStore.setOneSignalAppID(value.data![i].value.validate());
            }
          case "ONESIGNAL_REST_API_KEY":
            {
              userStore.setOnesignalRestApiKey(value.data![i].value.validate());
            }
          case "ADMOB_BannerId":
            {
              userStore.setAdmobBannerId(value.data![i].value.validate());
            }
          case "ADMOB_InterstitialId":
            {
              userStore.setAdmobInterstitialId(value.data![i].value.validate());
            }
          case "ADMOB_BannerIdIos":
            {
              userStore.setAdmobBannerIdIos(value.data![i].value.validate());
            }
          case "ADMOB_InterstitialIdIos":
            {
              userStore
                  .setAdmobInterstitialIdIos(value.data![i].value.validate());
            }
          case "subscription_system":
            {
              userStore.setSubscription(value.data![i].value.validate());
            }
          case "CHATGPT_API_KEY":
            {
              userStore.setChatGptApiKey(value.data![i].value.validate());
            }
        }
      }
      getSettingData();
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void didChangeDependencies() {
    if (getIntAsync(THEME_MODE_INDEX) == ThemeModeSystem)
      appStore.setDarkMode(
          MediaQuery.of(context).platformBrightness == Brightness.dark);
    setState(() {});
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        body: DoublePressBackWidget(
          child: AnimatedContainer(
              color: context.cardColor,
              duration: const Duration(seconds: 1),
              child: tabs[currentIndex]
              // IndexedStack(index: currentIndex, children: tabs
              ),
        ),
        floatingActionButton: FloatingActionButton(
          heroTag: language.addProperties,
          child: Icon(Icons.add, size: 44, color: Colors.white),
          onPressed: () {
            userStore.subscription == "1"
                ? userStore.isSubscribe != 0
                    ? userStore.subscriptionDetail!.subscriptionPlan!
                                .packageData!.addProperty ==
                            0
                        ? showDialog(
                            context: context,
                            builder: (context) {
                              return userStore.addLimitCount == 0
                                  ? LimitExceedDialog(
                                      onTap: () {
                                        finish(context);
                                        LimitScreen(limit: "add_property")
                                            .launch(context);
                                      },
                                    )
                                  : AddPropertyDialog();
                            },
                          )
                        : showDialog(
                            context: context,
                            builder: (context) {
                              return AddPropertyDialog();
                            },
                          )
                    : SubscribeScreen().launch(context)
                : showDialog(
                    context: context,
                    builder: (context) {
                      return AddPropertyDialog();
                    },
                  );
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: StylishBottomBar(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12), topRight: Radius.circular(12)),
          backgroundColor:
              appStore.isDarkModeOn ? cardDarkColor : primaryVariant,
          option: AnimatedBarOptions(iconStyle: IconStyle.Default),
          currentIndex: currentIndex,
          hasNotch: true,
          fabLocation: StylishBarFabLocation.center,
          onTap: (index) {
            currentIndex = index;
            setState(() {});
          },
          items: [
            BottomBarItem(
              icon: Image.asset(ic_home,
                  height: 24, width: 24, color: primaryColor),
              selectedIcon: Image.asset(ic_home_fill,
                  height: 24, width: 24, color: primaryColor),
              title: SizedBox(),
            ),
            BottomBarItem(
              icon: Image.asset(ic_category,
                  height: 24, width: 24, color: primaryColor),
              selectedIcon: Image.asset(ic_category_fill,
                  height: 24, width: 24, color: primaryColor),
              title: SizedBox(),
            ),
            BottomBarItem(
              icon: Image.asset(ic_favorite,
                  height: 24, width: 24, color: primaryColor),
              selectedIcon: Image.asset(ic_favorite_fill,
                  height: 24, width: 24, color: primaryColor),
              title: SizedBox(),
            ),
            BottomBarItem(
              icon: Image.asset(ic_profile,
                  height: 24, width: 24, color: primaryColor),
              selectedIcon: Image.asset(ic_profile_fill,
                  height: 24, width: 24, color: primaryColor),
              title: SizedBox(),
            ),
          ],
        ),
      ),
    );
  }
}
