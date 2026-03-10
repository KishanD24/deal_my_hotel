import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../components/HtmlWidget.dart';
import '../components/app_bar_components.dart';
import '../extensions/extension_util/widget_extensions.dart';
import '../main.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: appStore.isDarkModeOn ? Brightness.light : Brightness.light,
        systemNavigationBarIconBrightness: appStore.isDarkModeOn ? Brightness.light : Brightness.light,
      ),
      child: Scaffold(
        appBar: appBarWidget(language.privacyPolicy, context1: context,titleSpace: 0),
        body: SingleChildScrollView(
            padding: EdgeInsets.zero,
            child: HtmlWidget(postContent: userStore.privacyPolicy).paddingSymmetric(horizontal: 10)),
      ),
    );
  }
}
