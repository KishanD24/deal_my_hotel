import 'package:flutter/material.dart';
import '../components/app_bar_components.dart';
import '../extensions/decorations.dart';
import '../extensions/extension_util/context_extensions.dart';
import '../extensions/extension_util/int_extensions.dart';
import '../extensions/extension_util/string_extensions.dart';
import '../extensions/extension_util/widget_extensions.dart';
import '../extensions/text_styles.dart';
import '../main.dart';
import '../utils/app_common.dart';
import '../utils/colors.dart';
import '../extensions/widgets.dart';
import '../models/contact_info_detail_response.dart';
import '../network/RestApis.dart';
import '../utils/app_config.dart';

class PropertyContactHistoryScreen extends StatefulWidget {
  final int? customerId;

  const PropertyContactHistoryScreen({super.key, required this.customerId});

  @override
  State<PropertyContactHistoryScreen> createState() => _PropertyContactHistoryScreenState();
}

class _PropertyContactHistoryScreenState extends State<PropertyContactHistoryScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    if (showContactDetail) loadInterstitialAds();
  }

  @override
  void dispose() {
    if (showContactDetail) showInterstitialAds();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBarWidget(language.contactInfoDetails, context1: context, titleSpace: 0),
        body: FutureBuilder(
          future: getWhoInquiredMyPropertyUserDetailsListApi(widget.customerId),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              ContactInfoDetailsResponse _categoryListModel = snapshot.data!;
              return SingleChildScrollView(
                child: ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    shrinkWrap: true,
                    itemCount: _categoryListModel.data!.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: EdgeInsets.only(bottom: 16),
                        width: context.width(),
                        padding: EdgeInsets.all(10),
                        decoration: boxDecorationRoundedWithShadow(8, backgroundColor: primaryExtraLight),
                        child: Row(children: [
                          cachedImage(_categoryListModel.data![index].propertyImage, height: 60, width: 60, fit: BoxFit.fill).cornerRadiusWithClipRRect(4),
                          10.width,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(_categoryListModel.data![index].propertyName.validate(), style: primaryTextStyle(size: 20)),
                              10.height,
                              if (_categoryListModel.data![index].createdAt!.isNotEmpty)
                                Text(language.seenOn + parseDocumentDate(DateTime.parse(_categoryListModel.data![index].createdAt.validate())), style: secondaryTextStyle())
                            ],
                          )
                        ]),
                      );
                    }),
              );
            }
            return snapWidgetHelper(snapshot);
          },
        ));
  }
}
