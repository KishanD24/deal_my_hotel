import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../components/app_bar_components.dart';
import '../extensions/extension_util/widget_extensions.dart';
import '../components/advertisement_property_component.dart';
import '../extensions/loader_widget.dart';
import '../extensions/system_utils.dart';
import '../main.dart';
import '../models/dashBoard_response.dart';
import '../network/RestApis.dart';
import 'no_data_screen.dart';
import 'property_detail_screen.dart';

class NearBySeeAllScreen extends StatefulWidget {
  final Function? onCall;

  const NearBySeeAllScreen({this.onCall});

  @override
  State<NearBySeeAllScreen> createState() => _NearBySeeAllScreenState();
}

class _NearBySeeAllScreenState extends State<NearBySeeAllScreen> {
  List<Property> mPropertyData = [];

  int page = 1;
  int? numPage;
  int? currentIndex = 0;

  ScrollController scrollController = ScrollController();

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

  Future<void> init() async {
    await getPropertyApiCall();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  getPropertyApiCall() async {
    appStore.setLoading(true);
    {
      Map req = {"latitude": userStore.latitude, "longitude": userStore.longitude, "city": userStore.cityName};
      appStore.setLoading(true);
      getNearByProperty(req,page: page).then((value) {
        appStore.setLoading(false);
        numPage = value.pagination!.totalPages;
        isLastPage = false;
        if (page == 1) {
          mPropertyData.clear();
        }
        Iterable it = value.data!;
        it.map((e) => mPropertyData.add(e)).toList();

        setState(() {});
      }).catchError((error) {
        appStore.setLoading(false);
        log(error);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        return Scaffold(
            appBar: appBarWidget(language.nearByProperty, context1: context, titleSpace: 0),
            body: Stack(children: [
              mPropertyData.isNotEmpty
                  ? ListView.builder(
                      controller: scrollController,
                      physics: BouncingScrollPhysics(),
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      shrinkWrap: true,
                      itemCount: mPropertyData.length,
                      itemBuilder: (context, i) {
                        return AdvertisementPropertyComponent(
                          property: mPropertyData[i],
                          isFullWidth: true,
                          onCall: () {
                            getPropertyApiCall();
                          },
                        ).onTap(() async {
                          bool? res = await PropertyDetailScreen(propertyId: mPropertyData[i].id).launch(context);
                          if (res == true) {
                            init();
                          }
                        }).paddingBottom(16);
                      })
                  : NoDataScreen(mTitle: language.resultNotFound).visible(!appStore.isLoading),
              Loader().center().visible(appStore.isLoading),
            ]));
      },
    );
  }
}
