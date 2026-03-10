import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../extensions/extension_util/widget_extensions.dart';
import '../models/dashBoard_response.dart';
import '../components/adMob_component.dart';
import '../components/advertisement_property_component.dart';
import '../components/app_bar_components.dart';
import '../extensions/loader_widget.dart';
import '../extensions/system_utils.dart';
import '../main.dart';
import '../network/RestApis.dart';
import '../utils/app_config.dart';
import 'no_data_screen.dart';
import 'property_detail_screen.dart';
import 'subscribe_screen.dart';

class CategorySelectedScreen extends StatefulWidget {
  final String? categoryName;
  final int? categoryId;

  const CategorySelectedScreen({this.categoryName, this.categoryId});

  @override
  State<CategorySelectedScreen> createState() => _CategorySelectedScreenState();
}

class _CategorySelectedScreenState extends State<CategorySelectedScreen> {
  List<Property> mPropertyDataSelected = [];

  int page = 1;
  int? numPage;
  int? currentIndex = 0;
  bool isLastPage = false;

  ScrollController scrollController = ScrollController();

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

  Future<void> init() async {
    await getPropertyApiCall();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  getPropertyApiCall() async {
    appStore.setLoading(true);
    Map req = {
      "city": userStore.cityName,
      "category_id": widget.categoryId,
    };

    await filterApi(req, page: 1).then((value) {
      numPage = value.pagination!.totalPages;
      isLastPage = false;
      if (page == 1) {
        mPropertyDataSelected.clear();
      }
      Iterable it = value.property!;
      it.map((e) => mPropertyDataSelected.add(e)).toList();
      appStore.setLoading(false);
      setState(() {});
    }).catchError((error) {
      appStore.setLoading(false);
      log(error);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      return Scaffold(
          appBar: appBarWidget(widget.categoryName.toString(), context1: context, titleSpace: 0),
          bottomNavigationBar: showBannerAdOnCategorySelected && userStore.isSubscribe == 0 ? showBannerAds(context) : SizedBox(),
          body: Stack(
            children: [
              mPropertyDataSelected.isNotEmpty
                  ? ListView.builder(
                      controller: scrollController,
                      physics: BouncingScrollPhysics(),
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      shrinkWrap: true,
                      itemCount: mPropertyDataSelected.length,
                      itemBuilder: (context, i) {
                        return widget.categoryId == mPropertyDataSelected[i].categoryId
                            ? AdvertisementPropertyComponent(
                                property: mPropertyDataSelected[i],
                                onCall: () {
                                  getPropertyApiCall();
                                },
                                isFullWidth: true,
                              ).paddingOnly(bottom: 16).visible(widget.categoryId == mPropertyDataSelected[i].categoryId).onTap(() async {
                                if (mPropertyDataSelected[i].premiumProperty == 1) {
                                  if (userStore.subscription == "1") {
                                    if (userStore.isSubscribe != 0) {
                                      bool? res = await PropertyDetailScreen(propertyId: mPropertyDataSelected[i].id).launch(context);
                                      if (res == true) {
                                        init();
                                      }
                                    } else {
                                      SubscribeScreen().launch(context);
                                    }
                                  } else {
                                    bool? res = await PropertyDetailScreen(propertyId: mPropertyDataSelected[i].id).launch(context);
                                    if (res == true) {
                                      init();
                                    }
                                  }
                                } else {
                                  bool? res = await PropertyDetailScreen(propertyId: mPropertyDataSelected[i].id).launch(context);
                                  if (res == true) {
                                    init();
                                  }
                                }
                              })
                            : SizedBox.shrink();
                      })
                  : NoDataScreen(mTitle: language.resultNotFound).visible(!appStore.isLoading),
              Loader().center().visible(appStore.isLoading)
            ],
          ));
    });
  }
}
