import 'package:flutter/material.dart';
import '../components/app_bar_components.dart';
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
import '../extensions/colors.dart';
import '../extensions/loader_widget.dart';
import '../main.dart';
import '../models/property_contact_info_response.dart';
import '../network/RestApis.dart';
import '../utils/images.dart';

class ViewPropertyContactHistory extends StatefulWidget {
  const ViewPropertyContactHistory({super.key});

  @override
  State<ViewPropertyContactHistory> createState() => _ViewPropertyContactHistoryState();
}

class _ViewPropertyContactHistoryState extends State<ViewPropertyContactHistory> {
  ScrollController scrollController = ScrollController();

  List<ContactInfoModel> mPropertyInquiryList = [];

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
    getInquiryUserData();
  }

  Future<void> getInquiryUserData() async {
    appStore.setLoading(true);
    getWhoInquiredMyPropertyUserListApi(page).then((value) {
      numPage = value.pagination!.totalPages.validate();
      if (page == 1) {
        mPropertyInquiryList.clear();
      }
      Iterable it = value.data!;
      it.map((e) => mPropertyInquiryList.add(e)).toList();
      appStore.setLoading(false);
      setState(() {});
    }).catchError((e) {
      appStore.setLoading(false);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(language.viewPropertyContactHistory, context1: context, titleSpace: 0),
      body: Stack(children: [
        mPropertyInquiryList.isNotEmpty
            ? ListView.builder(
                controller: scrollController,
                shrinkWrap: true,
                itemCount: mPropertyInquiryList.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.only(bottom: 14),
                    width: context.width(),
                    padding: EdgeInsets.all(12),
                    decoration: boxDecorationWithRoundedCorners(borderRadius: radius(), backgroundColor: appStore.isDarkModeOn ? cardDarkColor : primaryExtraLight),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                cachedImage(mPropertyInquiryList[index].customerProfileImage.validate(), height: 50, width: 50, fit: BoxFit.cover).cornerRadiusWithClipRRect(100),
                                10.width,
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(mPropertyInquiryList[index].customerName.validate().capitalizeFirstLetter(), style: boldTextStyle()),
                                    4.height,
                                    Text(language.seenOn + " " + parseDocumentDate(DateTime.parse(mPropertyInquiryList[index].createdAt.validate())), style: secondaryTextStyle()),
                                  ],
                                ).expand()
                              ],
                            ).expand(),
                            4.width,
                            Row(
                              children: [
                                InkWell(
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                                    decoration: boxDecorationWithRoundedCorners(
                                        backgroundColor: appStore.isDarkModeOn ? cardDarkColor : primaryExtraLight, borderRadius: radius(8), border: Border.all(color: dividerColor)),
                                    child: Image.asset(ic_whatsapp, height: 28, width: 28),
                                  ),
                                  onTap: () {

                                    commonLaunchUrl(
                                      'whatsapp://send?phone=${mPropertyInquiryList[index].contactNumber}',
                                    );
                                    // commonLaunchUrl('whatsapp://send?phone=:${mPropertyInquiryList[index].contactNumber}');
                                  },
                                ),
                                8.width,
                                InkWell(
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                                    decoration: boxDecorationWithRoundedCorners(
                                        backgroundColor: appStore.isDarkModeOn ? cardDarkColor : primaryExtraLight, borderRadius: BorderRadius.circular(8), border: Border.all(color: dividerColor)),
                                    child: Image.asset(ic_call, height: 28, width: 28),
                                  ),
                                  onTap: () {
                                    commonLaunchUrl('tel:${mPropertyInquiryList[index].contactNumber}');
                                  },
                                ),
                              ],
                            )
                          ],
                        ),
                        10.height,
                        RichText(
                          text: TextSpan(
                            children: <TextSpan>[
                              TextSpan(text: language.inquiryFor + " ", style: secondaryTextStyle()),
                              TextSpan(
                                text: mPropertyInquiryList[index].propertyName.validate().capitalizeFirstLetter(),
                                style: boldTextStyle(color: primaryColor),
                              ),
                            ],
                          ),
                        ).onTap(() {
                          PropertyDetailScreen(propertyId: mPropertyInquiryList[index].propertyId).launch(context);
                        }),
                      ],
                    ),
                  );
                })
            : NoDataScreen().visible(!appStore.isLoading),
        Loader().center().visible(appStore.isLoading),
      ]).paddingSymmetric(horizontal: 16),
    );
  }
}
