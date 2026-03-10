import 'package:flutter/material.dart';
import '../extensions/colors.dart';
import '../extensions/extension_util/context_extensions.dart';
import '../extensions/extension_util/string_extensions.dart';
import '../extensions/extension_util/widget_extensions.dart';
import '../main.dart';
import '../extensions/extension_util/int_extensions.dart';
import '../extensions/text_styles.dart';
import '../utils/colors.dart';
import '../utils/images.dart';

class SearchCategoryComponents extends StatefulWidget {
  final String? title;

  SearchCategoryComponents({super.key, this.title});

  @override
  State<SearchCategoryComponents> createState() => _SearchCategoryComponentsState();
}

class _SearchCategoryComponentsState extends State<SearchCategoryComponents> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.width() * 0.6,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6.0),
        color: appStore.isDarkModeOn ? cardDarkColor : primaryExtraLight,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(widget.title.validate(), maxLines: 2, overflow: TextOverflow.ellipsis, style: primaryTextStyle(color: appStore.isDarkModeOn ? Colors.white : grayColor, size: 14)).expand(),
          4.width,
          Image.asset(ic_forward_arrow, height: 20, width: 20)
        ],
      ),
    );
  }
}
