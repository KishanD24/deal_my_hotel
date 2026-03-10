import 'dart:async';
import 'dart:math';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:developer' as d;
import '../components/advertisement_property_component.dart';
import '../components/waves_animaiton.dart';
import '../extensions/colors.dart';
import '../extensions/extension_util/context_extensions.dart';
import '../extensions/extension_util/int_extensions.dart';
import '../extensions/extension_util/string_extensions.dart';
import '../extensions/loader_widget.dart';
import '../extensions/shared_pref.dart';
import '../screens/no_data_screen.dart';
import '../components/news_components.dart';
import '../components/other_property_component.dart';
import '../components/property_components.dart';
import '../components/search_categerory_components.dart';
import '../components/slider_components.dart';
import '../components/suggestion_components.dart';
import '../components/title_components.dart';
import '../extensions/animatedList/animated_wrap.dart';
import '../extensions/app_text_field.dart';
import '../extensions/decorations.dart';
import '../extensions/extension_util/widget_extensions.dart';
import '../extensions/horizontal_list.dart';
import '../extensions/text_styles.dart';
import '../main.dart';
import '../models/dashBoard_response.dart';
import '../network/RestApis.dart';
import '../utils/app_common.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';
import '../utils/images.dart';
import 'advertisement_see_all_screen.dart';
import 'chatting_screen.dart';
import 'filter_screen.dart';
import 'nearBy_all_screen.dart';
import 'news_all_screen.dart';
import 'news_details_screen.dart';
import 'notification_screen.dart';
import 'owner_furnished_see_all.dart';
import 'property_detail_screen.dart';
import 'search_result_screen.dart';
import 'search_screen.dart';
import 'see_all_screen.dart';
import 'package:crisp_chat/crisp_chat.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  late Timer _timer;
  late GlobalKey<WaveAnimationState> _waveAnimationKey;

  TextEditingController mSearchCont = TextEditingController();

  int? currentIndex = 0;
  int selectedBhkIndex = 0;
  int? bhkSend;
  int? selectCategory;
  int numberOfParts = 10;

  List<String> myList = [];
  List<String> bhkList = List.generate(100, (index) => (index + 1).toString());

  // List<String> bhkList = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"];
  DashboardResponse? data;

  String? selectedCity;
  String? selectCityName;

  double? budgetMinPrice;
  double? budgetMaxPrice;

  bool cityReceived = false;
  bool selectBhk = false;
  late CrispConfig configData;
  bool _showExtraButtons = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    init();
    setState(() {});
  }

  void init() async {
    print(
        "one Signal player id Received" + getStringAsync(PLAYER_ID).toString());
    selectedBhkIndex = 0;
    getUSerDetail(context, userStore.userId);
    _waveAnimationKey = GlobalKey<WaveAnimationState>();
    _timer = Timer.periodic(Duration(seconds: 20), (timer) {
      _waveAnimationKey.currentState?.refresh();
    });
    // if (userStore.latitude.isNotEmpty && userStore.longitude.isNotEmpty && userStore.cityName.isNotEmpty) {
    await getData();
    // await updateUserLatLong();
    // }
    if (await checkPermission()) {
      await checkLocationPermissionOnLaunch(context);
    }
    setState(() {});
  }

  void initLocationStream() async {
    positionStream?.cancel();

    positionStream =
        Geolocator.getPositionStream().listen((Position event) async {
      List<Placemark> placeMarks = await placemarkFromCoordinates(
        event.latitude,
        event.longitude,
      );
      if (placeMarks.isNotEmpty && cityReceived == false) {
        userStore.setUserLatitude(event.latitude.toString());
        userStore.setUserLongitude(event.longitude.toString());
        userStore.setUserCity(placeMarks.first.locality!);

        if (userStore.latitude.isNotEmpty &&
            userStore.longitude.isNotEmpty &&
            userStore.cityName.isNotEmpty &&
            cityReceived == false) await getData();
        cityReceived = true;

        setState(() {});
      }
    }, onError: (error) {
      setState(() {});
    });
  }

  List<String> generateList() {
    int start = int.tryParse(userStore.minPrice.replaceAll(',', '')) ?? 0;
    int end = int.tryParse(userStore.maxPrice.replaceAll(',', '')) ?? 0;
    int difference = ((end - start) / (numberOfParts - 1)).round();

    List<String> list = [];
    for (int i = 0; i < numberOfParts; i++) {
      list.add((start + (difference * i)).toString());
    }

    myList = list;
    setState(() {});

    return list;
  }

  // updateUserLatLong() async {
  //   Map req = {
  //     "latitude": userStore.latitude,
  //     "longitude": userStore.longitude,
  //
  //   };
  //   await updatePlayerIdApi(req).then((value) {
  //     //
  //   }).catchError((error) {
  //     //
  //   });
  // }

  Future<void> getData() async {
    appStore.setLoading(true);
    await getDashBoardData({
      "latitude": userStore.latitude,
      "longitude": userStore.longitude,
      "city": userStore.cityName,
      "player_id": getStringAsync(PLAYER_ID)
    }).then((value) {
      d.log(value.toString());
      data = value;
      userStore.setMinPrice(data!.filterConfiguration!.minPrice.toString());
      userStore.setMaxPrice(data!.filterConfiguration!.maxPrice.toString());
      generateList();
      setState(() {});

      if (value.crispChatWebsiteId != null &&
          value.crispChatWebsiteId!.isNotEmpty) {
        User user = User(
            email: userStore.email,
            nickName: "${userStore.displayName}",
            avatar: userStore.profileImage ?? "");
        configData = CrispConfig(
          user: user,
          tokenId: userStore.userId.toString(),
          enableNotifications: true,
          websiteID: value.crispChatWebsiteId!,
        );
      }
    }).catchError((e) {
      setState(() {});
      print("=======>${e.toString()}");
    }).whenComplete(
      () => appStore.setLoading(false),
    );
  }

  configureCrispChat() async {
    FlutterCrispChat.setSessionString(
      key: userStore.userId.toString(),
      value: userStore.userId.toString(),
    );

    /// Checking session ID After 5 sec
    await Future.delayed(const Duration(seconds: 1), () async {
      String? sessionId = await FlutterCrispChat.getSessionIdentifier();
      if (sessionId != null) {
        if (kDebugMode) {
          print("Session ID::: $sessionId");
        }
      } else {
        if (kDebugMode) {}
      }
    });
  }

  Future<void> checkLocationPermissionOnLaunch(BuildContext context) async {
    initLocationStream();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        onResumed();
        break;
      default:
    }
  }

  void onResumed() async {
    await checkLocationPermissionOnLaunch(context);
    // updatePlayerId();
    setState(() {});
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    positionStream?.cancel();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor:
            appStore.isDarkModeOn ? scaffoldColorDark : selectIconColor,
        elevation: 0,
        leadingWidth: 60,
        leading: Image.asset(bed,
                height: 60,
                width: 60,
                color: appStore.isDarkModeOn ? Colors.white : primaryColor,
                fit: BoxFit.fill)
            .paddingOnly(left: 16, top: 8, bottom: 8),
        actions: [
          citySelectionWidget(),
          6.width,
          Container(
            margin: EdgeInsets.only(left: 8),
            padding: EdgeInsets.all(6),
            decoration: boxDecorationWithRoundedCorners(
                boxShape: BoxShape.circle,
                border: Border.all(
                    color: appStore.isDarkModeOn
                        ? cardDarkColor
                        : lightBackgroundColor)),
            child: Image.asset(ic_bot,
                width: 24,
                height: 24,
                color: appStore.isDarkModeOn ? Colors.white : primaryColor),
          ).onTap(() {
            ChattingScreen().launch(context);
          }),
          6.width,
          Container(
            margin: EdgeInsets.only(left: 8, right: 16),
            padding: EdgeInsets.all(6),
            decoration: boxDecorationWithRoundedCorners(
                boxShape: BoxShape.circle,
                border: Border.all(
                    color: appStore.isDarkModeOn
                        ? cardDarkColor
                        : lightBackgroundColor)),
            child: Image.asset(ic_notification,
                width: 24,
                height: 24,
                color: appStore.isDarkModeOn ? Colors.white : primaryColor),
          ).onTap(() {
            NotificationScreen().launch(context);
          }),
        ],
      ),
      body: Stack(
        children: [
          data != null
              ? SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      searchWidget(),
                      categoryList(),
                      if (data!.slider!.isNotEmpty)
                        SlidesComponents(data: data!.slider),
                      if (userStore.mRecentSearchList.isNotEmpty)
                        userSearchList(),
                      if (data!.property!.isNotEmpty) propertiesList(),
                      if (data!.advertisementProperty!.isNotEmpty)
                        advertiseListWidget(),
                      selectBHK(),
                      if (data!.nearByProperty!.isNotEmpty)
                        nearByPropertyList(),
                      if (myList.isNotEmpty) myListWidget(),
                      ownerPropertyWidget()
                          .visible(data!.ownerProperty!.isNotEmpty),
                      if (data!.fullyFurnishedProperty!.isNotEmpty)
                        fullyFurnisedWidget(),
                      if (data!.article!.isNotEmpty) articleWidget(),
                      20.height,
                    ],
                  ).paddingOnly(bottom: 30),
                )
              : NoDataScreen(mTitle: language.resultNotFound)
                  .visible(data != null && !appStore.isLoading),
          if (userStore.latitude.isEmpty &&
              userStore.longitude.isEmpty &&
              userStore.cityName.isEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                WaveAnimation(
                  key: _waveAnimationKey,
                  size: 80.0,
                  color: primaryColor.withOpacity(
                      0.3), // You can specify your desired color here
                  centerChild: Image.asset(ic_logo,
                      color: primaryExtraLight, height: 22, width: 24),
                ),
                Text(language.fetchingYourCurrentLocation,
                    style: secondaryTextStyle(color: primaryColor))
              ],
            )
                .visible(userStore.latitude.isEmpty &&
                    userStore.longitude.isEmpty &&
                    userStore.cityName.isEmpty)
                .center(),
          Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.transparent,
                  child: Loader().center())
              .visible(appStore.isLoading &&
                  (userStore.latitude.isNotEmpty &&
                      userStore.longitude.isNotEmpty &&
                      userStore.cityName.isNotEmpty))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          configureCrispChat();
          String? sessionId = await FlutterCrispChat.getSessionIdentifier();
          await FlutterCrispChat.openCrispChat(config: configData);
        },
        backgroundColor: primaryColor,
        child: Icon(
          Icons.messenger,
          weight: 30,
          color: Colors.white,
        ),
      ),
    );
  }

