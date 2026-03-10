import 'dart:async';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import '../extensions/extension_util/context_extensions.dart';
import '../extensions/extension_util/int_extensions.dart';
import '../extensions/extension_util/string_extensions.dart';
import '../extensions/extension_util/widget_extensions.dart';
import '../extensions/system_utils.dart';
import '../screens/notification_screen.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../components/adMob_component.dart';
import '../components/permission.dart';
import '../extensions/common.dart';
import '../extensions/decorations.dart';
import '../extensions/extension_util/device_extensions.dart';
import '../extensions/shared_pref.dart';
import '../extensions/text_styles.dart';
import '../main.dart';
import '../models/user_response.dart';
import '../network/RestApis.dart';
import '../screens/login_screen.dart';
import 'app_config.dart';
import 'colors.dart';
import 'constants.dart';
import 'images.dart';

Widget mSuffixTextFieldIconWidget(String? img) {
  return Image.asset(img.validate(), height: 20, width: 20, color: grayColor).paddingAll(14);
}

Future<void> getUSerDetail(BuildContext context, int? id) async {
  await getUserDataApi(id: id.validate()).then((value) async {
    userStore.setUserDetail(value);
    userStore.setFirstName(value.data!.firstName.validate());
    userStore.setUserEmail(value.data!.email.validate());
    userStore.setLastName(value.data!.lastName.validate());
    userStore.setUserID(value.data!.id.validate());
    userStore.setPhoneNo(value.data!.contactNumber.validate());
    userStore.setUsername(value.data!.username.validate());
    userStore.setDisplayName(value.data!.displayName.validate());
    userStore.setUserImage(value.data!.profileImage.validate());
    userStore.setSubscribe(value.subscriptionDetail!.isSubscribe.validate());
    userStore.setSubscriptionDetail(value.subscriptionDetail!);
    userStore.setAddLimitCount(value.data!.addLimitCount.validate());
    userStore.setContactInfo(value.data!.viewLimitCount.validate());
    userStore.setAdvertisement(value.data!.advertisementLimit.validate());
    setValue(CONTACT_INFO, value.data!.viewLimitCount.validate());
    setValue(ADVERTISEMENT, value.data!.advertisementLimit.validate());
    setValue(ADD_PROPERTY, value.data!.addLimitCount.validate());

    if (value.subscriptionDetail != null) {
      userStore.setTotalAdvertisement(value.subscriptionDetail!.subscriptionPlan!.packageData!.advertisementLimit.validate());
      userStore.setTotalContactInfo(value.subscriptionDetail!.subscriptionPlan!.packageData!.propertyLimit.validate());
      userStore.setTotalAddLimitCount(value.subscriptionDetail!.subscriptionPlan!.packageData!.addPropertyLimit.validate());
      setValue(TOTAL_ADD_PROPERTY, value.subscriptionDetail!.subscriptionPlan!.packageData!.addPropertyLimit.validate());
      setValue(TOTAL_ADVERTISEMENT, value.subscriptionDetail!.subscriptionPlan!.packageData!.advertisementLimit.validate());
      setValue(TOTAL_CONTACT_INFO, value.subscriptionDetail!.subscriptionPlan!.packageData!.propertyLimit.validate());
    }

    appStore.setLoading(false);
  }).catchError((e) {
    print("ERROR USER DETAIL" + e.toString());
    appStore.setLoading(false);
  });
}

Widget cachedImage(String? url, {double? height, Color? color, double? width, BoxFit? fit, AlignmentGeometry? alignment, bool usePlaceholderIfUrlEmpty = true, double? radius}) {
  if (url.validate().isEmpty) {
    return placeHolderWidget(height: height, width: width, fit: fit, alignment: alignment, radius: radius);
  } else if (url.validate().startsWith('http')) {
    return CachedNetworkImage(
      imageUrl: url!,
      height: height,
      width: width,
      fit: fit,
      color: color,
      alignment: alignment as Alignment? ?? Alignment.center,
      progressIndicatorBuilder: (context, url, progress) {
        return placeHolderWidget(height: height, width: width, fit: fit, alignment: alignment, radius: radius);
      },
      errorWidget: (_, s, d) {
        return placeHolderWidget(height: height, width: width, fit: fit, alignment: alignment, radius: radius);
      },
    );
  } else {
    return Image.asset(ic_placeholder, height: height, width: width, fit: BoxFit.cover, alignment: alignment ?? Alignment.center).cornerRadiusWithClipRRect(radius ?? defaultRadius);
  }
}

