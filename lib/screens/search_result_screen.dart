import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../components/app_bar_components.dart';
import '../components/premium_btn_component.dart';
import '../extensions/colors.dart';
import '../extensions/extension_util/int_extensions.dart';
import '../extensions/extension_util/string_extensions.dart';
import '../extensions/extension_util/widget_extensions.dart';
import '../extensions/price_widget.dart';
import '../screens/property_detail_screen.dart';
import '../utils/app_common.dart';
import '../extensions/app_text_field.dart';
import '../extensions/common.dart';
import '../extensions/decorations.dart';
import '../extensions/loader_widget.dart';
import '../extensions/system_utils.dart';
import '../extensions/text_styles.dart';
import '../main.dart';
import '../models/dashBoard_response.dart';
import '../network/RestApis.dart';
import '../utils/colors.dart';
import '../utils/images.dart';

class SearchResultScreen extends StatefulWidget {
  final double? budgetMinPrice;
  final double? budgetMaxPrice;
  final int? bhkSend;
  final int? selectCategory;
  final bool? title;
  final bool? title1;
  final int? bhk;

  SearchResultScreen({
    this.budgetMaxPrice,
    this.budgetMinPrice,
    this.bhkSend,
    this.selectCategory,
    this.title,
    this.title1,
    this.bhk,
  });

