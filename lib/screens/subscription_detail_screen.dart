import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../extensions/colors.dart';
import '../extensions/extension_util/context_extensions.dart';
import '../extensions/extension_util/num_extensions.dart';
import '../extensions/extension_util/string_extensions.dart';
import '../extensions/loader_widget.dart';
import '../screens/subscribe_screen.dart';
import '../components/HtmlWidget.dart';
import '../components/app_bar_components.dart';
import '../extensions/LiveStream.dart';
import '../extensions/animatedList/animated_list_view.dart';
import '../extensions/app_button.dart';
import '../extensions/common.dart';
import '../extensions/confirmation_dialog.dart';
import '../extensions/decorations.dart';
import '../extensions/extension_util/int_extensions.dart';
import '../extensions/extension_util/widget_extensions.dart';
import '../extensions/price_widget.dart';
import '../extensions/text_styles.dart';
import '../main.dart';
import '../models/subscription_plan_response.dart';
import '../network/RestApis.dart';
import '../utils/app_common.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';
import '../utils/images.dart';
import 'no_data_screen.dart';

class SubscriptionDetailScreen extends StatefulWidget {
  @override
  State<SubscriptionDetailScreen> createState() => _SubscriptionDetailScreenState();
}

class _SubscriptionDetailScreenState extends State<SubscriptionDetailScreen> {
  List<SubscriptionPlan> mSubscriptionPlanList = [];
  bool select = true;
  int i = 0;

  ScrollController scrollController = ScrollController();

  int page = 1;
  int? numPage;

  bool isLastPage = false;

  @override
  void initState() {
    super.initState();
    init();

    LiveStream().on(PAYMENT, (p0) {
      init();
    });
  }

