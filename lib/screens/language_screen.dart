import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../extensions/extension_util/int_extensions.dart';
import '../../extensions/extension_util/widget_extensions.dart';
import '../components/app_bar_components.dart';
import '../extensions/animatedList/animated_list_view.dart';
import '../extensions/colors.dart';
import '../extensions/decorations.dart';
import '../extensions/extension_util/string_extensions.dart';
import '../extensions/shared_pref.dart';
import '../extensions/system_utils.dart';
import '../extensions/text_styles.dart';
import '../languageConfiguration/LanguageDataConstant.dart';
import '../languageConfiguration/LanguageDefaultJson.dart';
import '../languageConfiguration/ServerLanguageResponse.dart';
import '../main.dart';
import '../utils/colors.dart';
import '../utils/images.dart';

class LanguageScreen extends StatefulWidget {
  @override
  _LanguageScreenState createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();


    print( defaultServerLanguageData!.length);
  }
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: appStore.isDarkModeOn ? Brightness.light : Brightness.light,
        systemNavigationBarIconBrightness: appStore.isDarkModeOn ? Brightness.light : Brightness.light,
      ),
      child: Scaffold(
        appBar: appBarWidget(language.language, context1: context,titleSpace: 0),
        body: AnimatedListView(
          itemCount: defaultServerLanguageData!.length,
          padding: EdgeInsets.all(16),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            LanguageJsonData data = defaultServerLanguageData![index];
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              margin: EdgeInsets.only(bottom: 16),
              decoration: boxDecorationWithRoundedCorners(
                  backgroundColor: getStringAsync(SELECTED_LANGUAGE_CODE, defaultValue: defaultLanguageCode) == data.languageCode.validate()
                      ? primaryColor
                      : appStore.isDarkModeOn
                          ? cardDarkColor
                          : primaryExtraLight),
              child: Column(
                children: [
                  Row(children: [
                  //  Image.asset(data.flag.validate(), width: 32, fit: BoxFit.cover),
                    16.width,
                    Text('${data.languageName.validate()}',
                            style: boldTextStyle(
                                color: getStringAsync(SELECTED_LANGUAGE_CODE, defaultValue: defaultLanguageCode) == data.languageCode.validate()
                                    ? Colors.white
                                    : appStore.isDarkModeOn
                                        ? Colors.white
                                        : Colors.black))
                        .expand(),
                    getStringAsync(SELECTED_LANGUAGE_CODE, defaultValue: defaultLanguageCode) == data.languageCode.validate()
                        ? Image.asset(ic_radio_fill, height: 20, width: 20, color: Colors.white)
                        : Image.asset(ic_radio, color: primaryColor, height: 20, width: 20)
                  ]),
                  4.height,
                  // Divider(),
                ],
              ).paddingSymmetric(vertical: 4).onTap(() async {
                setValue(SELECTED_LANGUAGE_CODE, data.languageCode);
                setValue(SELECTED_LANGUAGE_COUNTRY_CODE, data.countryCode);
                selectedServerLanguageData = data;
                setValue(IS_SELECTED_LANGUAGE_CHANGE, true);
                appStore.setLanguage(data.languageCode!, context: context);
                finish(context, true);
                setState(() {});
              }),
            );
          },
        ),
      ),
    );
  }
}
