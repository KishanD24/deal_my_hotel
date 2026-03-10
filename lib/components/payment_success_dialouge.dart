import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../extensions/extension_util/context_extensions.dart';
import '../extensions/extension_util/int_extensions.dart';
import '../extensions/extension_util/string_extensions.dart';
import '../extensions/extension_util/widget_extensions.dart';
import '../extensions/text_styles.dart';
import '../extensions/app_button.dart';
import '../extensions/decorations.dart';
import '../extensions/system_utils.dart';
import '../main.dart';
import '../utils/colors.dart';
import '../utils/images.dart';

class PaymentSuccessDialog extends StatefulWidget {
  final Function()? onTap;

  PaymentSuccessDialog(this.onTap);

  @override
  State<PaymentSuccessDialog> createState() => _PaymentSuccessDialogState();
}

class _PaymentSuccessDialogState extends State<PaymentSuccessDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.all(0),
      backgroundColor: appStore.isDarkModeOn ? Colors.black : Colors.white,
      shape: dialogShape(),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        Lottie.asset(payment_success, height: context.height() * 0.2),
        20.height,
        Text(language.paymentSuccessfullyDone, style: boldTextStyle(size: 18)),
        10.height,
        Text(
          language.paymentSuccessfullyMsg.capitalizeFirstLetter(),
          style: secondaryTextStyle(),
          textAlign: TextAlign.center,
        ),
        20.height,
        AppButton(
          padding: EdgeInsets.zero,
          text: language.Continue,
          width: context.width(),
          color: primaryColor,
          elevation: 0,
          onTap: () {
            finish(context);
          },
        )
      ]).paddingSymmetric(horizontal: 16, vertical: 24),
    );
  }
}
