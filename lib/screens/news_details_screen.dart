import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import '../../components/app_bar_components.dart';
import '../../extensions/extension_util/context_extensions.dart';
import '../../extensions/extension_util/int_extensions.dart';
import '../../extensions/extension_util/string_extensions.dart';
import '../../extensions/extension_util/widget_extensions.dart';
import '../../extensions/text_styles.dart';
import '../../screens/tags_screen.dart';
import '../../utils/constants.dart';
import 'package:share_plus/share_plus.dart';
import '../components/HtmlWidget.dart';
import '../extensions/decorations.dart';
import '../main.dart';
import '../models/article_model.dart';
import '../utils/app_common.dart';
import '../utils/app_config.dart';
import '../utils/colors.dart';

class NewsDetailsScreen extends StatefulWidget {
  final Article articles;

  const NewsDetailsScreen({super.key, required this.articles});

  @override
  State<NewsDetailsScreen> createState() => _NewsDetailsScreenState();
}

class _NewsDetailsScreenState extends State<NewsDetailsScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    if (showArticleDetail) loadInterstitialAds();
  }

  @override
  void dispose() {
    if (showArticleDetail) showInterstitialAds();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBarWidget("", context1: context, titleSpace: 0, actions: [
          Icon(Ionicons.share_social, size: 20, color: primaryColor).paddingSymmetric(horizontal: 16).onTap(() {
            Share.share(language.checkoutNewsArticles + " " + widget.articles.name.validate(), subject: widget.articles.name.validate());
          })
        ]),
        body: SingleChildScrollView(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Stack(
              children: [
                cachedImage(widget.articles.articleImage.validate(), height: context.height() * 0.32, width: context.width(), fit: BoxFit.fill)
                    .cornerRadiusWithClipRRect(defaultRadius)
                    .paddingSymmetric(horizontal: 16),
                Positioned(
                  left: 30,
                  bottom: 12,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    decoration: boxDecorationWithRoundedCorners(borderRadius: radius(8)),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(MaterialCommunityIcons.clock_time_five_outline, size: 18, color: primaryColor),
                        4.width,
                        Text(parseDocumentDate(DateTime.parse(widget.articles.createdAt.validate())), style: primaryTextStyle(color: primaryColor, size: 14)),
                      ],
                    ),
                  ),
                )
              ],
            ),
            20.height,
            Text(widget.articles.name.validate().capitalizeFirstLetter(), style: boldTextStyle(size: 20)).paddingSymmetric(horizontal: 16),
            20.height,
            Wrap(
              runSpacing: 8,
              spacing: 8,
              children: List.generate(widget.articles.tags!.length, (index) {
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: boxDecorationWithRoundedCorners(backgroundColor: context.cardColor, borderRadius: radius(24), border: Border.all(width: 0.3, color: primaryColor)),
                  child: Text(widget.articles.tags![index].name.validate(), style: secondaryTextStyle(color: primaryColor), maxLines: 1, overflow: TextOverflow.ellipsis),
                ).onTap(() {
                  TagsScreen(id: widget.articles.tags![index].id.validate(), title: widget.articles.tags![index].name.validate()).launch(context);
                });
              }),
            ).paddingSymmetric(horizontal: 16),
            HtmlWidget(postContent: widget.articles.description.validate(), color: appStore.isDarkModeOn ? Colors.white : Colors.black).paddingSymmetric(horizontal: 10),
          ]),
        ));
  }
}
