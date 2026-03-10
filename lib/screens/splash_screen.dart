// import 'dart:convert';
// import 'dart:math';
//
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import '../languageConfiguration/LanguageDataConstant.dart';
// import '../languageConfiguration/ServerLanguageResponse.dart';
// import '../network/RestApis.dart';
// import '../screens/walk_through_screen.dart';
// import '../extensions/extension_util/widget_extensions.dart';
// import '../extensions/shared_pref.dart';
// import '../main.dart';
// import '../utils/colors.dart';
// import '../utils/constants.dart';
// import '../utils/images.dart';
// import 'dashboard_screen.dart';
// import 'login_screen.dart';
//
// class SplashScreen extends StatefulWidget {
//   static String tag = '/SplashScreen';
//
//   @override
//   SplashScreenState createState() => SplashScreenState();
// }
//
// class SplashScreenState extends State<SplashScreen> with WidgetsBindingObserver {
//   @override
//   void initState() {
//     super.initState();
//
//     init();
//   }
//
//   void init() async {
//     appStore.setLoading(true);
//
//     String versionNo = await getStringAsync(CURRENT_LAN_VERSION,
//         defaultValue: LanguageVersion);
//     await getLanguageList(versionNo).then((value) {
//       appStore.setLoading(false);
//       if (value.status == true) {
//         setValue(CURRENT_LAN_VERSION, value.currentVersionNo.toString());
//         if (value.data!.length > 0) {
//           defaultServerLanguageData = value.data;
//           performLanguageOperation(defaultServerLanguageData);
//           setValue(LanguageJsonDataRes, value.toJson());
//           /// Check if default language set from server
//           bool isSetLanguage =
//           getBoolAsync(IS_SELECTED_LANGUAGE_CHANGE, defaultValue: false);
//           if (!isSetLanguage) {
//             for (int i = 0; i < value.data!.length; i++) {
//               if (value.data![i].isDefaultLanguage == 1) {
//                 setValue(SELECTED_LANGUAGE_CODE, value.data![i].languageCode);
//                 setValue(
//                     SELECTED_LANGUAGE_COUNTRY_CODE, value.data![i].countryCode);
//                 appStore.setLanguage(value.data![i].languageCode!,
//                     context: context);
//                 break;
//               }
//             }
//           }
//         } else {
//           defaultServerLanguageData = [];
//           selectedServerLanguageData = null;
//           setValue(LanguageJsonDataRes, "");
//         }
//       } else {
//         String getJsonData =
//         getStringAsync(LanguageJsonDataRes, defaultValue: "");
//         if (getJsonData.isNotEmpty) {
//           ServerLanguageResponse languageSettings =
//           ServerLanguageResponse.fromJson(json.decode(getJsonData.trim()));
//           if (languageSettings.data!.length > 0) {
//             defaultServerLanguageData = languageSettings.data;
//             performLanguageOperation(defaultServerLanguageData);
//           }
//         }
//       }
//     }).catchError((error) {
//       appStore.setLoading(false);
//       // log(error);
//       // print(error);
//     });
//
//
//     //await 3.seconds.delay;
//     if (!getBoolAsync(IS_FIRST_TIME)) {
//       WalkThroughScreen().launch(context, isNewTask: true);
//     } else {
//       if (appStore.isLoggedIn) {
//         DashboardScreen().launch(context, isNewTask: true);
//       } else {
//         LoginScreen().launch(context, isNewTask: false);
//       }
//     }
//   }
//
//   @override
//   void setState(fn) {
//     if (mounted) super.setState(fn);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return AnnotatedRegion(
//       value: SystemUiOverlayStyle(
//         statusBarColor: Colors.transparent,
//         statusBarIconBrightness: appStore.isDarkModeOn ? Brightness.light : Brightness.light,
//         systemNavigationBarIconBrightness: appStore.isDarkModeOn ? Brightness.light : Brightness.light,
//       ),
//       child: Scaffold(
//         backgroundColor: primaryColor,
//         body: Image.asset(splash,height:200 ,width: 200,).center(),
//       ),
//     );
//   }
// }

