import 'package:flutter/material.dart';
import '../extensions/app_button.dart';
import '../extensions/decorations.dart';
import '../extensions/extension_util/context_extensions.dart';
import '../extensions/extension_util/int_extensions.dart';
import '../extensions/extension_util/string_extensions.dart';
import '../extensions/extension_util/widget_extensions.dart';
import '../extensions/system_utils.dart';
import '../extensions/text_styles.dart';
import '../main.dart';
import '../utils/colors.dart';
import '../utils/images.dart';

class BoostDialog extends StatefulWidget {
  final Function()? onAccept;

  BoostDialog({super.key, this.onAccept});

  @override
  State<BoostDialog> createState() => _BoostDialogState();
}

class _BoostDialogState extends State<BoostDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: appStore.isDarkModeOn ? dialogColor : Colors.white,
      contentPadding: EdgeInsets.all(16),
      shape: dialogShape(),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(ic_boost_img, height: context.height() * 0.2, fit: BoxFit.cover),
          18.height,
          Column(
            children: [
              Text(language.boostMsg.capitalizeFirstLetter(), style: boldTextStyle(), textAlign: TextAlign.center),
              18.height,
              Row(
                children: [
                  AppButton(
                    height: 40,
                    padding: EdgeInsets.zero,
                    text: language.cancel,
                    width: context.width(),
                    color: primaryVariant,
                    textColor: primaryColor,
                    elevation: 0,
                    onTap: () {
                      finish(context);
                    },
                  ).expand(),
                  10.width,
                  AppButton(
                    padding: EdgeInsets.zero,
                    height: 40,
                    text: language.boost,
                    width: context.width(),
                    elevation: 0,
                    color: primaryColor,
                    textColor: Colors.white,
                    onTap: widget.onAccept,
                  ).expand(),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
