import 'package:flutter/material.dart';
import '../extensions/decorations.dart';
import '../extensions/extension_util/string_extensions.dart';
import '../extensions/extension_util/widget_extensions.dart';
import '../extensions/common.dart';
import '../extensions/extension_util/int_extensions.dart';
import '../extensions/text_styles.dart';
import '../main.dart';
import '../models/article_model.dart';
import '../utils/app_common.dart';
import '../utils/colors.dart';

class NewsComponents extends StatefulWidget {
  final Article? article;

  NewsComponents({this.article});

  @override
  State<NewsComponents> createState() => _PropertyComponentsState();
}

class _PropertyComponentsState extends State<NewsComponents> {
  dynamic startDateString;
  dynamic startDate;

  final currentDate = DateTime.now();

  @override
  void initState() {
    super.initState();

    startDate = DateTime.parse(widget.article!.createdAt.validate());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: boxDecorationWithRoundedCorners(backgroundColor: appStore.isDarkModeOn ? iconColor : primaryExtraLight, borderRadius: BorderRadius.circular(12)),
      width: MediaQuery.of(context).size.width * 0.8,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          cachedImage(widget.article!.articleImage.toString(), height: 150, fit: BoxFit.fill, width: MediaQuery.of(context).size.width * 0.8).cornerRadiusWithClipRRectOnly(topRight: 12, topLeft: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.article!.name.validate().capitalizeFirstLetter(), style: boldTextStyle(size: 16), maxLines: 2, overflow: TextOverflow.ellipsis),
              10.height.visible(!widget.article!.description.isEmptyOrNull),
              if (!widget.article!.description.isEmptyOrNull)
                Text(parseHtmlString(widget.article!.description).capitalizeFirstLetter(),
                    style: secondaryTextStyle(size: 14), maxLines: 2, overflow: TextOverflow.ellipsis, textAlign: TextAlign.start),
              10.height,
              if (startDate != null)
                Row(
                  children: [
                    Text(parseDocumentDate(DateTime.parse(widget.article!.createdAt.validate()), includeTime: true).toString(), style: secondaryTextStyle(size: 12)).expand(),
                    Icon(Icons.circle, size: 6, color: grayColor),
                    4.width,
                    DateDifferenceWidget(startDate: startDate, endDate: currentDate),
                  ],
                ),
            ],
          ).paddingAll(8),
        ],
      ),
    );
  }
}
