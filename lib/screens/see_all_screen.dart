import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../components/app_bar_components.dart';
import '../extensions/extension_util/widget_extensions.dart';
import '../components/advertisement_property_component.dart';
import '../extensions/loader_widget.dart';
import '../main.dart';
import '../models/dashBoard_response.dart';
import '../network/RestApis.dart';
import 'no_data_screen.dart';
import 'property_detail_screen.dart';

class SeeAllScreen extends StatefulWidget {
  final Function? onCall;

  const SeeAllScreen({this.onCall});

  @override
  State<SeeAllScreen> createState() => _SeeAllScreenState();
}

class _SeeAllScreenState extends State<SeeAllScreen> {
  List<Property> mPropertyData = [];

  ScrollController scrollController = ScrollController();

  int page = 1;
  int? numPage;
  int? currentIndex = 0;

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
    await filterData();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  Future<void> filterData() async {
    appStore.setLoading(true);
    Map req;

    req = {
      "city": userStore.cityName,
    };

    await filterApi(req).then((value) {
      appStore.setLoading(true);
      numPage = value.pagination!.totalPages;
      isLastPage = false;
      if (page == 1) {
        mPropertyData.clear();
      }
      Iterable it = value.property!;
      it.map((e) => mPropertyData.add(e)).toList();
      appStore.setLoading(false);
      print("Filter Response " + mPropertyData.toString());
      setState(() {});
    }).catchError((e) {
      print(req);
      print(e.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      return Scaffold(
          appBar: appBarWidget(language.properties, context1: context, titleSpace: 0),
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
                          filterData();
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
    });
  }
}
