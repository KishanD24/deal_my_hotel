import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../components/HtmlWidget.dart';
import '../components/app_bar_components.dart';
import '../extensions/extension_util/widget_extensions.dart';
import '../main.dart';

class TermsConditionsScreen extends StatefulWidget {
  const TermsConditionsScreen({super.key});

  @override
  State<TermsConditionsScreen> createState() => _TermsConditionsScreenState();
}

class _TermsConditionsScreenState extends State<TermsConditionsScreen> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: appStore.isDarkModeOn ? Brightness.light : Brightness.light,
        systemNavigationBarIconBrightness: appStore.isDarkModeOn ? Brightness.light : Brightness.light,
      ),
      child: Scaffold(
        appBar: appBarWidget(language.termsCondition, context1: context,titleSpace: 0),
        body: SingleChildScrollView(child: HtmlWidget(postContent: userStore.termsCondition).paddingSymmetric(horizontal: 10)),
      ),
    );
  }
}
