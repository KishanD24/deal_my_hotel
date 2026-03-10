import 'package:flutter/material.dart';
import '../extensions/extension_util/context_extensions.dart';
import '../extensions/extension_util/int_extensions.dart';
import '../extensions/extension_util/widget_extensions.dart';
import '../extensions/text_styles.dart';
import '../main.dart';
import '../screens/dashboard_screen.dart';
import '../screens/property_detail_screen.dart';
import '../utils/images.dart';
import '../extensions/app_button.dart';
import '../utils/colors.dart';

class SuccessPropertyScreen extends StatefulWidget {
  final int? propertyId;

  const SuccessPropertyScreen({required this.propertyId});

  @override
  State<SuccessPropertyScreen> createState() => _SuccessPropertyScreenState();
}

class _SuccessPropertyScreenState extends State<SuccessPropertyScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Image.asset(
          ic_property_success,
          width: 200,
          height: 200,
        ),
        20.height,
        Text(language.congratulations, style: boldTextStyle(size: 30, color: primaryColor)),
        20.height,
        Text(language.yourPropertySubmittedSuccessfully, style: secondaryTextStyle(size: 16)),
        50.height,
        AppButton(
          text: language.previewProperty,
          width: context.width(),
          color: primaryColor,
          textColor: Colors.white,
          onTap: () {
            PropertyDetailScreen(
                isSuccess: true,
                propertyId: widget.propertyId,
                onCall: () {
                  setState(() {});
                }).launch(context);
          },
        ),
        30.height,
        TextButton(
          onPressed: () {
            DashboardScreen().launch(context, isNewTask: true);
          },
          child: Text(language.backToHome, style: primaryTextStyle(color: primaryColor)),
        )
      ]).paddingSymmetric(horizontal: 16),
    );
  }
}
