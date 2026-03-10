import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import '../store/AppStore.dart';
import '../store/UserStore/UserStore.dart';
import '../utils/app_common.dart';
import '../utils/app_config.dart';
import '../utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../extensions/extension_util/string_extensions.dart';
import '../screens/no_internet_screen.dart';
import '../screens/splash_screen.dart';
import '../services/user_services.dart';
import 'app_theme.dart';
import 'extensions/common.dart';
import 'extensions/shared_pref.dart';
import 'extensions/system_utils.dart';
import 'languageConfiguration/AppLocalizations.dart';
import 'languageConfiguration/BaseLanguage.dart';
import 'languageConfiguration/LanguageDataConstant.dart';
import 'languageConfiguration/LanguageDefaultJson.dart';
import 'languageConfiguration/ServerLanguageResponse.dart';

final navigatorKey = GlobalKey<NavigatorState>();
UserService userService = UserService();

late SharedPreferences sharedPreferences;
AppStore appStore = AppStore();
UserStore userStore = UserStore();

late BaseLanguage language;

// Added by SK
LanguageJsonData? selectedServerLanguageData;
List<LanguageJsonData>? defaultServerLanguageData = [];

// Remove By SK
/*List<LanguageDataModel> localeLanguageList = [];
LanguageDataModel? selectedLanguageDataModel;*/

StreamSubscription<Position>? positionStream;
bool isCurrentlyOnNoInternet = false;

get getContext1 => navigatorKey.currentState?.overlay?.context;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp().then((value) {
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  });
  sharedPreferences = await SharedPreferences.getInstance();
  appStore.setLogin(getBoolAsync(IS_LOGGED_IN), isInitializing: true);
  int themeModeIndex = getIntAsync(THEME_MODE_INDEX,
      defaultValue: AppThemeMode().themeModeLight);
  if (themeModeIndex == AppThemeMode().themeModeLight) {
    appStore.setDarkMode(false);
  } else if (themeModeIndex == AppThemeMode().themeModeDark) {
    appStore.setDarkMode(true);
  }

// Added By SK



  appStore.setLanguage(getStringAsync(SELECTED_LANGUAGE_CODE,
      defaultValue: defaultLanguageCode));
  // Remove By SK
  // await initialize(aLocaleLanguageList: languageList());
  // appStore.setLanguage(DEFAULT_LANGUAGE);
  setLogInValue();
  oneSignalData();

  // Added By SK
  initJsonFile();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MyApp());
}



class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isCurrentlyOnNoInternet = false;

  bool isLogin = false;

  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    initConnectivity();

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      log('Couldn\'t check connectivity status' + e.message.validate());
      return;
    }
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    _connectionStatus = result;
    if (_connectionStatus == ConnectivityResult.none) {
      log('not connected');
      isCurrentlyOnNoInternet = true;
      push(NoInternetScreen());
    } else {
      if (isCurrentlyOnNoInternet) {
        pop();
        isCurrentlyOnNoInternet = false;
      }
      log('connected');
    }
    print("_connectionStatus-->" + _connectionStatus.name);
  }

  @override
  void didChangeDependencies() {
    if (getIntAsync(THEME_MODE_INDEX) == ThemeModeSystem)
      appStore.setDarkMode(
          MediaQuery.of(context).platformBrightness == Brightness.dark);
    super.didChangeDependencies();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
    _connectivitySubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      return MaterialApp(
        navigatorKey: navigatorKey,
        scrollBehavior: SBehavior(),
        // Changes By SK
        supportedLocales: getSupportedLocales(),
        // Change By SK
        locale: Locale(
            appStore.selectedLanguage.validate(value: defaultLanguageCode)),
        localizationsDelegates: [
          CountryLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          AppLocalizations(),
        ],
        localeResolutionCallback: (locale, supportedLocales) => locale,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        debugShowCheckedModeBanner: false,
        themeMode: appStore.isDarkModeOn ? ThemeMode.dark : ThemeMode.light,
        title: APP_NAME,
        home: SplashScreen(),
      );
    });
  }
}
