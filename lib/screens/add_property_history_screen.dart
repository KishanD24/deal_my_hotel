import 'package:flutter/material.dart';
import '../components/app_bar_components.dart';
import '../extensions/colors.dart';
import '../extensions/decorations.dart';
import '../extensions/extension_util/int_extensions.dart';
import '../extensions/extension_util/string_extensions.dart';
import '../extensions/extension_util/widget_extensions.dart';
import '../extensions/text_styles.dart';
import '../screens/no_data_screen.dart';
import '../screens/property_detail_screen.dart';
import '../utils/app_common.dart';
import '../utils/colors.dart';
import '../extensions/loader_widget.dart';
import '../main.dart';
import '../models/my_advertisement_property_response.dart';
import '../network/RestApis.dart';

class AddPropertyHistoryScreen extends StatefulWidget {
  final bool history;

  const AddPropertyHistoryScreen({super.key, this.history = false});

  @override
  State<AddPropertyHistoryScreen> createState() => _AddPropertyHistoryScreenState();
}

class _AddPropertyHistoryScreenState extends State<AddPropertyHistoryScreen> {
  int page = 1;
  int? numPage;
  String title = "";

  List<MyAdvertisementPropertyModel> mMyAdvertisementPropertyModel = [];

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

  void init() async {
    if (widget.history == true) {
      title = language.addPropertyHistory;
      getMyOwnPropertyHistory();
      print("addPropertyHistory" + widget.history.toString());
    } else {
      title = language.advertisementHistory;
      getMyAdvertisementProperty();
      print("advertisementHistory");
    }
  }

  Future<void> getMyOwnPropertyHistory() async {
    appStore.setLoading(true);

    getMyOwnPropertyApi(page).then((value) {
      appStore.setLoading(false);
      numPage = value.pagination!.totalPages;
      if (page == 1) {
        mMyAdvertisementPropertyModel.clear();
      }
      Iterable it = value.data!;
      it.map((e) => mMyAdvertisementPropertyModel.add(e)).toList();

      setState(() {});
    }).catchError((e) {
      appStore.setLoading(false);
      setState(() {});
    });
  }

  Future<void> getMyAdvertisementProperty() async {
    appStore.setLoading(true);

    getMyAdvertisementApi(page).then((value) {
      appStore.setLoading(false);
      numPage = value.pagination!.totalPages;
      if (page == 1) {
        mMyAdvertisementPropertyModel.clear();
      }
      Iterable it = value.data!;
      it.map((e) => mMyAdvertisementPropertyModel.add(e)).toList();

      setState(() {});
    }).catchError((e) {
      appStore.setLoading(false);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(title, context1: context, titleSpace: 0),
      body: Stack(children: [
        mMyAdvertisementPropertyModel.isNotEmpty
            ? ListView.builder(
                shrinkWrap: true,
                controller: scrollController,
                itemCount: mMyAdvertisementPropertyModel.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.only(bottom: 16),
                    padding: EdgeInsets.all(10),
                    decoration: boxDecorationWithRoundedCorners(borderRadius: radius(), backgroundColor: appStore.isDarkModeOn ? cardDarkColor : primaryExtraLight),
                    child: Row(
                      children: [
                        cachedImage(mMyAdvertisementPropertyModel[index].propertyImage, height: 60, width: 60, fit: BoxFit.fill).cornerRadiusWithClipRRect(8),
                        10.width,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(mMyAdvertisementPropertyModel[index].name.validate().capitalizeFirstLetter(), style: primaryTextStyle()),
                            10.height,
                            if (mMyAdvertisementPropertyModel[index].advertisementPropertyDate!.isNotEmpty)
                              Text(language.seenOn + " " + parseDocumentDate(DateTime.parse(mMyAdvertisementPropertyModel[index].advertisementPropertyDate.validate())), style: secondaryTextStyle())
                          ],
                        ).expand()
                      ],
                    ),
                  ).onTap(() {
                    PropertyDetailScreen(
                      propertyId: mMyAdvertisementPropertyModel[index].id,
                    ).launch(context);
                  });
                })
            : NoDataScreen().visible(!appStore.isLoading),
        Loader().center().visible(appStore.isLoading),
      ]).paddingSymmetric(horizontal: 16).paddingOnly(bottom: 16),
    );
  }
}
