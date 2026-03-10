import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../components/boost_dialog.dart';
import '../extensions/animatedList/animated_list_view.dart';
import '../extensions/extension_util/bool_extensions.dart';
import '../extensions/extension_util/context_extensions.dart';
import '../extensions/extension_util/int_extensions.dart';
import '../extensions/extension_util/string_extensions.dart';
import '../extensions/extension_util/widget_extensions.dart';
import '../extensions/loader_widget.dart';
import '../components/add_property_dialouge.dart';
import '../components/app_bar_components.dart';
import '../components/limit_exceed_dialog.dart';
import '../components/premium_btn_component.dart';
import '../extensions/app_button.dart';
import '../extensions/colors.dart';
import '../extensions/common.dart';
import '../extensions/decorations.dart';
import '../extensions/price_widget.dart';
import '../extensions/system_utils.dart';
import '../extensions/text_styles.dart';
import '../main.dart';
import '../models/dashBoard_response.dart';
import '../network/RestApis.dart';
import '../utils/app_common.dart';
import '../utils/colors.dart';
import '../utils/images.dart';
import 'limit_screen.dart';
import 'property_detail_screen.dart';
import 'subscribe_screen.dart';

class MyPropertiesScreen extends StatefulWidget {
  @override
  State<MyPropertiesScreen> createState() => _MyPropertiesScreenState();
}

class _MyPropertiesScreenState extends State<MyPropertiesScreen> {
  // List<String> propertyForList = [language.rent, language.sell, language.pg];
  List<String> propertyForList = [language.rent, language.sell];
  List<Property> mPropertyDataRent = [];
  List<Property> mPropertyDataSell = [];
  // List<Property> mPropertyDataPg = [];
  List<Property> mMyPropertiesData = [];

  int page = 1;
  int? numPage;
  int? currentIndex = 0;
  int? paymentId;
  int currentPage = 1;
  int property_for = 0;

  num? paymentPrice;

