import 'package:flutter/material.dart';
import '../main.dart';
import '../utils/images.dart';

import '../extensions/extension_util/context_extensions.dart';
import '../extensions/extension_util/int_extensions.dart';
import '../extensions/extension_util/widget_extensions.dart';
import '../extensions/text_styles.dart';

class NoDataScreen extends StatefulWidget {
  static String tag = '/NoDataScreen';

  final String? mTitle;

  NoDataScreen({this.mTitle});

  @override
  NoDataScreenState createState() => NoDataScreenState();
}

class NoDataScreenState extends State<NoDataScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,
      children: [Image.asset(no_data, height: context.height() * 0.2, width: context.width() * 0.4), 16.height, Text(widget.mTitle ?? language.noFoundData, style: boldTextStyle())],
    ).center();
  }
}
