import 'package:flutter/material.dart';
import '../components/app_bar_components.dart';
import '../extensions/extension_util/context_extensions.dart';
import '../extensions/extension_util/int_extensions.dart';
import '../extensions/extension_util/string_extensions.dart';
import '../extensions/extension_util/widget_extensions.dart';
import '../extensions/loader_widget.dart';
import '../utils/app_common.dart';
import '../extensions/colors.dart';
import '../extensions/common.dart';
import '../extensions/text_styles.dart';
import '../main.dart';
import '../models/article_model.dart';
import '../network/RestApis.dart';
import 'news_details_screen.dart';

class TagsScreen extends StatefulWidget {
  final int? id;
  final String? title;

  TagsScreen({this.id, this.title});

  @override
  State<TagsScreen> createState() => _TagsScreenState();
}

class _TagsScreenState extends State<TagsScreen> {
  ScrollController scrollController = ScrollController();

  List<Article> mArticle = [];
  int page = 1;
  int? numPage;

  final currentDate = DateTime.now();

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
    //
    getTagsList(id: widget.id);
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  Future<void> getTagsList({int? id}) async {
    appStore.setLoading(true);
    getArticles(id: id, page: page).then((value) {
      appStore.setLoading(false);
      numPage = value.pagination!.totalPages;
      if (page == 1) {
        mArticle.clear();
      }
      Iterable it = value.data!;
      it.map((e) => mArticle.add(e)).toList();
      setState(() {});
    }).catchError((e) {
      appStore.setLoading(false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(widget.title.toString(), context1: context, titleSpace: 0),
      body: Stack(
        children: [
          ListView.builder(
              controller: scrollController,
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(horizontal: 16),
              itemCount: mArticle.length,
              itemBuilder: (context, index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    cachedImage(mArticle[index].articleImage.validate(), height: 110, fit: BoxFit.cover, width: context.width()).cornerRadiusWithClipRRectOnly(topRight: 12, topLeft: 12),
                    10.height,
                    Text(parseHtmlString(mArticle[index].name.validate()), style: boldTextStyle(), maxLines: 2, overflow: TextOverflow.ellipsis),
                    10.height,
                    Text(
                      parseHtmlString(mArticle[index].description.validate()),
                      style: secondaryTextStyle(),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.start,
                    ).visible(!mArticle[index].description.isEmptyOrNull),
                    10.height.visible(!mArticle[index].description.isEmptyOrNull),
                    Row(
                      children: [
                        Text(parseDocumentDate(DateTime.parse(mArticle[index].createdAt.validate())), style: secondaryTextStyle(size: 12)),
                        10.width,
                        Icon(Icons.circle, size: 4, color: gray),
                        4.width,
                        DateDifferenceWidget(startDate: DateTime.parse(mArticle[index].createdAt.validate()), endDate: currentDate),
                      ],
                    ),
                  ],
                ).paddingOnly(bottom: 16).onTap(() {
                  NewsDetailsScreen(articles: mArticle[index]).launch(context);
                });
              }),
          Loader().center().visible(appStore.isLoading)
        ],
      ),
    );
  }
}
