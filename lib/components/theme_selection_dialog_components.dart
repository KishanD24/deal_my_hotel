import 'package:flutter/material.dart';
import '../extensions/common.dart';
import '../extensions/decorations.dart';
import '../extensions/extension_util/context_extensions.dart';
import '../extensions/shared_pref.dart';
import '../extensions/system_utils.dart';
import '../extensions/text_styles.dart';
import '../main.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';

class ThemeSelectionDialog extends StatefulWidget {
  static String tag = '/ThemeSelectionDialog';

  @override
  ThemeSelectionDialogState createState() => ThemeSelectionDialogState();
}

class ThemeSelectionDialogState extends State<ThemeSelectionDialog> {
  int valueTheme = 0;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    valueTheme = sharedPreferences.getInt(THEME_MODE_INDEX) ?? AppThemeMode().themeModeLight;
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    List<String?> themeModeList = [language.light, language.dark, language.systemDefault];
    return Container(
      decoration: boxDecorationWithRoundedCorners(backgroundColor: context.cardColor, borderRadius: radius()),
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: boxDecorationWithRoundedCorners(backgroundColor: primaryColor, borderRadius: radiusOnly(topLeft: defaultRadius, topRight: defaultRadius)),
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(language.chooseTheme, style: boldTextStyle(size: 20, color: Colors.white)),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context, true);
                  },
                  child: Icon(Icons.close_outlined, color: Colors.white),
                )
              ],
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.symmetric(vertical: 10),
            itemCount: themeModeList.length,
            itemBuilder: (BuildContext context, int index) {
              return RadioListTile(
                dense: true,
                value: index,
                activeColor: primaryColor,
                groupValue: valueTheme,
                title: Text(themeModeList[index]!, style: primaryTextStyle(size: 16)),
                onChanged: (dynamic val) {
                  valueTheme = val;
                  setValue(THEME_MODE_INDEX, val);
                  if (val == ThemeModeSystem) {
                    appStore.setDarkMode(MediaQuery.of(context).platformBrightness == Brightness.dark);
                  } else if (val == ThemeModeLight) {
                    appStore.setDarkMode(false);
                  } else if (val == ThemeModeDark) {
                    appStore.setDarkMode(true);
                  }
                  setState(() {});
                  afterBuildCreated(() {
                    finish(context);
                  });
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