Widget commonCacheImageWidget(String? url, {double? width, BoxFit? fit, double? height}) {
  if (url.toString().startsWith('http')) {
    if (isMobile) {
      return CachedNetworkImage(
        placeholder: placeholderWidgetFn() as Widget Function(BuildContext, String)?,
        imageUrl: '$url',
        height: height,
        width: width,
        fit: fit,
      );
    } else {
      return Image.network(url!, height: height, width: width, fit: fit);
    }
  } else {
    return Image.asset(ic_placeholder, height: height, width: width, fit: fit);
  }
}

Function(BuildContext, String) placeholderWidgetFn() => (_, s) => placeHolderWidget();

Widget placeHolderWidget({double? height, double? width, BoxFit? fit, AlignmentGeometry? alignment, double? radius}) {
  return Image.asset(ic_placeholder, height: height, width: width, fit: BoxFit.cover, alignment: alignment ?? Alignment.center).cornerRadiusWithClipRRect(radius ?? defaultRadius);
}

void showInterstitialAds() {
  if (userStore.isSubscribe == 0) {
    adShow();
  }
}

void loadInterstitialAds() {
  if (userStore.isSubscribe == 0) {
    createInterstitialAd();
  }
}

Future<T?> launchScreen<T>(BuildContext context, Widget child, {bool isNewTask = false, PageRouteAnimation? pageRouteAnimation, Duration? duration}) async {
  if (isNewTask) {
    return await Navigator.of(context).pushAndRemoveUntil(
      buildPageRoute(child, pageRouteAnimation, duration),
          (route) => false,
    );
  } else {
    return await Navigator.of(context).push(
      buildPageRoute(child, pageRouteAnimation, duration),
    );
  }
}

void oneSignalData() async {
  OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
  OneSignal.Debug.setAlertLevel(OSLogLevel.none);
  OneSignal.consentRequired(false);
  OneSignal.initialize(mOneSignalID);
  final permission = await OneSignal.Notifications.permissionNative();
  print("Permission $permission");

  Permissions.notificationPermissions();
  OneSignal.Notifications.requestPermission(true).then((value) {
    print("Accepted permission: $value");
  });


  saveOneSignalPlayerId();
  OneSignal.Notifications.addClickListener((notification) async {
    var notId = notification.notification.additionalData!["id"];
    if (notId != null) {
      if (!appStore.isLoggedIn) {
        LoginScreen().launch(getContext);
      } else {
        NotificationScreen().launch(getContext);
      }
    }
  });
  // if (userStore.isLoggedIn) {
  //   updatePlayerId();
  // }
}

Future<void> saveOneSignalPlayerId() async {
  print("BEFORE saveOneSignalPlayerId Function ===========" + OneSignal.User.pushSubscription.optedIn.toString());
  print("BEFORE saveOneSignalPlayerId Function =========" + OneSignal.User.pushSubscription.id.toString());
  print("BEFORE saveOneSignalPlayerId Function =========" + OneSignal.User.pushSubscription.token.toString());
  OneSignal.User.pushSubscription.addObserver((state) async {
    // OneSignal.User.pushSubscription.optIn();

    print("AFTER saveOneSignalPlayerId Function ===========" + OneSignal.User.pushSubscription.optedIn.toString());
    print("AFTER saveOneSignalPlayerId Function =========" + OneSignal.User.pushSubscription.id.toString());
    print("AFTER saveOneSignalPlayerId Function =========" + OneSignal.User.pushSubscription.token.toString());
    await setValue(PLAYER_ID, OneSignal.User.pushSubscription.id);
    print("PLAYER ID IS ++>" + getStringAsync(PLAYER_ID).validate());
    // updatePlayerId();
  });
}