  bool isLastPage = false;
  bool select = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    await getMyProperty();
  }

  getMyProperty({bool? paginationCall}) async {
    appStore.setLoading(true);
    setState(() {}); // Ensure UI updates immediately to show the loader

    await getMyPropertiesApi(currentPage: currentPage, property_for: property_for).then((value) {
      isLastPage = value.data!.length < currentPage;

      if (currentPage == 1) {
        mMyPropertiesData.clear();
      }

      if(paginationCall==true){
        mMyPropertiesData.addAll(value.data!);
      }else{
        mMyPropertiesData = value.data!;
        mPropertyDataRent.clear();
        mPropertyDataSell.clear();
        // mPropertyDataPg.clear();
      }

      mMyPropertiesData.forEach((e) {
        if (e.propertyFor == 0) {
          mPropertyDataRent.add(e);
        } else if (e.propertyFor == 1) {
          mPropertyDataSell.add(e);
        } else {
          // mPropertyDataPg.add(e);
        }
      });

      appStore.setLoading(false);
      setState(() {});
    }).catchError((e) {
      appStore.setLoading(false);
      setState(() {});
    });
  }


  setFavouriteApi(int? id, int? isFavourite) async {
    appStore.setLoading(true);
    Map req = {
      "property_id": id,
    };
    appStore.setLoading(true);
    setFavouriteProperty(req).then((value) async {
      appStore.setLoading(false);
      if (isFavourite == 1) {
        isFavourite = 0;
      } else {
        isFavourite = 1;
      }
      setState(() {
        getMyProperty();
      });
      appStore.setLoading(false);
    }).catchError((error) {
      appStore.setLoading(false);
      toast(error.toString());
    });
  }

  setAdvertisement(int? id, int? advertisementProperty) async {
    appStore.setLoading(true);
    Map req = {
      "id": id,
    };
    appStore.setLoading(true);
    setPropertyAdvertisement(req).then((value) async {
      await getUSerDetail(context, userStore.userId);
      if (advertisementProperty == 1) {
        advertisementProperty = 0;
      } else {
        advertisementProperty = 1;
      }
      appStore.setLoading(false);
      getMyProperty();
      setState(() {});
      appStore.setLoading(false);
    }).catchError((error) {
      appStore.setLoading(false);
      toast(error.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      return DefaultTabController(
        length: propertyForList.length,
        child: Scaffold(
          appBar: appBarWidget(
            titleSpace: 0,
            language.myProperty,
            context1: context,
            bottom: TabBar(
              padding: EdgeInsets.only(left: 10, right: 10),
              indicator: BoxDecoration(borderRadius: radius(), color: primaryColor),
              labelColor: Colors.white,
              indicatorPadding: EdgeInsets.symmetric(horizontal: 10),
              labelPadding: EdgeInsets.symmetric(horizontal: 10),
              indicatorSize: TabBarIndicatorSize.tab,
              physics: NeverScrollableScrollPhysics(),
              unselectedLabelColor: primaryColor,
              onTap: (v) {
                appStore.setLoading(true);
                currentIndex = v;

                // mPropertyDataRent.clear();
                // mPropertyDataSell.clear();
                // mPropertyDataPg.clear();

                property_for=v;
                currentPage=1;

                getMyProperty();
                // mMyPropertiesData.forEach((e) {
                //   if (e.propertyFor == 0) {
                //     mPropertyDataRent.add(e);
                //   } else if (e.propertyFor == 1) {
                //     mPropertyDataSell.add(e);
                //   } else {
                //     mPropertyDataPg.add(e);
                //   }
                // });
                // appStore.setLoading(false);
                setState(() {});
              },
              labelStyle: boldTextStyle(color: Colors.white, size: 14),
              tabs: propertyForList.map((e) {
                return Tab(
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(e),
                    decoration: boxDecorationWithRoundedCorners(backgroundColor: primaryColor.withOpacity(0.1)),
                  ),
                );
              }).toList(),
            ),
          ),
          body: TabBarView(
            physics: NeverScrollableScrollPhysics(),
            children: propertyForList.map((e) {
              if (currentIndex == 0) {
                return propertyList(mPropertyData: mPropertyDataRent).paddingOnly(top: 16);
              } else if (currentIndex == 1) {
                return propertyList(mPropertyData: mPropertyDataSell).paddingOnly(top: 16);
              } else {
                return SizedBox();
                // return propertyList(mPropertyData: mPropertyDataPg).paddingOnly(top: 16);
              }
            }).toList(),
          ),
          bottomNavigationBar: AppButton(
            splashColor: Colors.transparent,
            hoverColor: Colors.transparent,
            focusColor: Colors.transparent,
            text: language.addNew,
            width: context.width(),
            color: primaryColor,
            elevation: 0,
            onTap: () {
              userStore.subscription == "1"
                  ? userStore.isSubscribe != 0
                  ? userStore.subscriptionDetail!.subscriptionPlan!.packageData!.addProperty == 0
                  ? showDialog(
                context: context,
                builder: (context) {
                  return userStore.addLimitCount == 0
                      ? LimitExceedDialog(
                    onTap: () {
                      LimitScreen(limit: "add_property").launch(context);
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
          ).paddingAll(16),
        ),
      );
    });
  }

  Widget propertyList({required List<Property> mPropertyData}) {
    if (appStore.isLoading) return Loader(); // Always show loader first

    return Stack(
      children: [
        if (mPropertyData.isNotEmpty)
          AnimatedListView(
            physics: ScrollPhysics(),
            shrinkWrap: true,
            onNextPage: () {
              if (!isLastPage) {
                appStore.setLoading(true);
                currentPage++;
                setState(() {});
                getMyProperty(paginationCall:true);
                // init();
              }
            },
            itemCount: mPropertyData.length,
            itemBuilder: (context, i) {
              Property data = mPropertyData[i];
              return Container(
                margin: EdgeInsets.only(bottom: 16),
                decoration: boxDecorationWithRoundedCorners(
                  borderRadius: radiusOnly(topLeft: 12, topRight: 12),
                  backgroundColor: appStore.isDarkModeOn ? cardDarkColor : primaryExtraLight,
                ),
                child:
                Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            cachedImage(data.propertyImage.validate(), height: 145, fit: BoxFit.cover, width: 130).cornerRadiusWithClipRRectOnly(topLeft: 12),
                            if (userStore.subscription == "1" && data.premiumProperty == 1) Positioned(top: 0, left: 0, child: PremiumBtn(pDetail: true)),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                PriceWidget(price: formatNumberString(data.price.validate()), textStyle: boldTextStyle(size: 18, color: primaryColor)).expand(),
                                fevIconWidget(data.isFavourite,context).onTap(() {
                                  setState(() {
                                    setFavouriteApi(data.id, data.isFavourite);
                                  });
                                }),
                              ],
                            ),
                            Text(data.name.validate().capitalizeFirstLetter(), style: primaryTextStyle(size: 16, color: appStore.isDarkModeOn ? lightBackgroundColor : Colors.black)),
                            8.height,
                            Row(
                              children: [
                                Image.asset(ic_property, height: 18, width: 18,color: primaryColor),
                                4.width,
                                Text(data.category.validate(), style: secondaryTextStyle()),
                              ],
                            ),
                            8.height,
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.asset(ic_map_point, width: 16, height: 16, color: grey),
                                4.width,
                                Text(data.address.validate(), maxLines: 3, overflow: TextOverflow.ellipsis, style: secondaryTextStyle()).expand(),
                              ],
                            ),
                          ],
                        ).paddingSymmetric(horizontal: 14, vertical: 10).expand(),
                      ],
                    ),
                    Container(
                      width: context.width(),
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      decoration:
                      boxDecorationWithRoundedCorners(backgroundColor: data.advertisementProperty == 1 ? boostBgColor : primaryColor, borderRadius: radiusOnly(bottomLeft: 12, bottomRight: 12)),
                      child: Text(data.advertisementProperty == 1 ? language.alreadyBoostedYourProperty : language.boostYourProperty,
                          style: primaryTextStyle(color: Colors.white), textAlign: TextAlign.end)
                          .center(),
                    ).onTap(() {
                      paymentId = data.id;
                      paymentPrice = data.price;
                      setState(() {
                        if (userStore.subscription == "1") {
                          if (userStore.isSubscribe != 0) {
                            if (data.advertisementProperty == null && userStore.subscriptionDetail!.subscriptionPlan!.packageData!.advertisement.validate() == 0) {
                              if (userStore.advertisement == 0) {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return LimitExceedDialog(
                                        onTap: () {
                                          finish(context);
                                          LimitScreen(limit: "advertisement_property").launch(context);
                                        },
                                      );
                                    });
                              } else {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return BoostDialog(onAccept: () {
                                        setState(() {
                                          setAdvertisement(data.id, data.advertisementProperty);
                                          finish(context);
                                        });
                                      });
                                    });
                              }
                            }
                          } else {
                            SubscribeScreen().launch(context);
                          }
                        } else {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return BoostDialog(onAccept: () {
                                  setState(() {
                                    setAdvertisement(data.id, data.advertisementProperty);
                                    finish(context);
                                  });
                                });
                              });
                        }
                      });
                    })
                  ],
                ),
              ).paddingSymmetric(horizontal: 16).onTap(()async{
                {
                  bool? res = await PropertyDetailScreen(propertyId: data.id, update: true, onTap: (bool? result) {}).launch(context);
                  if (res.validate()) {
                    getMyProperty();
                  }
                }
              });
            },
          ),
        if (mPropertyData.isEmpty && !appStore.isLoading)  Loader(),
        if(mPropertyData.isEmpty) emptyWidget()
      ],
    );
  }
}