  @override
  State<SearchResultScreen> createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends State<SearchResultScreen> {
  TextEditingController mSearchCont = TextEditingController();
  List<Property> filterProperty = [];
  ScrollController scrollController = ScrollController();

  String? mSearchValue = "";
  String title = "";
  String title1 = "";

  List<Property> mPropertyData = [];
  int page = 1;
  int? numPage;

  bool isLastPage = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero).then((val) {
      appStore.setLoading(true);
      init();
      scrollController.addListener(() {
        if (scrollController.position.pixels == scrollController.position.maxScrollExtent && !appStore.isLoading) {
          if (page < numPage!) {
            page++;
            filterData();
          }
        }
      });
    });
  }

  init() async {
    if (widget.title == true) {
      title = " for " + widget.bhk.toString() + " room";
    } else if (widget.title1 == true) {
      title = " for budget";
    } else {
      title = " for category";
    }
    await filterData();
  }

  Future<void> filterData() async {
    Map req = {
      "category_id": widget.selectCategory,
      "start_price": widget.budgetMinPrice,
      "end_price": widget.budgetMaxPrice,
      "bhk": widget.bhkSend,
    };

    appStore.setLoading(true);
    await filterApi(req, page: page).then((value) {
      numPage = value.pagination!.totalPages;
      isLastPage = false;
      if (page == 1) {
        filterProperty.clear();
      }
      Iterable it = value.property!;
      it.map((e) => filterProperty.add(e)).toList();
      appStore.setLoading(false);
      setState(() {});
    }).catchError((e) {
      isLastPage = true;
      appStore.setLoading(false);
      print(e.toString());
      setState(() {});
    });
  }

  setFavouriteApi(int? id, int? isFavourite) async {
    appStore.setLoading(true);
    Map req = {
      "property_id": id,
    };
    await setFavouriteProperty(req).then((value) async {
      appStore.setLoading(false);
      toast(value.message);
      await filterData();
    }).catchError((error) {
      appStore.setLoading(false);
      toast(error.toString());
    });
    setState(() {});
  }

  searchPropertyApi() async {
    Map req = {"search": mSearchValue};
    appStore.setLoading(true);
    searchProperty(req).then((value) {
      setState(() {
        appStore.setLoading(false);
      });

      mPropertyData.clear();
      Iterable it = value.propertyData!;
      it.map((e) => mPropertyData.add(e)).toList();

      setState(() {});
    }).catchError((error) {
      appStore.setLoading(false);
      log(error.toString());
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Observer(builder: (context) {
        return AnnotatedRegion(
          value: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: appStore.isDarkModeOn ? Brightness.light : Brightness.light,
            systemNavigationBarIconBrightness: appStore.isDarkModeOn ? Brightness.light : Brightness.light,
          ),
          child: Scaffold(
            appBar: appBarWidget(
              language.searchResult + title,
              context1: context,
              titleSpace: 0,
              showBack: true,
            ),
            body: Stack(
              children: [
                SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        decoration: boxDecorationWithRoundedCorners(
                          borderRadius: radius(10),
                          backgroundColor: appStore.isDarkModeOn ? cardDarkColor : primaryExtraLight,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              ic_magnifier,
                              height: 30,
                              width: 20,
                            ),
                            10.width,
                            AppTextField(
                              controller: mSearchCont,
                              textStyle: primaryTextStyle(),
                              textFieldType: TextFieldType.OTHER,
                              onChanged: (v) {
                                mSearchValue = v;
                                page = 1; // Reset page when new search
                                appStore.setLoading(true);
                                filterProperty.clear();
                                searchPropertyApi();
                                setState(() {});
                              },
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(0),
                                fillColor: appStore.isDarkModeOn ? cardDarkColor : primaryExtraLight,
                                filled: true,
                                border: InputBorder.none,
                                hintText: language.search,
                                hintStyle: primaryTextStyle(color: grey),
                              ),
                            ).expand(),
                          ],
                        ),
                      ).paddingSymmetric(horizontal: 16),
                      10.height,
                      filterProperty.isNotEmpty
                          ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          10.height,
                          Text(
                            language.found + " " + filterProperty.length.toString() + " " + language.estates,
                            style: primaryTextStyle(),
                          ).paddingSymmetric(horizontal: 16).visible(userStore.mRecentSearchList.isNotEmpty),
                          20.height.visible(userStore.mRecentSearchList.isNotEmpty),
                          ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            shrinkWrap: true,
                            itemCount: filterProperty.length,
                            itemBuilder: (context, i) {
                              return Container(
                                margin: EdgeInsets.only(bottom: 16),
                                decoration: boxDecorationWithRoundedCorners(
                                  borderRadius: radius(12),
                                  backgroundColor: appStore.isDarkModeOn ? cardDarkColor : primaryExtraLight,
                                ),
                                child: Row(
                                  children: [
                                    Stack(
                                      children: [
                                        cachedImage(filterProperty[i].propertyImage,
                                            height: 155, width: 110, fit: BoxFit.fill)
                                            .cornerRadiusWithClipRRectOnly(topLeft: 12, bottomLeft: 12),
                                        Positioned(
                                          bottom: 10,
                                          left: 6,
                                          child: Container(
                                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                            decoration: boxDecorationWithRoundedCorners(
                                              borderRadius: radius(4),
                                              backgroundColor: primaryLight,
                                            ),
                                            child: Text(
                                              filterProperty[i].propertyFor == 0
                                                  ? language.forRent
                                                  : filterProperty[i].propertyFor == 1
                                                  ? language.forSell
                                                  : language.pg,
                                              style: primaryTextStyle(color: primaryColor, size: 12),
                                            ),
                                          ),
                                        ),
                                        if (userStore.subscription == "1" && filterProperty[i].premiumProperty == 1)
                                          Positioned(
                                            top: 0,
                                            left: 0,
                                            child: PremiumBtn(pDetail: true),
                                          ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            PriceWidget(
                                              price: formatNumberString(filterProperty[i].price!),
                                              textStyle: boldTextStyle(size: 18, color: primaryColor),
                                            ).expand(),
                                            fevIconWidget(filterProperty[i].isFavourite, context).onTap(() {
                                              setFavouriteApi(filterProperty[i].id, filterProperty[i].isFavourite);
                                              setState(() {});
                                            })
                                          ],
                                        ),
                                        8.height,
                                        Row(
                                          children: [
                                            Image.asset(ic_property, height: 20, width: 20, color: primaryColor),
                                            4.width,
                                            Text(filterProperty[i].category.toString(), style: secondaryTextStyle()),
                                          ],
                                        ),
                                        8.height,
                                        Text(filterProperty[i].name.validate(), style: primaryTextStyle()),
                                        8.height,
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Image.asset(ic_map_point, height: 20, width: 20),
                                            4.width,
                                            Text(
                                              filterProperty[i].address.validate(),
                                              style: secondaryTextStyle(),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ).expand()
                                          ],
                                        ),
                                      ],
                                    ).paddingSymmetric(horizontal: 15, vertical: 0).expand()
                                  ],
                                ),
                              ).onTap(() async {
                                bool? res = await PropertyDetailScreen(propertyId: filterProperty[i].id).launch(context);
                                if (res == true) {
                                  page = 1;
                                  await filterData();
                                  setState(() {});
                                }
                              });
                            },
                          ),
                          if (page < numPage! && !isLastPage)
                            Padding(
                              padding: EdgeInsets.all(16),
                              child: Loader().center(),
                            ),
                        ],
                      )
                          : mPropertyData.isNotEmpty
                          ? ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        shrinkWrap: true,
                        itemCount: mPropertyData.length,
                        itemBuilder: (context, i) {
                          return Container(
                            margin: EdgeInsets.only(bottom: 16),
                            decoration: boxDecorationWithRoundedCorners(
                              borderRadius: radius(12),
                              backgroundColor: appStore.isDarkModeOn ? cardDarkColor : primaryExtraLight,
                            ),
                            child: Row(children: [
                              Stack(
                                children: [
                                  cachedImage(mPropertyData[i].propertyImage, height: 155, width: 110, fit: BoxFit.fill)
                                      .cornerRadiusWithClipRRectOnly(topLeft: 12, bottomLeft: 12),
                                  Positioned(
                                    bottom: 10,
                                    left: 6,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                      decoration: boxDecorationWithRoundedCorners(
                                          borderRadius: radius(4),
                                          backgroundColor: appStore.isDarkModeOn ? cardDarkColor : primaryLight),
                                      child: Text(
                                          mPropertyData[i].propertyFor == 0
                                              ? language.forRent
                                              : mPropertyData[i].propertyFor == 1
                                              ? language.forSell
                                              : language.pgCoLiving,
                                          style: primaryTextStyle(color: primaryColor, size: 12)),
                                    ),
                                  ),
                                  if (userStore.subscription == "1" && mPropertyData[i].premiumProperty == 1)
                                    Positioned(
                                      top: 0,
                                      left: 0,
                                      child: PremiumBtn(pDetail: true),
                                    ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                                    PriceWidget(
                                      price: formatNumberString(mPropertyData[i].price!),
                                      textStyle: boldTextStyle(size: 18, color: primaryColor),
                                    ).expand(),
                                    fevIconWidget(mPropertyData[i].isFavourite, context).onTap(() {
                                      setFavouriteApi(mPropertyData[i].id, mPropertyData[i].isFavourite);
                                      searchPropertyApi();
                                      setState(() {});
                                    })
                                  ]),
                                  10.height,
                                  Row(
                                    children: [
                                      Image.asset(ic_property, height: 20, width: 20),
                                      5.width,
                                      Text(mPropertyData[i].category.toString(), style: secondaryTextStyle()),
                                    ],
                                  ),
                                  10.height,
                                  Text(mPropertyData[i].name.capitalizeFirstLetter().validate(), style: primaryTextStyle()),
                                  10.height,
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Image.asset(ic_map_point, height: 20, width: 20),
                                      5.width,
                                      Text(
                                        mPropertyData[i].address.validate(),
                                        style: secondaryTextStyle(),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ).expand()
                                    ],
                                  ),
                                ],
                              ).paddingSymmetric(horizontal: 15, vertical: 10).expand()
                            ]),
                          ).onTap(() async {
                            bool? res = await PropertyDetailScreen(propertyId: mPropertyData[i].id).launch(context);
                            if (res == true) {
                              page = 1;
                              await filterData();
                              setState(() {});
                            }
                          });
                        },
                      )
                          : Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Align(
                              alignment: Alignment.topLeft,
                              child: Text(language.foundState, style: primaryTextStyle(), textAlign: TextAlign.start)),
                          40.height,
                          Image.asset(ic_no_search_found, height: 150, width: 200).center(),
                          20.height,
                          Text(language.searchNotFound, style: boldTextStyle()).center(),
                          20.height,
                          Text(
                            language.searchMsg.capitalizeFirstLetter() + title,
                            style: secondaryTextStyle(),
                            textAlign: TextAlign.center,
                          ).paddingSymmetric(horizontal: 16)
                        ],
                      ).visible(filterProperty.isEmpty && mPropertyData.isEmpty && !appStore.isLoading).paddingSymmetric(horizontal: 16, vertical: 16),
                      20.height,
                    ],
                  ),
                ),
                Loader().center().visible(appStore.isLoading),
              ],
            ),
          ),
        );
      }),
    );
  }
}