Future<void> getSettingData() async {
  await getDashBoardData({"latitude": userStore.latitude, "longitude": userStore.longitude, "city": userStore.cityName}).then((value) {
    setValue(SITE_NAME, value.appSetting!.siteName.validate());
    setValue(SITE_EMAIL, value.appSetting!.siteEmail.validate());
    setValue(SITE_LOGO, value.appSetting!.siteLogo.validate());
    setValue(SITE_FAVICON, value.appSetting!.siteFavicon.validate());
    setValue(SITE_DESCRIPTION, value.appSetting!.siteDescription.validate());
    setValue(SITE_COPYRIGHT, value.appSetting!.siteCopyright.validate());
    setValue(FACEBOOK_URL, value.appSetting!.facebookUrl.validate());
    setValue(INSTAGRAM_URL, value.appSetting!.instagramUrl.validate());
    setValue(TWITTER_URL, value.appSetting!.twitterUrl.validate());
    setValue(LINKED_URL, value.appSetting!.linkedinUrl.validate());
    setValue(CONTACT_EMAIL, value.appSetting!.contactEmail.validate());
    setValue(CONTACT_NUMBER, value.appSetting!.contactNumber.validate());
    setValue(HELP_SUPPORT_URL, value.appSetting!.helpSupportUrl.validate());
    setValue(PRIVACY_POLICY, value.appSetting!.helpSupportUrl.validate());
    setValue(TERMS_CONDITIONS, value.appSetting!.helpSupportUrl.validate());
    setValue(SUBSCRIPTION, value.appSetting!.subscription.validate());
  });
}

String parseDocumentDate(DateTime dateTime, {bool includeTime = false}) {
  if (includeTime) {
    return DateFormat('dd MMM, yyyy hh:mm a').format(dateTime);
  } else {
    return DateFormat('dd MMM, yyyy').format(dateTime);
  }
}

String formatDateString(String dateString) {
  DateTime dateTime = DateTime.parse(dateString);

  return dateTime.minute.toString();
}

String formatNumberString(num priceValue) {
  String formattedPrice = NumberFormat('#,##,##0').format(priceValue);

  return formattedPrice;
}

String formatFilterNumberString(double priceValue) {
  String formattedPrice = NumberFormat('#,##,##0').format(priceValue);

  return formattedPrice;
}

setLogInValue() {
  userStore.setLogin(getBoolAsync(IS_LOGIN));
  if (userStore.isLoggedIn) {
    userStore.setToken(getStringAsync(TOKEN));
    userStore.setUserID(getIntAsync(USER_ID));
    userStore.setUserEmail(getStringAsync(EMAIL));
    userStore.setFirstName(getStringAsync(FIRSTNAME));
    userStore.setLastName(getStringAsync(LASTNAME));
    userStore.setUserPassword(getStringAsync(PASSWORD));
    userStore.setUserImage(getStringAsync(USER_PROFILE_IMG));
    userStore.setPhoneNo(getStringAsync(PHONE_NUMBER));
    userStore.setDisplayName(getStringAsync(DISPLAY_NAME));
    userStore.setGender(getStringAsync(GENDER));
    userStore.setContactInfo(getIntAsync(CONTACT_INFO));
    userStore.setAdvertisement(getIntAsync(ADVERTISEMENT));
    userStore.setAddLimitCount(getIntAsync(ADD_PROPERTY));
    UserResponse? userDetail = UserResponse.fromJson(jsonDecode(getStringAsync(USER_DETAIL)));

    userStore.setUserDetail(userDetail);
    if (!getStringAsync(SUBSCRIPTION_DETAIL).isEmptyOrNull) {
      SubscriptionDetail? subscriptionDetail = SubscriptionDetail.fromJson(jsonDecode(getStringAsync(SUBSCRIPTION_DETAIL)));
      userStore.setSubscribe(getIntAsync(IS_SUBSCRIBE));
      userStore.setSubscriptionDetail(subscriptionDetail);
      userStore.setTotalAddLimitCount(getIntAsync(TOTAL_ADD_PROPERTY));
      userStore.setTotalContactInfo(getIntAsync(TOTAL_CONTACT_INFO));
      userStore.setTotalAdvertisement(getIntAsync(TOTAL_ADVERTISEMENT));
    }
  }
}

