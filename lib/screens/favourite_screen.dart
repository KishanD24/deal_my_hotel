import 'package:flutter/material.dart';
import '../extensions/extension_util/widget_extensions.dart';
import '../models/dashBoard_response.dart';
import '../components/advertisement_property_component.dart';
import '../components/app_bar_components.dart';
import '../extensions/loader_widget.dart';
import '../main.dart';
import '../network/RestApis.dart';
import 'no_data_screen.dart';
import 'property_detail_screen.dart';
import 'subscribe_screen.dart';

class FavouriteScreen extends StatefulWidget {
  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  ScrollController scrollController = ScrollController();

  List<Property> mFavouriteProperty = [];

  int page = 1;
  int? numPage;

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
    getFavouritePropertyData();
  }

  Future<void> getFavouritePropertyData() async {
    appStore.setLoading(true);
    getFavouriteProperty(page).then((value) {
      appStore.setLoading(false);
      numPage = value.pagination!.totalPages;
      if (page == 1) {
        mFavouriteProperty.clear();
      }
      Iterable it = value.data!;
      it.map((e) => mFavouriteProperty.add(e)).toList();

      print("Favourite Property List Is ==>" + mFavouriteProperty.toString());
      setState(() {});
    }).catchError((e) {
      print("Error is " + e.toString());
      appStore.setLoading(false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBarWidget(language.favourite, context1: context, showBack: false, titleSpace: 16),
        body: Stack(
          children: [
            mFavouriteProperty.isNotEmpty
                ? ListView.builder(
                    controller: scrollController,
                    physics: ScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    shrinkWrap: true,
                    itemCount: mFavouriteProperty.length,
                    itemBuilder: (context, i) {
                      return AdvertisementPropertyComponent(
                        property: mFavouriteProperty[i],
                        isFullWidth: true,
                        onCall: () {
                          setState(() {
                            getFavouritePropertyData();
                          });
                        },
                      ).onTap(() async {
                        if (mFavouriteProperty[i].premiumProperty == 1) {
                          if (userStore.subscription == "1") {
                            if (userStore.isSubscribe != 0) {
                              bool? res = await PropertyDetailScreen(propertyId: mFavouriteProperty[i].id).launch(context);
                              if (res == true) {
                                init();
                              }
                            } else {
                              SubscribeScreen().launch(context);
                            }
                          } else {
                            bool? res = await PropertyDetailScreen(propertyId: mFavouriteProperty[i].id).launch(context);
                            if (res == true) {
                              init();
                            }
                          }
                        } else {
                          bool? res = await PropertyDetailScreen(propertyId: mFavouriteProperty[i].id).launch(context);
                          if (res == true) {
                            init();
                          }
                        }
                        setState(() {});
                      }).paddingBottom(16);
                    })
                : NoDataScreen(mTitle: language.resultNotFound).visible(!appStore.isLoading),
            Loader().center().visible(appStore.isLoading)
          ],
        ));
  }
}
