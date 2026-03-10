import 'package:flutter/material.dart';
import '../extensions/extension_util/int_extensions.dart';
import '../extensions/extension_util/widget_extensions.dart';
import '../main.dart';
import '../utils/images.dart';
import '../components/app_bar_components.dart';
import '../components/settings_components.dart';
import '../utils/colors.dart';
import 'about_us_screen.dart';
import 'privacy_policy_screen.dart';
import 'terms_conditions_screen.dart';

class HelpCenterScreen extends StatefulWidget {
  const HelpCenterScreen({super.key});

  @override
  State<HelpCenterScreen> createState() => _HelpCenterScreenState();
}

class _HelpCenterScreenState extends State<HelpCenterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(language.aboutApp, context1: context, titleSpace: 0),
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SettingItemWidget(
            onTap: () {
              PrivacyPolicyScreen().launch(context);
            },
            title: language.privacyPolicy,
            leading: Image.asset(ic_privacy_policy, height: 20, width: 20, color: primaryColor),
            trailing: Icon(Icons.arrow_forward_ios_sharp, color: grayColor, size: 18)),
        14.height,
        SettingItemWidget(
            onTap: () {
              TermsConditionsScreen().launch(context);
            },
            title: language.termsCondition,
            leading: Image.asset(ic_terms_co, height: 20, width: 20, color: primaryColor),
            trailing: Icon(Icons.arrow_forward_ios_sharp, color: grayColor, size: 18)),
        14.height,
        SettingItemWidget(
            onTap: () {
              AboutUsScreen().launch(context);
            },
            title: language.aboutUs,
            leading: Image.asset(ic_about, height: 20, width: 20, color: primaryColor),
            trailing: Icon(Icons.arrow_forward_ios_sharp, color: grayColor, size: 18)),
      ]).paddingSymmetric(horizontal: 16),
    );
  }
}