//region City Selection widget
  Widget citySelectionWidget() {
    d.log(data.toString());
    return data != null
        ? SizedBox(
            width: 160,
            height: 40,
            child: DropdownButtonFormField<String>(
              focusColor: Colors.transparent,
              alignment: Alignment.centerLeft,
              isExpanded: true,
              padding: EdgeInsets.zero,
              elevation: 0,
              icon:
                  Icon(Icons.keyboard_arrow_down_rounded, color: primaryColor),
              borderRadius: radius(),
              decoration: InputDecoration(
                  focusColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  prefixIconConstraints: BoxConstraints(minWidth: 1),
                  prefixIcon: Image.asset(ic_map_point,
                          color: primaryColor, width: 18, height: 18)
                      .paddingOnly(left: 14, top: 10, bottom: 10, right: 10),
                  alignLabelWithHint: true,
                  enabledBorder: OutlineInputBorder(
                      borderRadius: radius(24),
                      borderSide: BorderSide(
                          color: appStore.isDarkModeOn
                              ? cardDarkColor
                              : primaryExtraLight,
                          width: 1)),
                  border: OutlineInputBorder(
                      borderRadius: radius(24),
                      borderSide: BorderSide(
                          color: appStore.isDarkModeOn
                              ? cardDarkColor
                              : primaryColor,
                          width: 1)),
                  filled: true,
                  focusedBorder: OutlineInputBorder(
                      borderRadius: radius(24),
                      borderSide:
                          BorderSide(color: Colors.transparent, width: 0)),
                  fillColor:
                      appStore.isDarkModeOn ? cardDarkColor : primaryExtraLight,
                  contentPadding:
                      EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
                  enabled: true),
              isDense: true,
              hint: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  data!.propertyCity!.isNotEmpty
                      ? userStore.cityName.isEmpty
                          ? Text(data!.propertyCity![0].name.toString(),
                              style: primaryTextStyle(color: primaryColor),
                              maxLines: 1)
                          : Text(userStore.cityName,
                                  style: primaryTextStyle(color: primaryColor),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis)
                              .expand()
                      : Text(language.selectCity,
                          style: primaryTextStyle(color: primaryColor),
                          maxLines: 1),
                ],
              ),
              dropdownColor: context.cardColor,
              items: data!.propertyCity!.map((PropertyCity e) {
                return DropdownMenuItem<String>(
                  value: data!.propertyCity!.contains(userStore.cityName)
                      ? userStore.cityName
                      : e.name.validate(),
                  child: Text(e.name.validate(),
                      style: primaryTextStyle(color: primaryColor),
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                      textAlign: TextAlign.end),
                );
              }).toList(),
              onChanged: (String? value) async {
                selectedCity = value;
                selectCityName = value;
                userStore.setUserCity(selectCityName!);
                appStore.isLoading = true;
                setState(() {});
                await getData();

                userStore.setMinPrice(
                    data!.filterConfiguration!.minPrice.toString());
                userStore.setMaxPrice(
                    data!.filterConfiguration!.maxPrice.toString());
                generateList();

                setState(() {});
              },
            ),
          ).paddingSymmetric(vertical: 8)
        : SizedBox();
  }