Future<void> commonLaunchUrl(String url, {bool forceWebView = false}) async {
  log(url);
  await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication).then((value) {}).catchError((e) {
    toast(language.individual + ' $url');
  });
}

Future<bool> checkPermission() async {
  LocationPermission locationPermission = await Geolocator.requestPermission();

  if (locationPermission == LocationPermission.whileInUse || locationPermission == LocationPermission.always) {
    if (!await Geolocator.isLocationServiceEnabled()) {
      return await Geolocator.openLocationSettings().then((value) => false).catchError((e) => false);
    } else {
      return true;
    }
  } else {
    toast(language.allowLocationPermission);
    await Geolocator.openAppSettings();

    return false;
  }
}

Future<void> launchUrls(String url, {bool forceWebView = false}) async {
  log(url);
  if (!await launchUrl(
    Uri.parse(url),
    // mode: LaunchMode.inAppWebView,
    // webViewConfiguration: const WebViewConfiguration(enableDomStorage: false),
  )) {
    throw 'Could not launch $url';
  }
  // await launchUrl(Uri.parse(url),mode: LaunchMode.inAppWebView,webViewConfiguration: WebViewConfiguration()).catchError((e) {
  //   log(e);
  //   toast('Invalid URL: $url');
  // });
}

class DateDifferenceWidget extends StatelessWidget {
  final DateTime startDate;
  final DateTime endDate;

  DateDifferenceWidget({required this.startDate, required this.endDate});

  @override
  Widget build(BuildContext context) {
    Duration difference = endDate.difference(startDate);

    if (difference.inSeconds.abs() < 60) {
      return Text("${difference.inSeconds.abs()} seconds ago", style: secondaryTextStyle(size: 12));
    } else if (difference.inMinutes.abs() < 60) {
      return Text("${difference.inMinutes.abs()} minutes ago ", style: secondaryTextStyle(size: 12));
    } else if (difference.inHours.abs() < 24) {
      return Text("${difference.inHours.abs()} hours ago", style: secondaryTextStyle(size: 12));
    } else if (difference.inDays.abs() < 30) {
      return Text("${difference.inDays.abs()} days ago ", style: secondaryTextStyle(size: 12));
    } else if ((difference.inDays.abs() ~/ 30) < 12) {
      return Text("${difference.inDays.abs() ~/ 30} months ago ", style: secondaryTextStyle(size: 12));
    } else {
      return Text("${difference.inDays.abs() ~/ 365} years ago ", style: secondaryTextStyle(size: 12));
    }
  }
}

String getYoutubeThumbnail(String url) {
  String thumbnail = '';
  String? videoId = YoutubePlayer.convertUrlToId(url);
  thumbnail = "https://img.youtube.com/vi/$videoId/maxresdefault.jpg";
  return thumbnail;
}

Widget fevIconWidget(int? isFavourite, BuildContext context, {Color? color, double? padding}) {
  return Container(
    padding: EdgeInsets.all(padding ?? 4),
    decoration: boxDecorationWithRoundedCorners(borderRadius: BorderRadius.circular(50), backgroundColor: color ?? context.cardColor),
    child: Image.asset(isFavourite == 1 ? ic_favorite_fill : ic_favorite, color: primaryColor, height: 20, width: 20),
  );
}

Widget backButtonWidget(BuildContext context, {Function()? onTap}) {
  return InkWell(
    onTap: onTap ??
        () {
          finish(context);
        },
    child: Container(
        alignment: Alignment.center,
        decoration: boxDecorationDefault(shape: BoxShape.circle, color: context.cardColor),
        child: Icon(appStore.selectedLanguage != 'ar' ? MaterialIcons.keyboard_arrow_left : MaterialIcons.keyboard_arrow_right, size: 30, color: primaryColor)),
  );
}

String durationWidget(String? duration) {
  String icon = 'assets/icons/ic_product.png';
  switch (duration.validate().toLowerCase()) {
    case "monthly":
      return 'month';
    case "daily":
      return 'day';
    case "quarterly":
      return '6 month';
    case "yearly":
      return 'year';
  }
  return icon;
}
