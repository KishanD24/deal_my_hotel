import 'package:flutter/material.dart';
import '../components/app_bar_components.dart';
import '../extensions/colors.dart';
import '../extensions/decorations.dart';
import '../extensions/extension_util/context_extensions.dart';
import '../extensions/extension_util/int_extensions.dart';
import '../extensions/extension_util/string_extensions.dart';
import '../extensions/extension_util/widget_extensions.dart';
import '../extensions/text_styles.dart';
import '../screens/no_data_screen.dart';
import '../screens/property_detail_screen.dart';
import '../utils/app_common.dart';
import '../utils/colors.dart';
import '../extensions/loader_widget.dart';
import '../extensions/system_utils.dart';
import '../main.dart';
import '../models/property_inquiry_response.dart';
import '../network/RestApis.dart';

class PropertyContactInfoScreen extends StatefulWidget {
  const PropertyContactInfoScreen({super.key});

  @override
  State<PropertyContactInfoScreen> createState() => _PropertyContactInfoScreenState();
}

class _PropertyContactInfoScreenState extends State<PropertyContactInfoScreen> {
  int page = 1;
  int? numPage;
  int? currentIndex = 0;
  bool isLastPage = false;

  List<PropertyInquiryModel> mContactInfoModel = [];

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    getContactInfo();
  }

  Future<void> getContactInfo() async {
    appStore.setLoading(true);

    getPropertyInquiryApi().then((value) {
      appStore.setLoading(false);
      numPage = value.pagination!.totalPages;
      isLastPage = false;
      if (page == 1) {
        mContactInfoModel.clear();
      }
      Iterable it = value.data!;
      it.map((e) => mContactInfoModel.add(e)).toList();
      setState(() {});
    }).catchError((e) {
      isLastPage = true;
      appStore.setLoading(false);
      log(e.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(language.propertyContactInfo, context1: context, titleSpace: 0),
      body: Stack(children: [
        mContactInfoModel.isNotEmpty
            ? ListView.builder(
                shrinkWrap: true,
                itemCount: mContactInfoModel.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.only(bottom: 16),
                    width: context.width(),
                    padding: EdgeInsets.all(10),
                    decoration: boxDecorationRoundedWithShadow(8, backgroundColor: appStore.isDarkModeOn ? cardDarkColor : primaryExtraLight),
                    child: Row(children: [
                      cachedImage(mContactInfoModel[index].propertyImage, height: 60, width: 60, fit: BoxFit.fill).cornerRadiusWithClipRRect(4),
                      10.width,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(mContactInfoModel[index].propertyName.validate(), style: primaryTextStyle()),
                          10.height,
                          if (mContactInfoModel[index].createdAt!.isNotEmpty)
                            Text(language.seenOn + parseDocumentDate(DateTime.parse(mContactInfoModel[index].createdAt.validate())), style: secondaryTextStyle())
                        ],
                      )
                    ]),
                  ).onTap(() {
                    PropertyDetailScreen(propertyId: mContactInfoModel[index].propertyId).launch(context);
                  });
                })
            : NoDataScreen().visible(!appStore.isLoading),
        Loader().center().visible(appStore.isLoading),
      ]).paddingSymmetric(horizontal: 16).paddingOnly(bottom: 16),
    );
  }
}
