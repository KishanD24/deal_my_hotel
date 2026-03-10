import 'package:flutter/material.dart';
import '../extensions/colors.dart';
import '../extensions/extension_util/int_extensions.dart';
import '../extensions/extension_util/string_extensions.dart';
import '../extensions/extension_util/widget_extensions.dart';
import '../utils/images.dart';
import '../../components/app_bar_components.dart';
import '../extensions/decorations.dart';
import '../extensions/loader_widget.dart';
import '../extensions/system_utils.dart';
import '../extensions/text_styles.dart';
import '../main.dart';
import '../models/notification_model.dart';
import '../network/RestApis.dart';
import '../utils/app_common.dart';
import '../utils/colors.dart';
import 'no_data_screen.dart';
import 'notification_details_screen.dart';

class NotificationScreen extends StatefulWidget {
  NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  String? realAll = "";

  NotificationResponse? data;

  init() async {
    getMarksRead("");
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> getNotificationDetails(String? id) async {
    appStore.setLoading(true);
    await notificationDetailsApi(id.validate()).then((value) {
      getMarksRead(realAll);
      appStore.setLoading(false);
      setState(() {});
    }).catchError((e) {
      appStore.setLoading(false);
      setState(() {});
    });
  }

  getMarksRead(String? realAll) async {
    Map? req;
    req = {"type": realAll};
    appStore.setLoading(true);
    await notificationListApi(req).then((value) {
      data = value;
      appStore.setLoading(false);
      setState(() {});
    }).catchError((e) {
      appStore.setLoading(false);
      log(e.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBarWidget(language.notification, context1: context, titleSpace: 0, actions: [
          Image.asset(ic_marks_all_read, height: 20, width: 20).paddingSymmetric(horizontal: 16).onTap(() {
            getMarksRead("markas_read");
            setState(() {});
          })
        ]),
        body: Stack(
          children: [
            data != null && data!.notificationData!.isNotEmpty
                ? ListView.builder(
                    physics: BouncingScrollPhysics(),
                    shrinkWrap: true,
                    padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
                    itemCount: data!.notificationData!.length,
                    itemBuilder: (BuildContext context, int index) {
                      NotificationData mNotification = data!.notificationData![index];
                      return Container(
                        padding: EdgeInsets.only(top: 4, bottom: 4),
                        margin: EdgeInsets.only(bottom: 16, top: 0),
                        decoration: boxDecorationWithRoundedCorners(
                            borderRadius: radius(),
                            backgroundColor: appStore.isDarkModeOn
                                ? cardDarkColor
                                : mNotification.readAt.isEmptyOrNull
                                    ? primaryExtraLight
                                    : primaryExtraLight),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                mNotification.data!.image.isEmptyOrNull
                                    ? Container(
                                        width: 50,
                                        height: 50,
                                        decoration: boxDecorationWithRoundedCorners(borderRadius: radius(10), backgroundColor: primaryOpacity),
                                        child: Text(mNotification.data!.subject!.isNotEmpty ? mNotification.data!.subject![0].toUpperCase() : '', style: boldTextStyle(color: primaryColor, size: 24))
                                            .center(),
                                      )
                                    : cachedImage(mNotification.data!.image.toString(), height: 50, width: 50, fit: BoxFit.cover).cornerRadiusWithClipRRect(4),
                                10.width,
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(mNotification.data!.subject.validate().capitalizeFirstLetter(), style: boldTextStyle(color: appStore.isDarkModeOn ? selectIconColor : scaffoldColorDark)),
                                    4.height,
                                    Text(mNotification.data!.message.validate(), style: secondaryTextStyle(size: 12), maxLines: 2, overflow: TextOverflow.ellipsis),
                                  ],
                                ).expand(),
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(mNotification.createdAt.validate(), style: secondaryTextStyle(size: 12)),
                                6.width,
                                mNotification.readAt.isEmptyOrNull ? Icon(Icons.circle, color: Colors.green, size: 6) : SizedBox()
                              ],
                            ),
                          ],
                        ).paddingSymmetric(horizontal: 16, vertical: 8),
                      ).onTap(() {
                        getNotificationDetails(mNotification.id.toString());
                        NotificationDetailsScreen(mNotificationResponse: mNotification.data!).launch(context);
                      });
                    },
                  )
                : NoDataScreen(mTitle: language.resultNotFound).visible(!appStore.isLoading),
            Loader().center().visible(appStore.isLoading)
          ],
        ));
  }
}
