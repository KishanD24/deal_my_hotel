import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../components/HtmlWidget.dart';
import '../extensions/extension_util/context_extensions.dart';
import '../extensions/extension_util/int_extensions.dart';
import '../extensions/extension_util/string_extensions.dart';
import '../extensions/extension_util/widget_extensions.dart';
import '../components/app_bar_components.dart';
import '../extensions/decorations.dart';
import '../extensions/text_styles.dart';
import '../main.dart';
import '../models/notification_model.dart';
import '../utils/app_common.dart';
import '../utils/colors.dart';

class NotificationDetailsScreen extends StatefulWidget {
  final NotificationModel mNotificationResponse;

  const NotificationDetailsScreen({super.key, required this.mNotificationResponse});

  @override
  State<NotificationDetailsScreen> createState() => _NotificationDetailsScreenState();
}

class _NotificationDetailsScreenState extends State<NotificationDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: appStore.isDarkModeOn ? Brightness.light : Brightness.light,
        systemNavigationBarIconBrightness: appStore.isDarkModeOn ? Brightness.light : Brightness.light,
      ),
      child: Scaffold(
        appBar: appBarWidget("", context1: context, titleSpace: 0),
        body: SingleChildScrollView(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            widget.mNotificationResponse.image.isEmptyOrNull
                ? Container(
                    height: context.height() * 0.3,
                    width: context.width(),
                    decoration: boxDecorationWithRoundedCorners(borderRadius: radius(10), backgroundColor: primaryOpacity),
                    child: Text(widget.mNotificationResponse.subject!.isNotEmpty ? widget.mNotificationResponse.subject![0].toUpperCase() : '', style: boldTextStyle(color: primaryColor, size: 30))
                        .center(),
                  ).paddingSymmetric(horizontal: 16)
                : cachedImage(widget.mNotificationResponse.image.validate(), height: context.height() * 0.3, width: context.width(), fit: BoxFit.fill)
                    .cornerRadiusWithClipRRect(12)
                    .paddingSymmetric(horizontal: 16),
            20.height,
            Text(widget.mNotificationResponse.subject.validate(), style: boldTextStyle(size: 20)).paddingSymmetric(horizontal: 16),
            HtmlWidget(postContent: widget.mNotificationResponse.message.validate()).paddingSymmetric(horizontal: 10)
          ]),
        ),
      ),
    );
  }
}
