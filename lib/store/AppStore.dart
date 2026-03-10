import 'package:flutter/material.dart';
import '../languageConfiguration/AppLocalizations.dart';
import '../languageConfiguration/BaseLanguage.dart';
import '../languageConfiguration/LanguageDataConstant.dart';
// import '../models/language_data_model.dart';
import 'package:mobx/mobx.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';
// import '../language/Applocalization.dart';
// import '../language/BaseLanguage.dart';
import '../main.dart';
import '../extensions/colors.dart';
import '../extensions/shared_pref.dart';

part 'AppStore.g.dart';

class AppStore = _AppStore with _$AppStore;

abstract class _AppStore with Store {
  @observable
  String userEmail = '';

  @observable
  String selectedLanguage = "";

  @observable
  bool isLoading = false;

  @observable
  bool isLoggedIn = false;

  @observable
  String uid = '';

  @observable
  String userProfile = '';

  @action
  Future<void> setLogin(bool val, {bool isInitializing = false}) async {
    isLoggedIn = val;
    if (!isInitializing) await setValue(IS_LOGGED_IN, val);
  }

  @action
  Future<void> setLoading(bool val) async {
    isLoading = val;
  }

  @action
  Future<void> setUserEmail(String val, {bool isInitialization = false}) async {
    userEmail = val;
  }

  @action
  Future<void> setUId(String val, {bool isInitializing = false}) async {
    uid = val;
    if (!isInitializing) await setValue(UID, val);
  }

  @action
  Future<void> setLanguage(String aCode, {BuildContext? context}) async {
    setDefaultLocate();
    selectedLanguage = aCode;
    if (context != null) language = BaseLanguage.of(context)!;
    language = (await AppLocalizations().load(Locale(selectedLanguage)));
  }

  @action
  Future<void> setDarkMode(bool aIsDarkMode) async {
    isDarkModeOn = aIsDarkMode;

    if (isDarkModeOn) {
      textPrimaryColorGlobal = Colors.white;
      textSecondaryColorGlobal = viewLineColor;

      defaultLoaderBgColorGlobal = Colors.black26;
      defaultLoaderAccentColorGlobal = Colors.white;
      appButtonBackgroundColorGlobal = Colors.white;
      shadowColorGlobal = Colors.white12;
    } else {
      textPrimaryColorGlobal = textPrimaryColor;
      textSecondaryColorGlobal = textSecondaryColor;
      defaultLoaderAccentColorGlobal = primaryColor;
      defaultLoaderBgColorGlobal = Colors.white;
      appButtonBackgroundColorGlobal = primaryColor;
      shadowColorGlobal = Colors.black12;
    }
    await setValue(isDarkModeOnPref, isDarkModeOn);
  }

  @observable
  bool isDarkModeOn = false;

  @observable
  int addPropertyIndex = 0;
}
