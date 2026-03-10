import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../components/app_bar_components.dart';
import '../extensions/extension_util/int_extensions.dart';
import '../extensions/extension_util/widget_extensions.dart';
import '../main.dart';
import '../screens/language_screen.dart';
import '../components/settings_components.dart';
import '../components/theme_selection_dialog_components.dart';
import '../extensions/decorations.dart';
import '../extensions/widgets.dart';
import '../utils/colors.dart';
import '../utils/images.dart';

class SettingScreen extends StatefulWidget {
  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      return Scaffold(
        appBar: appBarWidget(language.setting, context1: context, titleSpace: 0),
        body: Column(
          children: [
            SettingItemWidget(
              onTap: () {
                LanguageScreen().launch(context);
              },
              title: language.language,
              leading: Image.asset(ic_language, height: 20, width: 20, color: primaryColor),
              trailing: Icon(Icons.arrow_forward_ios_sharp, color: grayColor, size: 18),
            ),
            14.height,
            SettingItemWidget(
              onTap: () async {
                await showInDialog(context, shape: RoundedRectangleBorder(borderRadius: radius(12)), builder: (_) => ThemeSelectionDialog(), contentPadding: EdgeInsets.zero);
              },
              title: language.appTheme,
              leading: Image.asset(ic_theme, height: 20, width: 20, color: primaryColor),
              trailing: Icon(Icons.arrow_forward_ios_sharp, color: grayColor, size: 18),
            ),
          ],
        ).paddingSymmetric(horizontal: 16),
      );
    });
  }
}