//endregion

  //region search widget
  Widget searchWidget() {
    return Container(
      margin: EdgeInsets.fromLTRB(16, 6, 16, 0),
      padding: EdgeInsets.symmetric(horizontal: 16),
      decoration: boxDecorationWithRoundedCorners(
          borderRadius: radius(10),
          backgroundColor:
              appStore.isDarkModeOn ? cardDarkColor : primaryExtraLight),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(ic_magnifier, height: 30, width: 20),
          10.width,
          AppTextField(
                  readOnly: true,
                  controller: mSearchCont,
                  textStyle: primaryTextStyle(),
                  textFieldType: TextFieldType.NAME,
                  onTap: () async {
                    bool? res =
                        await SearchScreen(isBack: true).launch(context);
                    if (res == true) {
                      init();
                      setState(() {});
                    }
                    setState(() {});
                  },
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(0),
                      border: InputBorder.none,
                      hintText: language.search,
                      hintStyle: primaryTextStyle(color: grey),
                      fillColor: appStore.isDarkModeOn
                          ? cardDarkColor
                          : primaryExtraLight))
              .expand(),
          Image.asset(
            ic_filter,
            height: 20,
            width: 20,
            color: appStore.isDarkModeOn ? Colors.white : primaryColor,
          ).onTap(() {
            FilterScreen(isSelect: true).launch(context);
          })
        ],
      ),
    );
  }

  //endregion

