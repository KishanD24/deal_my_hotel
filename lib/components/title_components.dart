import 'package:flutter/material.dart';
import '../extensions/extension_util/int_extensions.dart';
import '../extensions/extension_util/string_extensions.dart';
import '../extensions/extension_util/widget_extensions.dart';
import '../main.dart';
import '../extensions/text_styles.dart';
import '../utils/colors.dart';

class TitleComponents extends StatefulWidget {
  final String? title;
  final Function()? onTap;
  final String? subTitle;
  final String? trailingTitle;

  TitleComponents({super.key, this.title, this.onTap, this.subTitle, this.trailingTitle});

  @override
  State<TitleComponents> createState() => _TitleComponentsState();
}

class _TitleComponentsState extends State<TitleComponents> {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(widget.title!.capitalizedByWord(), style: boldTextStyle(color: appStore.isDarkModeOn ? lightBackgroundColor : Colors.black, size: 18)),
            if (!widget.subTitle.isEmptyOrNull) 2.height,
            if (!widget.subTitle.isEmptyOrNull) Text(widget.subTitle!.capitalizeFirstLetter(), style: secondaryTextStyle())
          ],
        ).expand(),
        InkWell(
          focusColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: widget.onTap,
          splashColor: Colors.transparent,
          child: Text(widget.trailingTitle.validate(), style: primaryTextStyle(color: primaryColor)),
        ),
      ],
    ).paddingOnly(left: 16, right: 16, bottom: 12, top: 24);
  }
}
