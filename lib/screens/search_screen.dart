import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:geolocator/geolocator.dart';
import '../extensions/colors.dart';
import '../extensions/extension_util/string_extensions.dart';
import '../extensions/horizontal_list.dart';
import '../screens/property_detail_screen.dart';
import '../../components/app_bar_components.dart';
import '../../main.dart';
import '../components/advertisement_property_component.dart';
import '../components/premium_btn_component.dart';
import '../extensions/animatedList/animated_wrap.dart';
import '../extensions/app_text_field.dart';
import '../extensions/common.dart';
import '../extensions/decorations.dart';
import '../extensions/extension_util/int_extensions.dart';
import '../extensions/extension_util/widget_extensions.dart';
import '../extensions/loader_widget.dart';
import '../extensions/price_widget.dart';
import '../extensions/system_utils.dart';
import '../extensions/text_styles.dart';
import '../models/dashBoard_response.dart';
import '../network/RestApis.dart';
import '../utils/app_common.dart';
import '../utils/colors.dart';
import '../utils/images.dart';
import 'dashboard_screen.dart';
import 'filter_screen.dart';

class SearchScreen extends StatefulWidget {
  final double? budgetMinPrice;
  final double? budgetMaxPrice;
  final int? bhkSend;
  final int? selectCategory;
  final List<Property>? mPropertyData;
  final bool isBack;
  final int? propertyId;
  final String? propertySince;
  final num? latitude;
  final num? longitude;
  bool? isFilter;


  SearchScreen(
      {this.budgetMaxPrice,
      this.budgetMinPrice,
      this.bhkSend,
      this.selectCategory,
      this.longitude,
      this.latitude,
      this.propertyId,
      this.propertySince,
      this.isFilter,
      this.mPropertyData,
      this.isBack = false,});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<Property> mergePropertyData = [];

  List<String> list = [];
  num? latitude;
  num? longitude;

  ScrollController scrollController = ScrollController();
  TextEditingController mSearchCont = TextEditingController();

  FocusNode search = FocusNode();

  String? mSearchValue = '';

  int page = 1;
  int? numPage;

  bool isLastPage = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  searchPropertyApi() async {
    Map req = {
      "search": mSearchValue,
      "latitude": latitude,
      "longitude": longitude
    };
    appStore.setLoading(true);
    searchProperty(req).then((value) {
      print(req);
      appStore.setLoading(false);
      mergePropertyData.clear();
      Iterable its = value.propertyData!;
      Iterable it = value.nearByProperty!;
      its.map((e) => mergePropertyData.add(e)).toList();
      it.map((e) => mergePropertyData.add(e)).toList();

      if (!mSearchCont.text.isEmptyOrNull)
        userStore.addToRecentSearchList(mSearchValue.toString());

      setState(() {});
    }).catchError((error) {
      appStore.setLoading(false);
      log(error);
    });
  }
  init() async {
    if (widget.isFilter == true) mergePropertyData.clear();
  }

