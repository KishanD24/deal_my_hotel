import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../components/HtmlWidget.dart';
import '../extensions/extension_util/context_extensions.dart';
import '../extensions/extension_util/int_extensions.dart';
import '../extensions/extension_util/string_extensions.dart';
import '../extensions/extension_util/widget_extensions.dart';
import '../extensions/price_widget.dart';
import '../extensions/text_styles.dart';
import '../screens/payment_screen.dart';
import '../utils/colors.dart';
import '../extensions/LiveStream.dart';
import '../extensions/app_button.dart';
import '../extensions/common.dart';
import '../extensions/decorations.dart';
import '../extensions/loader_widget.dart';
import '../extensions/system_utils.dart';
import '../main.dart';
import '../models/subscription_model.dart';
import '../network/RestApis.dart';
import '../utils/app_common.dart';
import '../utils/constants.dart';
import '../utils/images.dart';

class SubscribeScreen extends StatefulWidget {
  const SubscribeScreen({super.key});

  @override
  State<SubscribeScreen> createState() => _SubscribeScreenState();
}

class _SubscribeScreenState extends State<SubscribeScreen> {
  ScrollController scrollController = ScrollController();
  List<SubscriptionModel> mSubscriptionListNew = [];

  int page = 1;
  int? numPage;
  int? currentIndex = 0;
  int selectedIndex = -1;

  bool isLastPage = false;

