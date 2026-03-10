import 'dart:developer';

import 'package:flutter/material.dart';
import '../extensions/extension_util/context_extensions.dart';
import '../extensions/extension_util/string_extensions.dart';
import '../extensions/extension_util/widget_extensions.dart';
import '../components/app_bar_components.dart';
import '../extensions/animatedList/animated_wrap.dart';
import '../extensions/colors.dart';
import '../extensions/decorations.dart';
import '../extensions/loader_widget.dart';
import '../extensions/text_styles.dart';
import '../main.dart';
import '../models/category_list_model.dart';
import '../network/RestApis.dart';
import '../utils/app_common.dart';
import '../utils/colors.dart';
import 'category_selected_screen.dart';
import 'no_data_screen.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  List<CategoryData> categoryData = [];

  int page = 1;
  int? numPage;

  bool isLastPage = false;

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

  Future<void> init() async {
    getPropertyCategory();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  Future<void> getPropertyCategory() async {
    log('📌 getPropertyCategory called | page: $page');

    appStore.setLoading(true);

    getCategory(page: page).then((value) {
      log('✅ API success');

      numPage = value.pagination!.totalPages;
      log('📄 Total pages: $numPage');

      isLastPage = false;

      if (page == 1) {
        log('🧹 Clearing old category data');
        categoryData.clear();
      }

      Iterable it = value.data!;
      log('📦 Items received: ${it.length}');

      it.map((e) {
        log('➕ Adding category: $e');
        categoryData.add(e);
      }).toList();

      appStore.setLoading(false);
      setState(() {});

      log('✅ Category list updated | total items: ${categoryData.length}');
    }).catchError((e, stackTrace) {
      isLastPage = true;
      appStore.setLoading(false);

      log(
        '❌ Error while fetching categories',
        error: e,
        stackTrace: stackTrace,
      );
    });
  }

  // Future<void> getPropertyCategory() async {
  //   appStore.setLoading(true);
  //   getCategory(page: page).then((value) {
  //     numPage = value.pagination!.totalPages;
  //     isLastPage = false;
  //     if (page == 1) {
  //       categoryData.clear();
  //     }
  //     Iterable it = value.data!;
  //     it.map((e) => categoryData.add(e)).toList();
  //     appStore.setLoading(false);
  //     setState(() {});
  //   }).catchError((e) {
  //     isLastPage = true;
  //     appStore.setLoading(false);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBarWidget(language.category, context1: context, titleSpace: 16, showBack: false),
        body: Stack(
          children: [
            categoryData.isNotEmpty
                ? SingleChildScrollView(
                    controller: scrollController,
                    child: AnimatedWrap(
                        runSpacing: 16,
                        spacing: 16,
                        children: List.generate(categoryData.length, (i) {
                          return Container(
                              width: (context.width() - 50) / 2,
                              child: Stack(children: [
                                cachedImage(categoryData[i].categoryImage, height: context.height() * 0.27, width: (context.width() - 50) / 2, fit: BoxFit.cover).cornerRadiusWithClipRRect(12),
                                Positioned(
                                    bottom: 10,
                                    left: 10,
                                    right: 10,
                                    child: Container(
                                        padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                        decoration: boxDecorationWithRoundedCorners(borderRadius: radius(8), backgroundColor: appStore.isDarkModeOn ? cardDarkColor : primaryExtraLight),
                                        child: Text(categoryData[i].name.toString().capitalizeFirstLetter(), style: primaryTextStyle(), maxLines: 2, textAlign: TextAlign.center).center())),
                              ]).onTap(() {
                                CategorySelectedScreen(categoryId: categoryData[i].id, categoryName: categoryData[i].name.toString()).launch(context);
                              }));
                        })).paddingSymmetric(horizontal: 16).paddingBottom(20),
                  )
                : NoDataScreen(mTitle: language.resultNotFound).visible(!appStore.isLoading),
            Loader().center().visible(appStore.isLoading)
          ],
        ));
  }
}