  Future<void> _getCurrentLocation() async {
    try {
      appStore.setLoading(true);
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        latitude = position.latitude;
        longitude = position.longitude;

        if (latitude != null && longitude != null) {
          searchPropertyApi();
        }
      });
    } catch (e) {}
  }

  void searchAndUpdateList(String value) {
    setState(() {
      mSearchValue = value.trim();
      if (value.isNotEmpty && !userStore.mRecentSearchList.contains(value)) {
        userStore.mRecentSearchList.remove(mSearchValue);
        userStore.mRecentSearchList.insert(0, mSearchValue!);
      }
    });
  }

  void _removeFromUniqueValues(String valueToRemove) {
    setState(() {
      userStore.mRecentSearchList.remove(valueToRemove);
    });
  }



  setFavouriteApi(int? id, int? isFavourite) async {
    appStore.setLoading(true);
    Map req = {
      "property_id": id,
    };
    setFavouriteProperty(req).then((value) async {
      appStore.setLoading(false);
      if (isFavourite == 1) {
        isFavourite = 0;
      } else {
        isFavourite = 1;
      }

      appStore.setLoading(false);

      toast(value.message);
      setState(() {});
    }).catchError((error) {
      appStore.setLoading(false);
      toast(error.toString());
    });
    setState(() {});
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(onWillPop: () async {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => DashboardScreen()),
          (route) => true);

      return true;
    }, child: Observer(builder: (context) {
      return Scaffold(
        appBar: appBarWidget("",
            context1: context,
            titleSpace: 0,
            showBack: true,
            backWidget: Icon(
                    appStore.selectedLanguage == 'ar'
                        ? MaterialIcons.arrow_forward_ios
                        : Octicons.chevron_left,
                    color: primaryColor,
                    size: 28)
                .onTap(() {
              if (widget.isBack == false) {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => DashboardScreen()),
                    (route) => true);
              } else {
                finish(context);
              }
            })),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    decoration: boxDecorationWithRoundedCorners(
                        borderRadius: radius(10),
                        backgroundColor: appStore.isDarkModeOn
                            ? cardDarkColor
                            : primaryExtraLight),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(ic_magnifier, height: 30, width: 20),
                        10.width,
                        AppTextField(
                          focus: search,
                          controller: mSearchCont,
                          textStyle: primaryTextStyle(),
                          textFieldType: TextFieldType.OTHER,
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(0),
                              border: InputBorder.none,
                              hintText: language.searchLocation,
                              hintStyle: primaryTextStyle(color: grey)),
                          onFieldSubmitted: (v) {
                            mSearchValue = v;
                            latitude = 0.0;
                            longitude = 0.0;

                            searchAndUpdateList(v.trim());

                            searchPropertyApi();

                            widget.isFilter = false;
                            setState(() {});
                          },
                        ).expand(),
                        Image.asset(ic_filter, height: 20, width: 20).onTap(() {
                          FilterScreen(isSelect: false).launch(context);
                        })
                      ],
                    ),
                  ),
                  20.height,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        Icon(Icons.my_location_sharp, color: primaryColor),
                        10.width,
                        Text(language.useMyCurrentLocation,
                            style: boldTextStyle(color: primaryColor)),
                      ]).onTap(() {
                        mSearchValue = '';

                        _getCurrentLocation();
                        widget.isFilter = false;
                        setState(() {});
                      }),
                      18.height,
                      Stack(
                        children: [
                          mSearchCont.text.isEmpty &&
                                  latitude == null &&
                                  longitude == null
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                      Text(language.recentSearch,
                                              style:
                                                  secondaryTextStyle(size: 18))
                                          .visible(userStore
                                              .mRecentSearchList.isNotEmpty),
                                      20.height,
                                      HorizontalList(
                                          padding: EdgeInsets.all(0),
                                          itemCount: 1,
                                          itemBuilder: (context, i) {
                                            return AnimatedWrap(
                                              runSpacing: 16,
                                              spacing: 16,
                                              children: List.generate(
                                                  userStore.mRecentSearchList
                                                      .length, (index) {
                                                final item = userStore
                                                    .mRecentSearchList[index];
                                                return Container(
                                                  padding: EdgeInsets.all(10),
                                                  decoration:
                                                      boxDecorationWithRoundedCorners(
                                                          borderRadius:
                                                              radius(30),
                                                          backgroundColor: appStore
                                                                  .isDarkModeOn
                                                              ? cardDarkColor
                                                              : primaryExtraLight),
                                                  child: Row(
                                                    children: [
                                                      Icon(Icons.close,
                                                              color:
                                                                  primaryColor)
                                                          .onTap(() {
                                                        userStore
                                                            .clearSearchList(
                                                                item);
                                                        init();
                                                        setState(() {});
                                                      }),
                                                      10.width,
                                                      Text(item,
                                                          style:
                                                              primaryTextStyle())
                                                    ],
                                                  ),
                                                ).onTap(() {
                                                  mSearchCont.text =
                                                      item.toString();
                                                  mSearchValue =
                                                      mSearchCont.text;
                                                  _removeFromUniqueValues(item);
                                                  searchPropertyApi();
                                                });
                                              }),
                                            );
                                          }),
                                    ])
                              : mergePropertyData.isNotEmpty
                                  ? ListView.builder(
                                      physics: ScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: mergePropertyData.length,
                                      itemBuilder: (context, index) {
                                        return AdvertisementPropertyComponent(
                                          property: mergePropertyData[index],
                                          isFullWidth: true,
                                          onCall: () {},
                                        ).onTap(() async {
                                          bool? res =
                                              await PropertyDetailScreen(
                                                      propertyId:
                                                          mergePropertyData[
                                                                  index]
                                                              .id)
                                                  .launch(context);
                                          if (res == true) {
                                            searchPropertyApi();
                                            setState(() {});
                                          }
                                        }).paddingSymmetric(vertical: 8);
                                      })
                                  : Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                          Align(
                                              alignment: Alignment.topLeft,
                                              child: Text(language.foundState,
                                                  style: primaryTextStyle(),
                                                  textAlign: TextAlign.start)),
                                          40.height,
                                          Image.asset(ic_no_search_found,
                                                  height: 150, width: 200)
                                              .center(),
                                          20.height,
                                          Text(language.searchNotFound,
                                                  style: boldTextStyle())
                                              .center(),
                                          20.height,
                                          Text(
                                            language.searchMsg
                                                .capitalizeFirstLetter(),
                                            style: secondaryTextStyle(),
                                            textAlign: TextAlign.center,
                                          ).paddingSymmetric(horizontal: 16)
                                        ]).paddingSymmetric(vertical: 16),
                          widget.mPropertyData != null
                              ? ListView.builder(
                                  physics: ScrollPhysics(),
                                  padding: EdgeInsets.symmetric(horizontal: 0),
                                  shrinkWrap: true,
                                  itemCount: widget.mPropertyData!.length,
                                  itemBuilder: (context, i) {
                                    return Container(
                                      margin: EdgeInsets.only(bottom: 16),
                                      decoration:
                                          boxDecorationWithRoundedCorners(
                                        borderRadius: radius(12),
                                        backgroundColor: appStore.isDarkModeOn
                                            ? cardDarkColor
                                            : primaryExtraLight,
                                      ),
                                      child: Row(children: [
                                        Stack(
                                          children: [
                                            cachedImage(
                                                    widget.mPropertyData![i]
                                                        .propertyImage,
                                                    height: 155,
                                                    width: 110,
                                                    fit: BoxFit.fill)
                                                .cornerRadiusWithClipRRectOnly(
                                                    bottomLeft: 12,
                                                    topLeft: 12),
                                            Positioned(
                                              bottom: 10,
                                              left: 6,
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                    vertical: 5),
                                                decoration:
                                                    boxDecorationWithRoundedCorners(
                                                        borderRadius: radius(4),
                                                        backgroundColor:
                                                            primaryLight),
                                                child: Text(
                                                    widget.mPropertyData![i]
                                                                .propertyFor ==
                                                            0
                                                        ? language.forRent
                                                        : widget
                                                                    .mPropertyData![
                                                                        i]
                                                                    .propertyFor ==
                                                                1
                                                            ? language.forSell
                                                            : language.pg,
                                                    style: primaryTextStyle(
                                                        color: primaryColor,
                                                        size: 12)),
                                              ),
                                            ),
                                            if (userStore.subscription == "1" &&
                                                widget.mPropertyData![i]
                                                        .premiumProperty ==
                                                    1)
                                              Positioned(
                                                top: 0,
                                                left: 0,
                                                child:
                                                    PremiumBtn(pDetail: true),
                                              ),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                PriceWidget(
                                                        price: formatNumberString(
                                                            widget
                                                                .mPropertyData![
                                                                    i]
                                                                .price!),
                                                        textStyle: boldTextStyle(
                                                            size: 18,
                                                            color:
                                                                primaryColor))
                                                    .expand(),
                                                fevIconWidget(
                                                        widget.mPropertyData![i]
                                                            .isFavourite,
                                                        context)
                                                    .onTap(() {
                                                  setFavouriteApi(
                                                      widget
                                                          .mPropertyData![i].id,
                                                      widget.mPropertyData![i]
                                                          .isFavourite);

                                                  if (widget.mPropertyData![i]
                                                          .isFavourite ==
                                                      1) {
                                                    widget.mPropertyData![i]
                                                        .isFavourite = 0;
                                                  } else {
                                                    widget.mPropertyData![i]
                                                        .isFavourite = 1;
                                                  }
                                                  setState(() {});
                                                })
                                              ],
                                            ),
                                            8.height,
                                            Row(
                                              children: [
                                                Image.asset(ic_property,
                                                    height: 20,
                                                    width: 20,
                                                    color: primaryColor),
                                                5.width,
                                                Text(
                                                    widget.mPropertyData![i]
                                                        .category
                                                        .toString(),
                                                    style: secondaryTextStyle())
                                              ],
                                            ),
                                            8.height,
                                            Text(
                                                widget.mPropertyData![i].name
                                                    .validate()
                                                    .capitalizeFirstLetter(),
                                                style: primaryTextStyle()),
                                            8.height,
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Image.asset(ic_map_point,
                                                    height: 20, width: 20),
                                                5.width,
                                                Text(
                                                  widget
                                                      .mPropertyData![i].address
                                                      .validate(),
                                                  style: secondaryTextStyle(),
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ).expand()
                                              ],
                                            ),
                                          ],
                                        )
                                            .paddingSymmetric(
                                                horizontal: 15, vertical: 0)
                                            .expand()
                                      ]),
                                    ).onTap(() async {
                                      bool? res = await PropertyDetailScreen(
                                              propertyId:
                                                  widget.mPropertyData![i].id)
                                          .launch(context);

                                      if (res == true) {
                                        init();
                                        setState(() {});
                                      }
                                    });
                                  }).visible(widget.isFilter == true)
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                      Text(language.foundState,
                                          style: primaryTextStyle(),
                                          textAlign: TextAlign.start),
                                      40.height,
                                      Image.asset(ic_no_search_found,
                                              height: 150, width: 200)
                                          .center(),
                                      20.height,
                                      Text(language.searchNotFound,
                                              style: boldTextStyle())
                                          .center(),
                                      20.height,
                                      Text(
                                        language.searchMsg,
                                        style: secondaryTextStyle(),
                                        textAlign: TextAlign.center,
                                      ).paddingSymmetric(horizontal: 16)
                                    ]).visible(widget.isFilter == true),
                          Stack(
                            children: [],
                          ).visible(widget.isFilter == true),
                        ],
                      )
                    ],
                  )
                ],
              ).paddingSymmetric(horizontal: 16),
            ),
            Loader().center().visible(appStore.isLoading)
          ],
        ),
      );
    }));
  }
}