//region Advertise List
  Widget advertiseListWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleComponents(
          title: language.advertisementProperties,
          trailingTitle: language.seeAll,
          onTap: (() async {
            bool? res = await AdvertisementSeeAllScreen(onCall: () {
              init();
              setState(() {});
            }).launch(context);
            if (res == true) {
              init();
              setState(() {});
            }
          }),
        ),
        HorizontalList(
            spacing: 12,
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            itemCount: data!.advertisementProperty!.length,
            itemBuilder: (context, i) {
              return AdvertisementPropertyComponent(
                      property: data!.advertisementProperty![i])
                  .onTap(() async {
                bool? res = await PropertyDetailScreen(
                    propertyId: data!.advertisementProperty![i].id,
                    onCall: () {
                      init();
                    },
                    onTap: (bool? result) {
                      getData();

                      setState(() {});
                    }).launch(context);
                if (res == true) {
                  init();
                  setState(() {});
                }
                setState(() {});
              });
            }),
      ],
    );
  }

//endregion

// region Properties
  Widget propertiesList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleComponents(
          title: language.properties,
          trailingTitle: language.seeAll,
          onTap: (() async {
            bool? res = await SeeAllScreen(onCall: () {
              init();
              setState(() {});
            }).launch(context);
            if (res == true) {
              init();
              setState(() {});
            }
          }),
        ),
        HorizontalList(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            itemCount: data!.property!.length,
            spacing: 12,
            itemBuilder: (context, i) {
              return PropertyComponents(property: data!.property![i])
                  .onTap(() async {
                bool? res = await PropertyDetailScreen(
                    propertyId: data!.property![i].id,
                    onTap: (bool? result) {
                      getData();
                      setState(() {});
                    }).launch(context);
                if (res!) {
                  setState(() {});
                }

                setState(() {});
              });
            }),
      ],
    );
  }

//endregion

//region category
  Widget categoryList() {
    return Column(
      children: [
        16.height,
        HorizontalList(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          itemCount: data!.category!.length,
          itemBuilder: (BuildContext context, int i) {
            return Container(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: boxDecorationWithRoundedCorners(
                  borderRadius: BorderRadius.circular(8.0),
                  backgroundColor: appStore.isDarkModeOn
                      ? cardDarkColor
                      : primaryExtraLight),
              child: Text(data!.category![i].name.validate(),
                      style: primaryTextStyle(color: grey))
                  .center(),
            ).onTap(() async {
              selectCategory = data!.category![i].id!;
              budgetMinPrice = 0.0;
              budgetMaxPrice = 0.0;
              bhkSend = int.tryParse('');
              setState(() {});
              SearchResultScreen(
                      title1: false,
                      title: false,
                      bhkSend: bhkSend,
                      bhk: selectCategory,
                      budgetMaxPrice: budgetMaxPrice,
                      budgetMinPrice: budgetMinPrice,
                      selectCategory: selectCategory)
                  .launch(context);
            });
          },
        ).visible(data!.category!.isNotEmpty),
      ],
    );
  }

