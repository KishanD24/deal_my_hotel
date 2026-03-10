import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../components/app_bar_components.dart';
import '../extensions/colors.dart';
import '../extensions/extension_util/context_extensions.dart';
import '../extensions/extension_util/string_extensions.dart';
import '../extensions/shared_pref.dart';
import '../network/RestApis.dart';
import '../screens/news_all_screen.dart';
import '../screens/setting_screen.dart';
import '../screens/subscribe_screen.dart';
import '../screens/subscription_detail_screen.dart';
import '../utils/constants.dart';
import '../components/settings_components.dart';
import '../extensions/common.dart';
import '../extensions/confirmation_dialog.dart';
import '../extensions/decorations.dart';
import '../extensions/extension_util/int_extensions.dart';
import '../extensions/extension_util/widget_extensions.dart';
import '../extensions/text_styles.dart';
import '../main.dart';
import '../screens/edit_profile_screen.dart';
import '../utils/app_common.dart';
import '../utils/colors.dart';
import '../utils/images.dart';
import 'add_property_history_screen.dart';
import 'help_center_screen.dart';
import 'limit_screen.dart';
import 'login_screen.dart';
import 'my_properties_screen.dart';
import 'property_contact_info_screen.dart';
import 'view_property_contact_history_screen.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool select = true;

  @override
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

  Future deleteAccount(BuildContext context) async {
    appStore.setLoading(true);
    await deleteUserAccountApi().then((value) async {
      await deleteUserFirebase().then((value) async {
        await logout(context).then((value) async {
          appStore.setLoading(false);

          LoginScreen().launch(context, isNewTask: true);
        });
      }).catchError((error) {
        appStore.setLoading(false);
        toast(error.toString());
      });
    }).catchError((error) {
      appStore.setLoading(false);
      toast(error.toString());
    });
  }

  getPlanWidget(String total, String remainingTotal, int? isUnlimited, int mLimitCount, String title1, final Function()? onTap, String img) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 18),
      decoration: boxDecorationRoundedWithShadow(8, backgroundColor: appStore.isDarkModeOn ? scaffoldColorDark : Colors.white),
      child: Column(children: [
        userStore.subscription == "1" && userStore.isSubscribe != 0
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  FittedBox(
                    clipBehavior: Clip.none,
                    child: Text(
                      isUnlimited == 1 ? language.unlimited : total.toString(),
                      style: boldTextStyle(color: primaryColor, size: isUnlimited == 1 ? 16 : 20),
                      // style: boldTextStyle(color: primaryColor, size: isUnlimited == 1 ? 16 : 22),
                      // maxLines: 1,
                      // overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(isUnlimited != 1 ? "/$remainingTotal" : "", style: boldTextStyle(color: grey, size: isUnlimited == 1 ? 16 : 20)),
                ],
              )
            : Image.asset(img, height: 20, width: 20, color: primaryColor),
        8.height,
        userStore.subscription == "1" && userStore.isSubscribe != 0
            ? userStore.subscriptionDetail!.subscriptionPlan!.packageData!.property.validate() == 0
                ? mLimitCount == 0 && isUnlimited == 0
                    ? FittedBox(
                        child: Row(
                        children: [
                          Icon(Icons.add, size: 14, color: isUnlimited == 1 ? Colors.transparent : primaryColor),
                          Text(title1, style: primaryTextStyle(size: 14, color: primaryColor)),
                        ],
                      ))
                    : FittedBox(
                        child: Text(
                          title1,
                          style: primaryTextStyle(size: 13, color: grey),
                          textAlign: TextAlign.center,
                        ),
                      )
                : FittedBox(
                    child: Text(
                      title1,
                      style: primaryTextStyle(size: 13, color: grey),
                      textAlign: TextAlign.center,
                    ),
                  )
            : FittedBox(child: Text(title1, style: primaryTextStyle(size: 13)))
      ]),
    ).onTap(onTap).expand();
  }

  Widget mSettingOption(String mTitle, String mImg, Function onTapCall) {
    return SettingItemWidget(
      onTap: () {
        onTapCall.call();
      },
      title: mTitle,
      leading: Image.asset(mImg, height: 20, width: 20, color: primaryColor),
      trailing: Icon(Icons.arrow_forward_ios_sharp, color: grayColor, size: 18),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      return Scaffold(
        appBar: appBarWidget(language.myProfile, context1: context, showBack: false, bgColor: context.scaffoldBackgroundColor),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Observer(builder: (context) {
                return Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Container(
                      decoration: boxDecorationWithRoundedCorners(boxShape: BoxShape.circle, border: Border.all(color: primaryLight, width: 4)),
                      child: cachedImage(userStore.profileImage.validate(), height: 90, width: 90, fit: BoxFit.cover).cornerRadiusWithClipRRect(50),
                    ),
                    Container(
                      padding: EdgeInsets.all(6),
                      decoration: boxDecorationWithRoundedCorners(borderRadius: radius(50), border: Border.all(color: Colors.white), backgroundColor: primaryLight),
                      child: Image.asset(ic_edit_profile, height: 16, width: 16, color: primaryColor),
                    )
                  ],
                ).onTap(() async {
                  {
                    EditProfileScreen().launch(context);
                  }
                }).center();
              }),
              10.height,
              Text("${getStringAsync(FIRSTNAME).toString()} ${getStringAsync(LASTNAME).toString()}", style: boldTextStyle(size: 18)).center(),
              4.height,
              Text(getStringAsync(EMAIL).toString(), style: secondaryTextStyle(size: 16)).center(),
              20.height,
              userStore.subscription == "1" && userStore.isSubscribe != 0
                  ? Container(
                      padding: EdgeInsets.all(15),
                      decoration: boxDecorationWithRoundedCorners(
                          borderRadius: radiusOnly(
                              bottomRight: userStore.subscription == "1" && select ? 0 : defaultRadius,
                              bottomLeft: userStore.subscription == "1" && select ? 0 : defaultRadius,
                              topLeft: defaultRadius,
                              topRight: defaultRadius),
                          backgroundColor: primaryColor),
                      child: Row(
                        children: [
                          Text(language.yourCurrentPlan, style: primaryTextStyle(color: Colors.white)).expand(),
                          Icon(select ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down_outlined, color: Colors.white, size: 24).paddingTop(2)
                        ],
                      ),
                    ).onTap(() {
                      select = !select;
                      setState(() {});
                    })
                  : SizedBox(),
              Container(
                width: context.width(),
                padding: EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                decoration: boxDecorationWithRoundedCorners(
                  backgroundColor: appStore.isDarkModeOn ? cardDarkColor : primaryExtraLight,
                  borderRadius: radiusOnly(
                      topLeft: userStore.subscription == "1" && select ? 0 : defaultRadius,
                      topRight: userStore.subscription == "1" && select ? 0 : defaultRadius,
                      bottomLeft: defaultRadius,
                      bottomRight: defaultRadius),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    getPlanWidget(
                        userStore.userResponse!.planLimitCount!.remainingAddPropertyLimit.validate().toString(),
                        userStore.userResponse!.planLimitCount!.withExtraAddPropertyLimit.validate().toString(),
                        userStore.subscriptionDetail!.subscriptionPlan != null ? userStore.subscriptionDetail!.subscriptionPlan!.packageData!.addProperty.validate() : 0,
                        userStore.addLimitCount,
                        language.addProperty, () {
                      if (userStore.subscription == "1") {
                        if (userStore.isSubscribe != 0) {
                          if (userStore.subscriptionDetail!.subscriptionPlan!.packageData!.addProperty.validate() == 0) {
                            userStore.addLimitCount == 0 ? LimitScreen(limit: "add_property").launch(context) : AddPropertyHistoryScreen(history: true).launch(context);
                          } else {
                            AddPropertyHistoryScreen(history: true).launch(context);
                          }
                        } else {
                          SubscribeScreen().launch(context);
                        }
                      } else {
                        AddPropertyHistoryScreen(history: true).launch(context);
                      }
                    }, ic_profile_property),
                    14.width,
                    getPlanWidget(
                        userStore.userResponse!.planLimitCount!.remainingAdvertisementPropertyLimit.validate().toString(),
                        userStore.userResponse!.planLimitCount!.withExtraAdvertisementLimit.validate().toString(),
                        userStore.subscriptionDetail!.subscriptionPlan != null ? userStore.subscriptionDetail!.subscriptionPlan!.packageData!.advertisement.validate() : 0,
                        userStore.advertisement,
                        language.advertisement, () {
                      if (userStore.subscription == "1") {
                        if (userStore.isSubscribe != 0) {
                          if (userStore.subscriptionDetail!.subscriptionPlan!.packageData!.advertisement.validate() == 0) {
                            userStore.advertisement == 0 ? LimitScreen(limit: "advertisement_property").launch(context) : AddPropertyHistoryScreen(history: false).launch(context);
                          } else {
                            AddPropertyHistoryScreen(history: false).launch(context);
                          }
                        } else {
                          SubscribeScreen().launch(context);
                        }
                      } else {
                        AddPropertyHistoryScreen(history: false).launch(context);
                        // AdvertisementHistoryScreen().launch(context);
                      }
                    }, ic_profile_advertisement),
                    14.width,
                    // 16.width.visible(userStore.subscription == "1"),
                    getPlanWidget(
                        userStore.userResponse!.planLimitCount!.remainingViewPropertyLimit.validate().toString(),
                        userStore.userResponse!.planLimitCount!.withExtraPropertyLimit.validate().toString(),
                        userStore.subscriptionDetail!.subscriptionPlan != null ? userStore.subscriptionDetail!.subscriptionPlan!.packageData!.property.validate() : 0,
                        userStore.contactInfo,
                        language.contactInfo, () {
                      if (userStore.subscription == "1") {
                        if (userStore.isSubscribe != 0) {
                          if (userStore.subscriptionDetail!.subscriptionPlan!.packageData!.property.validate() == 0) {
                            userStore.contactInfo == 0 ? LimitScreen(limit: "view_property").launch(context) : PropertyContactInfoScreen().launch(context);
                          } else {
                            PropertyContactInfoScreen().launch(context);
                          }
                        } else {
                          SubscribeScreen().launch(context);
                        }
                      } else {
                        PropertyContactInfoScreen().launch(context);
                      }
                    }, ic_call_outlined),
                  ],
                ),
              ).visible(select == true),
              14.height,
              mSettingOption(language.myProperty, ic_my_properties, () {
                MyPropertiesScreen().launch(context);
              }),
              14.height.visible(userStore.subscription == "1"),
              mSettingOption(language.subscription, ic_subscriptions, () {
                SubscriptionDetailScreen().launch(context);
              }).visible(userStore.subscription == "1"),
              14.height,
              mSettingOption(language.viewPropertyContactHistory, ic_view_property, () {
                if (userStore.subscription == "1") {
                  if (userStore.isSubscribe != 0) {
                    ViewPropertyContactHistory().launch(context);
                  } else {
                    SubscribeScreen().launch(context);
                  }
                }
              }).visible(userStore.subscription == "1"),
              14.height.visible(userStore.subscription == "1"),
              mSettingOption(language.newsArticles, ic_articles, () {
                NewsAllScreen().launch(context);
              }),
              14.height,
              mSettingOption(language.setting, ic_settings, () {
                SettingScreen().launch(context);
              }),
              14.height,
              mSettingOption(language.aboutApp, ic_about, () {
                HelpCenterScreen().launch(context);
              }),
              14.height,
              mSettingOption(language.deleteAccount, ic_delete_ac, () {
                showConfirmDialogCustom(
                  bgColor: limitColor.withOpacity(0.10),
                  iconColor: limitColor,
                  image: ic_delete_ac,
                  context,
                  primaryColor: limitColor,
                  positiveTextColor: Colors.white,
                  negativeTextColor: primaryColor,
                  title: language.deleteAccountMessage,
                  positiveText: language.delete,
                  height: 100,
                  onAccept: (c) async {
                    await deleteAccount(context);
                  },
                );
              }),
              14.height,
              mSettingOption(language.logOut, ic_logout, () {
                showConfirmDialogCustom(
                  image: ic_logout,
                  bgColor: context.cardColor,
                  iconColor: primaryColor,
                  context,
                  negativeBg: context.cardColor,
                  primaryColor: primaryColor,
                  title: language.logoutMsg.capitalizeFirstLetter(),
                  positiveText: language.logOut,
                  height: 100,
                  onAccept: (c) {
                    logout(context);
                  },
                );
              }),
              14.height,
            ],
          ).paddingSymmetric(horizontal: 16).paddingOnly(bottom: 40),
        ),
      );
    });
  }

  getPlans(int title, String title1, final Function()? onTap, String img) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 18),
      decoration: boxDecorationRoundedWithShadow(8, backgroundColor: appStore.isDarkModeOn ? Colors.black : Colors.white),
      child: Column(children: [
        userStore.subscription == "1" && userStore.isSubscribe != 0
            ? Text(title.toString(), style: boldTextStyle(color: userStore.addLimitCount == 0 && userStore.contactInfo == 0 && userStore.advertisement == 0 ? grey : primaryColor, size: 22))
            : Image.asset(img, height: 20, width: 20, color: primaryColor),
        8.height,
        userStore.addLimitCount == 0 && userStore.contactInfo == 0 && userStore.advertisement == 0 && userStore.subscription == "1"
            ? FittedBox(
                child: Text(
                  "+ " + title1,
                  style: primaryTextStyle(size: 13, color: primaryColor),
                  textAlign: TextAlign.center,
                ),
              )
            : FittedBox(child: Text(title1, style: primaryTextStyle(size: 13)))
      ]),
    ).onTap(onTap).expand();
  }
}