import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../languageConfiguration/LanguageDataConstant.dart';
import '../languageConfiguration/ServerLanguageResponse.dart';
import '../network/RestApis.dart';
import '../screens/walk_through_screen.dart';
import '../extensions/extension_util/widget_extensions.dart';
import '../extensions/shared_pref.dart';
import '../main.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';
import '../utils/images.dart';
import 'dashboard_screen.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  static String tag = '/SplashScreen';

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animation controller
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    // Create position animation (down to up)
    _animation = Tween<double>(
      begin: -0.5, // Start from bottom (outside screen)
      end: 0.0, // End at center
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.fastOutSlowIn,
      ),
    );

    // Create opacity animation
    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.4, 1.0, curve: Curves.easeIn),
      ),
    );

    // Start animation
    _controller.forward();

    init();
  }

  void init() async {
    appStore.setLoading(true);

    String versionNo = await getStringAsync(CURRENT_LAN_VERSION,
        defaultValue: LanguageVersion);
    await getLanguageList(versionNo).then((value) {
      appStore.setLoading(false);
      if (value.status == true) {
        setValue(CURRENT_LAN_VERSION, value.currentVersionNo.toString());
        if (value.data!.length > 0) {
          defaultServerLanguageData = value.data;

          performLanguageOperation(defaultServerLanguageData);
          setValue(LanguageJsonDataRes, value.toJson());

          print("Lang\nas");
          print(defaultServerLanguageData.toString());

          /// Check if default language set from server
          bool isSetLanguage =
              getBoolAsync(IS_SELECTED_LANGUAGE_CHANGE, defaultValue: false);
          if (!isSetLanguage) {
            for (int i = 0; i < value.data!.length; i++) {
              if (value.data![i].isDefaultLanguage == 1) {
                setValue(SELECTED_LANGUAGE_CODE, value.data![i].languageCode);
                setValue(
                    SELECTED_LANGUAGE_COUNTRY_CODE, value.data![i].countryCode);
                appStore.setLanguage(value.data![i].languageCode!,
                    context: context);
                break;
              }
            }
          }
        } else {
          defaultServerLanguageData = [];
          selectedServerLanguageData = null;
          setValue(LanguageJsonDataRes, "");
        }
      } else {
        String getJsonData =
            getStringAsync(LanguageJsonDataRes, defaultValue: "");
        if (getJsonData.isNotEmpty) {
          ServerLanguageResponse languageSettings =
              ServerLanguageResponse.fromJson(json.decode(getJsonData.trim()));
          if (languageSettings.data!.length > 0) {
            defaultServerLanguageData = languageSettings.data;
            performLanguageOperation(defaultServerLanguageData);
          }
        }
      }
    }).catchError((error) {
      appStore.setLoading(false);
      // log(error);
      // print(error);
    });

    // Navigate after delay
    Timer(Duration(milliseconds: 2000), () {
      if (!getBoolAsync(IS_FIRST_TIME)) {
        WalkThroughScreen().launch(context, isNewTask: true);
      } else {
        if (appStore.isLoggedIn) {
          DashboardScreen().launch(context, isNewTask: true);
        } else {
          LoginScreen().launch(context, isNewTask: false);
        }
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Calculate responsive logo size
    final logoSize = min(screenWidth, screenHeight) * 0.5;

    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness:
            appStore.isDarkModeOn ? Brightness.light : Brightness.light,
        systemNavigationBarIconBrightness:
            appStore.isDarkModeOn ? Brightness.light : Brightness.light,
      ),
      child: Scaffold(
        backgroundColor:   appStore.isDarkModeOn?Colors.black:Colors.white,
        body: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(
                0,
                _animation.value * screenHeight, // Move from bottom to center
              ),
              child: Opacity(
                opacity: _opacityAnimation.value,
                child: Center(
                  child: Container(
                    width: logoSize,
                    height: logoSize,
                    child: Image.asset(
                      // color: Color(0xFFFECA0A),
                      ic_log,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