//endregion

//region userSearch
  Widget userSearchList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(language.lastSearch,
                style: boldTextStyle(
                    color: appStore.isDarkModeOn
                        ? lightBackgroundColor
                        : Colors.black,
                    size: 18))
            .paddingSymmetric(horizontal: 16)
            .visible(userStore.mRecentSearchList.isNotEmpty),
        8.height.visible(userStore.mRecentSearchList.isNotEmpty),
        if (userStore.mRecentSearchList.isNotEmpty)
          HorizontalList(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              itemCount: userStore.mRecentSearchList.length,
              itemBuilder: (BuildContext context, int index) {
                final item = userStore.mRecentSearchList[index];
                return SearchCategoryComponents(title: item).onTap(() {
                  SearchScreen(
                    propertySince: item,
                  ).launch(context);
                });
              }),
      ],
    );
  }

//endregion

//region select BHK
  Widget selectBHK() {
    return Column(
      children: [
        TitleComponents(
            title: language.selectBHK,
            subTitle: language.explorePropertiesBasedOnBHKType,
            trailingTitle: ""),
        HorizontalList(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          itemCount: bhkList.length,
          spacing: 8,
          itemBuilder: (BuildContext context, int i) {
            return Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
              decoration: boxDecorationWithRoundedCorners(
                  borderRadius: radius(8.0),
                  backgroundColor: appStore.isDarkModeOn
                      ? cardDarkColor
                      : primaryExtraLight),
              child: Text(bhkList[i].toString() + " " + language.bhk,
                  style: primaryTextStyle(color: grey)),
            ).onTap(() async {
              setState(() {
                if (selectedBhkIndex == i) {
                  selectedBhkIndex = -1;
                } else {
                  selectedBhkIndex = i;
                  bhkSend = selectedBhkIndex + 1;
                }
              });
              budgetMinPrice = 0.0;
              budgetMaxPrice = 0.0;
              selectCategory = int.tryParse('');
              SearchResultScreen(
                bhk: bhkSend,
                title: true,
                title1: false,
                bhkSend: bhkSend,
                budgetMaxPrice: budgetMaxPrice,
                budgetMinPrice: budgetMinPrice,
                selectCategory: selectCategory,
              ).launch(context);
            });
          },
        ),
      ],
    );
  }

  //endregion

//region Near by Property
  Widget nearByPropertyList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleComponents(
          title: language.nearByProperty,
          subTitle: language.handpickedPropertiesForYou,
          trailingTitle: language.seeAll,
          onTap: () async {
            bool? res = await NearBySeeAllScreen().launch(context);
            if (res == true) {
              init();
              setState(() {});
            }
          },
        ).visible(data!.nearByProperty!.isNotEmpty),
        8.height,
        CarouselSlider(
          items: List.generate(
            data!.nearByProperty!.length,
            (index) => SuggestionComponents(
              propertyId: data!.nearByProperty![index].id,
              imageFull: true,
              price: data!.nearByProperty![index].price,
              address: data!.nearByProperty![index].address.validate(),
              name: data!.nearByProperty![index].name.validate(),
              img: data!.nearByProperty![index].propertyImage.validate(),
              propertyTFor: data!.nearByProperty![index].propertyFor.validate(),
              isFav: data!.nearByProperty![index].isFavourite,
              onFavChanged: (newValue) {
                setState(() {
                  data!.nearByProperty![index].isFavourite = newValue;
                });
              },
            ).onTap(() async {
              await PropertyDetailScreen(
                  propertyId: data!.nearByProperty![index].id,
                  onTap: (bool? result) {
                    init();
                    setState(() {});
                  }).launch(context);
            }),
          ),
          options: CarouselOptions(
            height: MediaQuery.of(context).size.height * 0.3,
            viewportFraction: 0.65,
            initialPage: 0,
            enableInfiniteScroll: true,
            reverse: false,
            autoPlay: false,
            autoPlayInterval: Duration(seconds: 3),
            autoPlayAnimationDuration: Duration(milliseconds: 800),
            autoPlayCurve: Curves.fastOutSlowIn,
            enlargeCenterPage: true,
            enlargeFactor: 0.3,
            onPageChanged: (index, _) {
              setState(() {
                currentIndex = index;
              });
            },
            scrollDirection: Axis.horizontal,
          ),
        ).visible(data!.nearByProperty!.isNotEmpty),
      ],
    );
  }

