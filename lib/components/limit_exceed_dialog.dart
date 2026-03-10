import 'package:flutter/material.dart';
import '../extensions/app_button.dart';
import '../extensions/decorations.dart';
import '../extensions/extension_util/context_extensions.dart';
import '../extensions/extension_util/int_extensions.dart';
import '../extensions/extension_util/widget_extensions.dart';
import '../extensions/system_utils.dart';
import '../extensions/text_styles.dart';
import '../main.dart';
import '../utils/colors.dart';

class LimitExceedDialog extends StatefulWidget {
  final Function()? onTap;

  const LimitExceedDialog({super.key, this.onTap});

  @override
  State<LimitExceedDialog> createState() => _LimitExceedDialogState();
}

class _LimitExceedDialogState extends State<LimitExceedDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.all(0),
      shape: dialogShape(),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            color: limitColor.withOpacity(0.10),
            padding: EdgeInsets.all(16),
            width: context.width(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                 language.limitExceeded,
                  style: primaryTextStyle(color: limitColor, size: 24),
                ),
                Icon(Icons.close, color: limitColor, size: 20).onTap(() {
                  finish(context);
                }),
              ],
            ),
          ),
          Column(
            children: [
              Text(language.limitMsg, style: primaryTextStyle()),
              18.height,
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  AppButton(
                    height: 40,
                    padding: EdgeInsets.zero,
                    text: language.cancel,
                    color: primaryVariant,
                    textColor: primaryColor,
                    elevation: 0,
                    onTap: () {
                      finish(context);
                    },
                  ).expand(),
                  10.width,
                  InkWell(
                    onTap: widget.onTap,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: boxDecorationWithRoundedCorners(borderRadius: radius(), backgroundColor: primaryColor),
                      child: Text(language.purchase, style: boldTextStyle(color: Colors.white)).center(),
                    ),
                  ).expand(),
                ],
              ),
            ],
          ).paddingSymmetric(horizontal: 16, vertical: 16),
        ],
      ),
    );
  }
}