  void init() async {
    getSubscriptionList();
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent && !appStore.isLoading) {
        if (page < numPage!) {
          page++;
          init();
        }
      }
    });
  }

  Future<void> getSubscriptionList() async {
    appStore.setLoading(true);
    getSubscriptionPlanList(page: page).then((value) {
      numPage = value.pagination!.totalPages;
      isLastPage = false;
      if (page == 1) {
        mSubscriptionPlanList.clear();
      }
      Iterable it = value.data!;
      it.map((e) => mSubscriptionPlanList.add(e)).toList();

      mSubscriptionPlanList.forEach((element) {});
      appStore.setLoading(false);

      setState(() {});
    }).catchError((e) {
      isLastPage = true;
      appStore.setLoading(false);
    });
  }

  Future<void> cancelPackage() async {
    appStore.setLoading(true);
    Map req = {
      "id": userStore.subscriptionDetail!.subscriptionPlan!.id,
    };
    await cancelPlanApi(req).then((value) async {
      await getUSerDetail(context, userStore.userId).whenComplete(() {
        appStore.setLoading(false);
        userStore.isSubscribe = 0;
        getSubscriptionList();
        setState(() {});
        toast(value.message);
      });
    }).catchError((e) {
      print(e.toString());
    });
  }

  Color getTextColor(String? state) {
    switch (state) {
      case ACTIVE:
        return Colors.green;
      case INACTIVE:
        return inactiveColor;
      case CANCELLED:
        return inactiveColor;
      case EXPIRED:
        return Colors.yellow;
      default:
        return Colors.black;
    }
  }

  Color getBgColor(String? state) {
    switch (state) {
      case ACTIVE:
        return Colors.green.withOpacity(0.15);
      case INACTIVE:
        return inactiveColor.withOpacity(0.10);
      case CANCELLED:
        return Colors.red.withOpacity(0.10);
      case EXPIRED:
        return Colors.yellow.withOpacity(0.5);
      default:
        return Colors.green.withOpacity(0.15);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
        value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: appStore.isDarkModeOn ? Brightness.light : Brightness.light,
          systemNavigationBarIconBrightness: appStore.isDarkModeOn ? Brightness.light : Brightness.light,
        ),
        child: Scaffold(
            appBar: appBarWidget(language.subscriptionPlans,
                titleSpace: 0,
                context1: context,
                bottom: PreferredSize(
                  preferredSize: Size.fromHeight(65),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 14),
                        decoration: boxDecorationWithRoundedCorners(
                            borderRadius: radius(),
                            backgroundColor: i == 0
                                ? primaryColor
                                : appStore.isDarkModeOn
                                    ? cardDarkColor
                                    : primaryExtraLight),
                        child: Text(language.active,
                                style: boldTextStyle(
                                    color: i == 0
                                        ? Colors.white
                                        : appStore.isDarkModeOn
                                            ? Colors.white
                                            : primaryColor))
                            .center(),
                      ).onTap(() {
                        setState(() {
                          select = !select;
                          i = 0;
                        });
                      }).expand(),
                      10.width,
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 14),
                        decoration: boxDecorationWithRoundedCorners(
                            borderRadius: radius(),
                            backgroundColor: i == 1
                                ? primaryColor
                                : appStore.isDarkModeOn
                                    ? cardDarkColor
                                    : primaryExtraLight),
                        child: Text(language.history,
                                style: boldTextStyle(
                                    color: i == 1
                                        ? Colors.white
                                        : appStore.isDarkModeOn
                                            ? Colors.white
                                            : primaryColor))
                            .center(),
                      ).onTap(() {
                        setState(() {
                          select = !select;
                          i = 1;
                        });
                      }).expand(),
                    ],
                  ).paddingSymmetric(horizontal: 16, vertical: 16),
                )),
            body: Stack(
              children: [
                Stack(
                  children: [
                    select && !appStore.isLoading
                        ? userStore.subscriptionDetail == null
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(no_subscription, height: context.height() * 0.3, width: context.width() * 0.4, fit: BoxFit.cover),
                                  30.height,
                                  Text(language.subscriptionMsg.capitalizeFirstLetter(), style: boldTextStyle(size: 16, color: textSecondaryColorGlobal)),
                                  50.height,
                                  AppButton(
                                    text: language.viewPlans,
                                    width: context.width(),
                                    color: primaryColor,
                                    onTap: () async {
                                      bool? res = await SubscribeScreen().launch(context, pageRouteAnimation: PageRouteAnimation.Fade);
                                      if (res == true) {
                                        toast("value");
                                        //getSubscriptionList();
                                      }
                                    },
                                  ).paddingAll(16)
                                ],
                              )
                            : userStore.subscriptionDetail!.subscriptionPlan == null || userStore.subscriptionDetail!.subscriptionPlan!.status == "inactive"
                                ? Container(
                                    height: context.height() - context.height() * 0.45,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Image.asset(no_subscription, height: context.height() * 0.3, width: context.width() * 0.4, fit: BoxFit.cover),
                                        30.height,
                                        Text(language.subscriptionMsg, style: primaryTextStyle(color: textSecondaryColorGlobal)),
                                        50.height,
                                        AppButton(
                                          text: language.viewPlans,
                                          width: context.width(),
                                          color: primaryColor,
                                          onTap: () {
                                            SubscribeScreen().launch(context, pageRouteAnimation: PageRouteAnimation.Fade);
                                          },
                                        ).paddingSymmetric(horizontal: 16)
                                      ],
                                    ),
                                  )
                                : SingleChildScrollView(
                                    child: Column(
                                    children: [
                                      Stack(
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(bottom: 10, top: 26),
                                            decoration: boxDecorationWithRoundedCorners(borderRadius: radius(10), backgroundColor: primaryVariant),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                10.height,
                                                Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    PriceWidget(
                                                            price: userStore.subscriptionDetail!.subscriptionPlan!.totalAmount.validate().toStringAsFixed(2),
                                                            color: primaryColor,
                                                            textStyle: boldTextStyle(size: 18, color: primaryColor))
                                                        .visible(userStore.subscriptionDetail!.subscriptionPlan!.totalAmount.validate() > 0),
                                                    4.width.visible(userStore.subscriptionDetail!.subscriptionPlan!.totalAmount.validate() > 0),
                                                    Text(
                                                      userStore.subscriptionDetail!.subscriptionPlan!.packageData!.durationUnit.toString().capitalizeFirstLetter(),
                                                      style: boldTextStyle(color: primaryColor, size: 18),
                                                    )
                                                  ],
                                                ),
                                                8.height,
                                                Text(
                                                    language.yourPlanValid +
                                                        " " +
                                                        parseDocumentDate(DateTime.parse(userStore.subscriptionDetail!.subscriptionPlan!.subscriptionStartDate.validate())) +
                                                        " ${language.to} " +
                                                        parseDocumentDate(DateTime.parse(userStore.subscriptionDetail!.subscriptionPlan!.subscriptionEndDate.validate())),
                                                    style: primaryTextStyle(color: grayColor, size: 12)),
                                                HtmlWidget(postContent: userStore.subscriptionDetail!.subscriptionPlan!.packageData!.description.validate(), color: textSecondaryColor, size: 14),
                                                8.height,
                                                Row(
                                                  children: [
                                                    Icon(Icons.circle, size: 6, color: Colors.black),
                                                    10.width,
                                                    Text(language.viewPropertyLimit, style: primaryTextStyle(size: 14, color: Colors.black)).expand(),
                                                    userStore.subscriptionDetail!.subscriptionPlan!.packageData!.propertyLimit == null
                                                        ? Text(language.unlimited, style: primaryTextStyle(size: 14, color: primaryColor))
                                                        : Text(userStore.subscriptionDetail!.subscriptionPlan!.packageData!.propertyLimit.toString(),
                                                            style: primaryTextStyle(size: 14, color: primaryColor)),
                                                  ],
                                                ).paddingLeft(10),
                                                8.height,
                                                Row(
                                                  children: [
                                                    Icon(Icons.circle, size: 6, color: Colors.black),
                                                    10.width,
                                                    Text(language.addPropertyLimit, style: primaryTextStyle(size: 14, color: Colors.black)).expand(),
                                                    userStore.subscriptionDetail!.subscriptionPlan!.packageData!.addPropertyLimit == null
                                                        ? Text(language.unlimited, style: primaryTextStyle(size: 14, color: primaryColor))
                                                        : Text(userStore.subscriptionDetail!.subscriptionPlan!.packageData!.addPropertyLimit.toString(),
                                                            style: primaryTextStyle(size: 14, color: primaryColor)),
                                                  ],
                                                ).paddingLeft(10),
                                                8.height,
                                                Row(
                                                  children: [
                                                    Icon(Icons.circle, size: 6, color: Colors.black),
                                                    10.width,
                                                    Text(language.advertisementLimit, style: primaryTextStyle(size: 14, color: Colors.black)).expand(),
                                                    userStore.subscriptionDetail!.subscriptionPlan!.packageData!.advertisementLimit == null
                                                        ? Text(language.unlimited, style: primaryTextStyle(size: 14, color: primaryColor))
                                                        : Text(userStore.subscriptionDetail!.subscriptionPlan!.packageData!.advertisementLimit.toString(),
                                                            style: primaryTextStyle(size: 14, color: primaryColor)),
                                                  ],
                                                ).paddingLeft(10),
                                              ],
                                            ).paddingAll(16),
                                          ).paddingSymmetric(horizontal: 16),
                                          Positioned(
                                            left: 40,
                                            top: 14,
                                            child: Container(
                                              padding: EdgeInsets.symmetric(horizontal: 18, vertical: 4),
                                              decoration: boxDecorationWithRoundedCorners(borderRadius: radius(50), backgroundColor: Colors.black),
                                              child: Text(
                                                userStore.subscriptionDetail!.subscriptionPlan!.packageName.validate().toUpperCase(),
                                                style: primaryTextStyle(color: Colors.white, size: 14),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      50.height,
                                      AppButton(
                                        elevation: 0,
                                        text: language.cancelSubscription,
                                        width: context.width(),
                                        color: primaryColor,
                                        textColor: Colors.white,
                                        onTap: () {
                                          showConfirmDialogCustom(
                                            bgColor: limitColor.withOpacity(0.10),
                                            iconColor: limitColor,
                                            image: ic_cancel_subscription,
                                            context,
                                            primaryColor: limitColor,
                                            positiveTextColor: Colors.white,
                                            negativeTextColor: primaryColor,
                                            title: language.cancelSubscriptionMsg.capitalizeFirstLetter(),
                                            positiveText: language.yes,
                                            negativeText: language.no,
                                            onAccept: (c) async {
                                              await cancelPackage();
                                            },
                                          );
                                        },
                                      ).paddingSymmetric(horizontal: 16),
                                      20.height,
                                    ],
                                  ))
                        : mSubscriptionPlanList.isNotEmpty
                            ? AnimatedListView(
                                itemCount: mSubscriptionPlanList.length,
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                shrinkWrap: true,
                                controller: scrollController,
                                physics: ScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return Stack(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.only(top: 20),
                                        child: Container(
                                          margin: EdgeInsets.only(bottom: 0),
                                          decoration: boxDecorationWithRoundedCorners(
                                              borderRadius: radius(12),
                                              backgroundColor:
                                                  mSubscriptionPlanList[index].cancelDate != null ? Colors.red.withOpacity(0.15) : getBgColor(mSubscriptionPlanList[index].status.validate())),
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  10.height,
                                                  Row(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      PriceWidget(
                                                              price: mSubscriptionPlanList[index].totalAmount.validate().toStringAsFixed(2),
                                                              color: primaryColor,
                                                              textStyle: primaryTextStyle(size: 18, color: primaryColor))
                                                          .visible(mSubscriptionPlanList[index].totalAmount.validate() > 0),
                                                      4.width.visible(mSubscriptionPlanList[index].totalAmount.validate() > 0),
                                                      Text(
                                                        mSubscriptionPlanList[index].packageData!.durationUnit.toString().capitalizeFirstLetter(),
                                                        style: primaryTextStyle(color: primaryColor, size: 18),
                                                      ).expand(),
                                                      Text(mSubscriptionPlanList[index].cancelDate != null ? "Cancelled" : mSubscriptionPlanList[index].status.validate().capitalizeFirstLetter(),
                                                          style: primaryTextStyle(
                                                              size: 16,
                                                              color: mSubscriptionPlanList[index].cancelDate != null ? Colors.red : getTextColor(mSubscriptionPlanList[index].status.validate())))
                                                    ],
                                                  ),
                                                  10.height,
                                                  Text(
                                                    parseDocumentDate(DateTime.parse(mSubscriptionPlanList[index].subscriptionStartDate.validate())) +
                                                        " ${language.to} " +
                                                        parseDocumentDate(DateTime.parse(mSubscriptionPlanList[index].subscriptionEndDate.validate())),
                                                    style: secondaryTextStyle(),
                                                  ),
                                                  10.height.visible(mSubscriptionPlanList[index].cancelDate != null),
                                                  if (mSubscriptionPlanList[index].cancelDate != null)
                                                    Row(
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        Icon(Icons.circle, size: 6, color: Colors.black),
                                                        4.width,
                                                        Text(language.cancelledOn + " ", style: primaryTextStyle(size: 14)),
                                                        Text(parseDocumentDate(DateTime.parse(mSubscriptionPlanList[index].cancelDate.validate())), style: secondaryTextStyle()),
                                                      ],
                                                    ),
                                                  10.height.visible(mSubscriptionPlanList[index].paymentType != null),
                                                  if (mSubscriptionPlanList[index].paymentType != null)
                                                    Row(
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        Icon(Icons.circle, size: 6, color: Colors.black),
                                                        4.width,
                                                        Text(language.paymentVia + " " + mSubscriptionPlanList[index].paymentType.toString(), style: primaryTextStyle(size: 14)),
                                                      ],
                                                    ),
                                                ],
                                              ).expand(),
                                            ],
                                          ).paddingAll(20),
                                        ),
                                      ),
                                      Positioned(
                                        left: 20,
                                        top: 10,
                                        child: Container(
                                          padding: EdgeInsets.symmetric(horizontal: 18, vertical: 4),
                                          decoration: boxDecorationWithRoundedCorners(borderRadius: radius(50), backgroundColor: Colors.black),
                                          child: Text(
                                            mSubscriptionPlanList[index].packageName.validate().toUpperCase(),
                                            style: primaryTextStyle(color: Colors.white, size: 14),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ).paddingOnly(bottom: 12);
                                },
                              )
                            : SizedBox(height: context.height() * 0.65, child: NoDataScreen().center()).visible(!appStore.isLoading),
                  ],
                ).visible(!appStore.isLoading),
                Loader().center().visible(appStore.isLoading)
              ],
            )));
  }
}