//endregion

//region My list
  Widget myListWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleComponents(
            title: language.selectBudget,
            subTitle: language.explorePropertiesBasedOnBudget,
            trailingTitle: ""),
        HorizontalList(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          itemCount: myList.length,
          spacing: 8,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: boxDecorationWithRoundedCorners(
                backgroundColor:
                    appStore.isDarkModeOn ? cardDarkColor : primaryExtraLight,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Text(
                  language.upTo +
                      " " +
                      formatNumberString(myList[index].toInt()),
                  style: secondaryTextStyle(size: 16)),
            ).onTap(() async {
              if (index == 0) {
                budgetMinPrice = 0.0;
                budgetMaxPrice = myList[index].toDouble();
              } else {
                budgetMinPrice = myList[index - 1].toDouble();
                budgetMaxPrice = myList[index].toDouble();
              }

              selectBhk = true;
              bhkSend = int.tryParse('');
              setState(() {});
              SearchResultScreen(
                title1: true,
                bhkSend: bhkSend,
                budgetMaxPrice: budgetMaxPrice,
                budgetMinPrice: budgetMinPrice,
                selectCategory: selectCategory,
              ).launch(context);
            });
          },
        ),
      ],
    );
  }

//endregion

//region owner Property
  Widget ownerPropertyWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleComponents(
          title: language.ownerProperties,
          trailingTitle: language.seeAll,
          onTap: () async {
            bool? res =
                await OwnerFurnishedSeeAllScreen(seller: true).launch(context);
            if (res == true) {
              init();
              setState(() {});
            }
          },
        ).visible(data!.ownerProperty!.isNotEmpty),
        AnimatedWrap(
          columnCount: 2,
          runSpacing: 16,
          spacing: 16,
          children: List.generate(min(6, data!.ownerProperty!.length), (i) {
            return OtherPropertyComponents(
                    ownerProperty: data!.ownerProperty![i]
                    // name: data!.ownerProperty![i].name,
                    // img: data!.ownerProperty![i].propertyImage,
                    // property: data!.ownerProperty![i].category,
                    // isPremium: data!.ownerProperty![i].premiumProperty,
                    )
                .onTap(() async {
              PropertyDetailScreen(
                  propertyId: data!.ownerProperty![i].id,
                  onCall: () {
                    init();
                  }).launch(context);
              setState(() {});
            });
          }),
        )
            .paddingSymmetric(horizontal: 16)
            .visible(data!.ownerProperty!.isNotEmpty),
      ],
    );
  }

//endregion

//region Fully Furnished property
  Widget fullyFurnisedWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleComponents(
          title: language.fullyFurnishedProperties,
          trailingTitle: language.seeAll,
          onTap: () async {
            bool? res =
                await OwnerFurnishedSeeAllScreen(seller: false).launch(context);
            if (res == true) {
              init();
              setState(() {});
            }
          },
        ),
        HorizontalList(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            itemCount: data!.fullyFurnishedProperty!.length,
            itemBuilder: (context, i) {
              return PropertyComponents(
                      property: data!.fullyFurnishedProperty![i])
                  .onTap(() async {
                PropertyDetailScreen(
                    propertyId: data!.fullyFurnishedProperty![i].id,
                    onTap: (bool? result) {
                      init();
                      setState(() {});
                    }).launch(context);
              });
            }),
      ],
    );
  }

//endregion

//region property Article
  Widget articleWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleComponents(
            title: language.newsArticles,
            subTitle: language.readWhatsHappeningInRealEstate,
            trailingTitle: language.seeAll,
            onTap: () {
              NewsAllScreen().launch(context);
            }),
        HorizontalList(
            spacing: 12,
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            itemCount: data!.article!.length,
            itemBuilder: (context, articleIndex) {
              return NewsComponents(
                article: data!.article![articleIndex],
              ).onTap(() {
                NewsDetailsScreen(articles: data!.article![articleIndex])
                    .launch(context);
              });
            }),
      ],
    );
  }
//endregion
}
