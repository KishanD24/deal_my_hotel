import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../components/app_bar_components.dart';
import '../extensions/extension_util/widget_extensions.dart';
import '../utils/constants.dart';
import '../components/advertisement_property_component.dart';
import '../extensions/loader_widget.dart';
import '../main.dart';
import '../models/dashBoard_response.dart';
import '../network/RestApis.dart';
import 'no_data_screen.dart';
import 'property_detail_screen.dart';

class OwnerFurnishedSeeAllScreen extends StatefulWidget {
  final Function? onCall;
  final bool seller;

  OwnerFurnishedSeeAllScreen({
    this.onCall,
    this.seller = false,
  });

  @override
  State<OwnerFurnishedSeeAllScreen> createState() => _OwnerFurnishedSeeAllScreenState();
}

class _OwnerFurnishedSeeAllScreenState extends State<OwnerFurnishedSeeAllScreen> {
  List<Property> filterProperty = [];
  String title = "";

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
    if (widget.seller == true) {
      title = language.ownerProperties;
    } else {
      title = language.fullyFurnishedProperties;
    }
    await filterData();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  Future<void> filterData() async {
    appStore.setLoading(true);
    Map req;
    if (widget.seller == true) {
      req = {
        "saller_type": SellerType.OWNER.sellerTypeIndex,
        "city": userStore.cityName,
      };
    } else {
      req = {
        "furnished_type": FurnishedType.FULLY.furnishedTypeIndex,
        "city": userStore.cityName,
      };
    }
    await filterApi(req, page: 1).then((value) {
      appStore.setLoading(true);
      filterProperty.clear();
      Iterable it = value.property!;
      it.map((e) => filterProperty.add(e)).toList();
      appStore.setLoading(false);
      print("Filter Response " + filterProperty.toString());
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
          appBar: appBarWidget(title, context1: context, titleSpace: 0),
          body: Stack(
            children: [
              filterProperty.isNotEmpty
                  ? ListView.builder(
                      controller: scrollController,
                      physics: BouncingScrollPhysics(),
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      shrinkWrap: true,
                      itemCount: filterProperty.length,
                      itemBuilder: (context, i) {
                        return AdvertisementPropertyComponent(
                          property: filterProperty[i],
                          isFullWidth: true,
                          onCall: () {
                            filterData();
                          },
                        ).onTap(() async {
                          bool? res = await PropertyDetailScreen(propertyId: filterProperty[i].id).launch(context);
                          if (res == true) {
                            init();
                          }
                          setState(() {});
                        }).paddingBottom(16);
                      })
                  : NoDataScreen(mTitle: language.resultNotFound).visible(!appStore.isLoading),
              Observer(builder: (context) {
                return Loader().center().visible(appStore.isLoading);
              }),
            ],
          ));
    });
  }
}