  @override
  void initState() {
    super.initState();
    init();
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent && !appStore.isLoading) {
        if (page < numPage!) {
          page++;
          init();
        }
      }
    });
  }

  void init() async {
    getPackageData();
  }

  Future<void> getPackageData() async {
    appStore.setLoading(true);

    getSubscription().then((value) {

      numPage = value.pagination!.totalPages;
      isLastPage = false;
      if (page == 1) {
        mSubscriptionListNew.clear();
      }
      Iterable it = value.data!;
      it.map((e) => mSubscriptionListNew.add(e)).toList();
      print("----------->${mSubscriptionListNew.toString()}");
      appStore.setLoading(false);
      setState(() {});
    }).catchError((e) {
      isLastPage = true;
      appStore.setLoading(false);
      setState(() {});
    });
  }

  Future<void> paymentConfirm(int? id) async {
    appStore.setLoading(true);
    Map req = {"package_id": id, "payment_status": "paid", "payment_type": "", "txn_id": "", "transaction_detail": ""};
    await subscribePackageApi(req).then((value) async {
      getUSerDetail(context, userStore.userId).then((value) {
        setState(() {
          LiveStream().emit(PAYMENT);
          appStore.setLoading(false);
          finish(context, true);
        });
      });
    }).catchError((e) {
      appStore.setLoading(false);
      print(e.toString());
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
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
        appBar: AppBar(
            leading: Image.asset(ic_back, color: Colors.white, height: 18, width: 18).onTap(() {
              finish(context);
            }).paddingOnly(top: 18, bottom: 20),
            backgroundColor: primaryColor,
            elevation: 0,
            titleSpacing: 0,
            centerTitle: false,
            title: Text(language.subscriptionPlans, style: boldTextStyle(size: 18, color: Colors.white))),
        bottomNavigationBar: AppButton(
          text: language.subscribe,
          width: context.width(),
          color: primaryColor,
          onTap: () {
            selectedIndex == -1
                ? toast(language.pleaseSelectPlantContinue)
                : mSubscriptionListNew[selectedIndex].price == 0
                    ? paymentConfirm(mSubscriptionListNew[selectedIndex].id)
                    : PaymentScreen(
                        price: mSubscriptionListNew[selectedIndex].price,
                        id: mSubscriptionListNew[selectedIndex].id,
                      ).launch(context);
          },
        ).paddingSymmetric(horizontal: 16, vertical: 16),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Stack(
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
                    height: context.height() * 0.15,
                    width: context.width(),
                    decoration: boxDecorationWithRoundedCorners(borderRadius: radiusOnly(bottomRight: 14, bottomLeft: 14), backgroundColor: primaryColor),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(language.bePremiumGetUnlimitedAccess.capitalizeFirstLetter(), style: primaryTextStyle(size: 20, color: Colors.white), textAlign: TextAlign.center),
                        4.height,
                        Text(language.enjoyUnlimitedAccessWithoutAdsAndRestrictions.capitalizeFirstLetter(), style: primaryTextStyle(size: 14, color: Colors.white)),
                        20.height,
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      mSubscriptionListNew.isNotEmpty
                          ? ListView.builder(
                              physics: ScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: mSubscriptionListNew.length,
                              itemBuilder: (context, index) {
                                return Stack(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(bottom: 10, top: 20),
                                      decoration: boxDecorationWithRoundedCorners(
                                          borderRadius: radius(8),
                                          backgroundColor: selectedIndex == index
                                              ? primaryVariant
                                              : appStore.isDarkModeOn
                                                  ? context.cardColor
                                                  : primaryExtraLight),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          10.height,
                                          Row(
                                            children: [
                                              PriceWidget(price: mSubscriptionListNew[index].price!.toStringAsFixed(2), color: primaryColor, textStyle: boldTextStyle(size: 18, color: primaryColor)),
                                              4.width,
                                              Text(
                                                mSubscriptionListNew[index].durationUnit.toString().capitalizeFirstLetter(),
                                                style: primaryTextStyle(color: primaryColor, size: 18),
                                              )
                                            ],
                                          ),
                                          HtmlWidget(postContent: mSubscriptionListNew[index].description!.trim().validate(), color: grayColor, size: 14),
                                          Row(
                                            children: [
                                              Icon(Icons.circle, size: 8, color: selectedIndex == index ? Colors.black : textPrimaryColorGlobal),
                                              10.width,
                                              Text(language.viewPropertyLimit, style: primaryTextStyle(size: 14, color: selectedIndex == index ? Colors.black : textPrimaryColorGlobal)).expand(),
                                              mSubscriptionListNew[index].viewPropertyLimit == null
                                                  ? Text(language.unlimited, style: primaryTextStyle(size: 14, color: primaryColor))
                                                  : Text(mSubscriptionListNew[index].viewPropertyLimit.toString(), style: primaryTextStyle(size: 14, color: primaryColor)),
                                            ],
                                          ).paddingLeft(10),
                                          8.height,
                                          Row(
                                            children: [
                                              Icon(Icons.circle, size: 8, color: selectedIndex == index ? Colors.black : textPrimaryColorGlobal),
                                              10.width,
                                              Text(language.addPropertyLimit, style: primaryTextStyle(size: 14, color: selectedIndex == index ? Colors.black : textPrimaryColorGlobal)).expand(),
                                              mSubscriptionListNew[index].addPropertyLimit == null
                                                  ? Text(language.unlimited, style: primaryTextStyle(size: 14, color: primaryColor))
                                                  : Text(mSubscriptionListNew[index].addPropertyLimit.toString(), style: primaryTextStyle(size: 14, color: primaryColor)),
                                            ],
                                          ).paddingLeft(10),
                                          8.height,
                                          Row(
                                            children: [
                                              Icon(Icons.circle, size: 8, color: selectedIndex == index ? Colors.black : textPrimaryColorGlobal),
                                              10.width,
                                              Text(language.advertisementLimit, style: primaryTextStyle(size: 14, color: selectedIndex == index ? Colors.black : textPrimaryColorGlobal)).expand(),
                                              mSubscriptionListNew[index].advertisementLimit == null
                                                  ? Text(language.unlimited, style: primaryTextStyle(size: 14, color: primaryColor))
                                                  : Text(mSubscriptionListNew[index].advertisementLimit.toString(), style: primaryTextStyle(size: 14, color: primaryColor)),
                                            ],
                                          ).paddingLeft(10),
                                        ],
                                      ).paddingAll(16),
                                    ).onTap(() {
                                      setState(() {
                                        if (selectedIndex == index) {
                                          selectedIndex = -1;
                                        } else {
                                          selectedIndex = index;
                                        }
                                      });
                                      setState(() {});
                                    }),
                                    Positioned(
                                      left: 20,
                                      top: 10,
                                      child: Container(
                                        padding: EdgeInsets.symmetric(horizontal: 18, vertical: 4),
                                        decoration: boxDecorationWithRoundedCorners(borderRadius: radius(50), backgroundColor: Colors.black),
                                        child: Text(
                                          mSubscriptionListNew[index].name.validate().toUpperCase(),
                                          style: primaryTextStyle(color: Colors.white, size: 14),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              })
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(no_data, height: context.height() * 0.2, width: context.width() * 0.4),
                                16.height,
                                Text(language.noData, style: boldTextStyle()),
                              ],
                            ).center().visible(!appStore.isLoading),
                      // 30.height,
                    ],
                  ).paddingSymmetric(horizontal: 16, vertical: 16).paddingTop(context.statusBarHeight + 20),
                ],
              ),
            ),
            Observer(builder: (context) {
              return Loader().center().visible(appStore.isLoading);
            })
          ],
        ),
      ),
    );
  }
}
