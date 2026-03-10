import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../extensions/colors.dart';
import '../extensions/extension_util/context_extensions.dart';
import '../extensions/extension_util/int_extensions.dart';
import '../extensions/extension_util/string_extensions.dart';
import '../screens/no_data_screen.dart';
import '../../components/app_bar_components.dart';
import '../extensions/common.dart';
import '../extensions/extension_util/widget_extensions.dart';
import '../extensions/loader_widget.dart';
import '../extensions/text_styles.dart';
import '../main.dart';
import '../models/article_model.dart';
import '../network/RestApis.dart';
import '../utils/app_common.dart';
import 'news_details_screen.dart';

class NewsAllScreen extends StatefulWidget {
  NewsAllScreen({super.key});

  @override
  State<NewsAllScreen> createState() => _NewsAllScreenState();
}

class _NewsAllScreenState extends State<NewsAllScreen> {
  final currentDate = DateTime.now();
  ScrollController scrollController = ScrollController();

  int page = 1;
  int? numPage;

  List<Article>? mArticleList = [];

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
    appStore.setLoading(true);
    await getArticles(id: 0, page: page).then((value) {
      numPage = value.pagination!.totalPages;
      if (page == 1) {
        mArticleList!.clear();
      }
      Iterable it = value.data!;
      it.map((e) => mArticleList!.add(e)).toList();
      appStore.setLoading(false);
      setState(() {});
    }).catchError((e) {
      appStore.setLoading(false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(language.newsArticles, context1: context, textColor: black, center: false, titleSpace: 0),
      body: Stack(
        children: [
          mArticleList!.isNotEmpty
              ? ListView.builder(
                  controller: scrollController,
                  shrinkWrap: true,
                  itemCount: mArticleList!.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.only(bottom: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          cachedImage(
                            mArticleList![index].articleImage.validate(),
                            height: 110,
                            fit: BoxFit.cover,
                            width: context.width(),
                          ).cornerRadiusWithClipRRectOnly(topRight: 12, topLeft: 12),
                          10.height,
                          Text(parseHtmlString(mArticleList![index].name.validate().capitalizeFirstLetter()), style: boldTextStyle(size: 16), maxLines: 2, overflow: TextOverflow.ellipsis),
                          10.height,
                          Text(
                            parseHtmlString(mArticleList![index].description.validate()),
                            style: secondaryTextStyle(size: 14),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.start,
                          ).visible(!mArticleList![index].description.isEmptyOrNull),
                          10.height.visible(!mArticleList![index].description.isEmptyOrNull),
                          Row(
                            children: [
                              Text(parseDocumentDate(DateTime.parse(mArticleList![index].createdAt.validate())), style: secondaryTextStyle(size: 12)),
                              10.width,
                              Icon(Icons.circle, size: 4, color: gray),
                              4.width,
                              DateDifferenceWidget(startDate: DateTime.parse(mArticleList![index].createdAt.validate()), endDate: currentDate),
                            ],
                          ),
                          10.height,
                        ],
                      ),
                    ).paddingSymmetric(horizontal: 16).onTap(() {
                      NewsDetailsScreen(articles: mArticleList![index]).launch(context);
                    });
                  })
              : NoDataScreen().center().visible(!appStore.isLoading),
          Observer(builder: (context) {
            return Loader().center().visible(appStore.isLoading);
          })
        ],
      ),
    );
  }
}
