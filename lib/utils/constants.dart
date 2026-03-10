import 'package:flutter/material.dart';
import 'package:mighty_properties/main.dart';
import '../extensions/extension_util/int_extensions.dart';
import '../extensions/colors.dart';
import '../extensions/common.dart';

const USER_COLLECTION = "users";

const CURRENCY_CODE = "";
const LANGUAGE = "LANGUAGE";

const USER_CONTACT_NUMBER = 'USER_CONTACT_NUMBER';
const OTP_VERIFIED = "OTP_VERIFIED";

const ACTIVE = "active";
const INACTIVE = "inactive";
const CANCELLED = "cancel";
const EXPIRED = "expired ";

const PROPERTY_ACTIVE = "1";
const PROPERTY_INACTIVE = "0";
const PREMIUM_PROPERTY = "0";

final int forRent = 0;
final int forSell = 1;
final int pg = 2;

// SharedReference keys
const IS_LOGGED_IN = 'IS_LOGIN';
const IS_FIRST_TIME = 'IS_FIRST_TIME';
const UID = 'UID';

const IS_USER_SIGNUP = 'IS_USER_SIGNUP';

const USER_ID = 'USER_ID';
const FIREBASE_USER_ID = 'FIREBASE_USER_ID';

const NAME = 'NAME';

const STATUS = 'USER_TOKEN';

const LATITUDE = 'LATITUDE';
const LONGITUDE = 'LONGITUDE';
const CITY = "CITY";

const YOUTUBE = 'yout';

//subscription
const SUBSCRIPTION_DETAIL = 'SUBSCRIPTION_DETAIL';
const USER_DETAIL = 'USER_DETAIL';
const NOTIFICATION_DETAIL = 'NOTIFICATION_DETAIL';
const IS_SUBSCRIBE = 'IS_SUBSCRIBE';

//profile
const ADD_PROPERTY = "ADD_PROPERTY";
const TOTAL_ADD_PROPERTY = "TOTAL_ADD_PROPERTY";
const ADVERTISEMENT = "ADVERTISEMENT";
const TOTAL_ADVERTISEMENT = "TOTAL_ADVERTISEMENT";
const CONTACT_INFO = "CONTACT_INFO";
const TOTAL_CONTACT_INFO = "TOTAL_CONTACT_INFO";

const USER_PROFILE_PHOTO = 'USER_PROFILE_PHOTO';
const USER_TYPE = 'USER_TYPE';
const USER_NAME = 'USER_NAME';
const USER_EMAIL = 'USER_EMAIL';
const USER_PASSWORD = 'USER_PASSWORD';
const USER_ADDRESS = 'USER_ADDRESS';

const PER_PAGE = 100;

const LoginTypeOTP = 'mobile';
const LoginUser = 'user';
const MALE = 'male';
const FEMALE = 'female';
const PLAYER_ID = 'PLAYER_ID';
const IS_OTP = "IS_OTP";
const IS_REMEMBER = 'IS_REMEMBER';

const COUNTRY_CODE = 'COUNTRY_CODE';
const FONT_SIZE_PREF = 'FONT_SIZE_PREF';

const subscriptions = "subscription_system";
const TermsCondition = "termsCondition";
const CurrencySymbol = "currencySymbol";
const CurrencyCode = "currencyCode";
const CurrencyPosition = "currencyPosition";
const OneSignalAppID = "oneSignalAppID";
const OnesignalRestApiKey = "onesignalRestApiKey";
const AdmobBannerId = "admobBannerId";
const AdmobInterstitialId = "admobInterstitialId";
const AdmobBannerIdIos = "admobBannerIdIos";
const AdmobInterstitialIdIos = "admobInterstitialIdIos";
const ChatGptApiKey = "chatGptApiKey";
const PrivacyPolicy = "privacyPolicy";
const FIRSTNAME = "FIRSTNAME";
const LASTNAME = "LASTNAME";
const EMAIL = "EMAIL";
const IS_LOGIN = "IS_LOGIN";
const GENDER = "GENDER";
const DISPLAY_NAME = "DISPLAY_NAME";
const PHONE_NUMBER = "PHONE_NUMBER";
const TOKEN = "TOKEN";
const USERNAME = "USERNAME";
const USER_PROFILE_IMG = "USER_PROFILE_IMG";
const PASSWORD = "PASSWORD";
const IS_SUBSCRIPTION_SYSTEM = "IS_SUBSCRIPTION_SYSTEM";
const GOOGLE_API_KEY = "AIzaSyARQ64ZYsvHaOQdm_mf6z4x9-Sbbc8PN0U";

//region amenityType
const AMENITY_TYPE_TEXTAREA = 'textarea';
const AMENITY_TYPE_RADIO_BUTTON = 'rediobutton';
const AMENITY_TYPE_TEXT_BOX = 'textbox';
const AMENITY_TYPE_CHECKBOX = 'checkbox';
const AMENITY_TYPE_DROPDOWN = 'dropdown';
const AMENITY_TYPE_NUMBER = 'number';
//endregion

//region duration
const DURATION_DAILY = 'Daily';
const DURATION_MONTHLY = 'Monthly';
const DURATION_QUARTERLY = 'Quarterly';
const DURATION_YEARLY = 'Yearly';

//endregion

class AppThemeMode {
  final int themeModeLight = 0;
  final int themeModeDark = 1;
  final int themeModeSystem = 2;
}

/* Theme Mode Type */
const ThemeModeLight = 0;
const ThemeModeDark = 1;
const ThemeModeSystem = 2;

class DefaultValues {
  final String defaultLanguage = "en";
}

DefaultValues defaultValues = DefaultValues();
int defaultElevation = 4;
double defaultRadius = 12.0;
double defaultBlurRadius = 4.0;
double defaultSpreadRadius = 0.5;
double defaultAppBarElevation = 1.0;

double tabletBreakpointGlobal = 600.0;
double desktopBreakpointGlobal = 720.0;

Color? defaultInkWellSplashColor;
Color? defaultInkWellHoverColor;
Color? defaultInkWellHighlightColor;
double? defaultInkWellRadius;
Color defaultLoaderBgColorGlobal = Colors.white;
Color? defaultLoaderAccentColorGlobal;

Color textPrimaryColorGlobal = textPrimaryColor;
Color textSecondaryColorGlobal = textSecondaryColor;
double textBoldSizeGlobal = 16;
double textPrimarySizeGlobal = 16;
double textSecondarySizeGlobal = 14;
String? fontFamilyBoldGlobal;
String? fontFamilyPrimaryGlobal;
String? fontFamilySecondaryGlobal;
FontWeight fontWeightBoldGlobal = FontWeight.bold;
FontWeight fontWeightPrimaryGlobal = FontWeight.normal;
FontWeight fontWeightSecondaryGlobal = FontWeight.normal;
bool enableAppButtonScaleAnimationGlobal = true;
bool forceEnableDebug = false;

int? appButtonScaleAnimationDurationGlobal;
ShapeBorder? defaultAppButtonShapeBorder;

double defaultAppButtonRadius = 10.0;
double defaultAppButtonElevation = 4.0;
PageRouteAnimation? pageRouteAnimationGlobal;
Duration pageRouteTransitionDurationGlobal = 400.milliseconds;

int passwordLengthGlobal = 6;

var errorSomethingWentWrong = language.somethingWentWrong;
var errorThisFieldRequired = language.thisFieldIsRequired;
var errorInternetNotAvailable = language.noInternet;
var errorNotAllow = language.errorNotAllow;

const playStoreBaseURL = 'https://play.google.com/store/apps/details?id=';
const appStoreBaseURL = 'https://apps.apple.com/in/app/';

const THEME_MODE_INDEX = 'theme_mode_index';

var errorMessage = 'Please try again';

var customDialogHeight = 140.0;
var customDialogWidth = 220.0;

const MAIL_TO_PREFIX = 'mailto:';
const TEL_PREFIX = 'tel:';

const facebookBaseURL = 'https://www.facebook.com/';
const instagramBaseURL = 'https://www.instagram.com/';
const linkedinBaseURL = 'https://www.linkedin.com/in/';
const twitterBaseURL = 'https://twitter.com/';
const youtubeBaseURL = 'https://www.youtube.com/';
const redditBaseURL = 'https://reddit.com/r/';
const telegramBaseURL = 'https://t.me/';
const facebookMessengerURL = 'https://m.me/';
const whatsappURL = 'https://wa.me/';
const googleDriveURL = 'https://docs.google.com/viewer?url=';

const spacingControlHalf = 2;
const spacingControl = 4;
const spacingStandard = 8;
const spacingStandardNew = 16;
const spacingMedium = 20;
const spacingLarge = 26;
const spacingXL = 30;
const spacingXXL = 34;

const RECENT_SEARCH = "RECENT_SEARCH";

const MIN_PRICE = "MIN_PRICE";
const MAX_PRICE = "MAX_PRICE";

const SITE_NAME = "SITE_NAME";
const SITE_EMAIL = "SITE_EMAIL";
const SITE_DESCRIPTION = "SITE_DESCRIPTION";
const SITE_COPYRIGHT = "SITE_COPYRIGHT";
const FACEBOOK_URL = "FACEBOOK_URL";
const INSTAGRAM_URL = "INSTAGRAM_URL";
const TWITTER_URL = "TWITTER_URL";
const LINKED_URL = "LINKED_URL";
const CONTACT_EMAIL = "CONTACT_EMAIL";
const HELP_SUPPORT = "HELP_SUPPORT";
const CONTACT_NUMBER = "CONTACT_NUMBER";
const HELP_SUPPORT_URL = "HELP_SUPPORT_URL";
const TERMS_CONDITIONS = "TERMS_CONDITIONS";
const PRIVACY_POLICY = "PRIVACY_POLICY";
const SITE_LOGO = "SITE_LOGO";
const SITE_FAVICON = "SITE_FAVICON";
const SUBSCRIPTION = "SUBSCRIPTION";

const PAYMENT_TYPE_STRIPE = 'stripe';
const PAYMENT_TYPE_RAZORPAY = 'razorpay';
const PAYMENT_TYPE_PAYSTACK = 'paystack';
const PAYMENT_TYPE_FLUTTERWAVE = 'flutterwave';
const PAYMENT_TYPE_PAYPAL = 'paypal';
const PAYMENT_TYPE_PAYTABS = 'paytabs';
const PAYMENT_TYPE_PAYTM = 'paytm';
const PAYMENT_TYPE_MYFATOORAH = 'myfatoorah';
const PAYMENT_TYPE_ORANGE_MONEY = 'orangeMoney';
const PAYMENT = 'PAYMENT';

const stripeURL = 'https://api.stripe.com/v1/payment_intents';

const isDarkModeOnPref = 'isDarkModeOnPref';
ShapeBorder? defaultDialogShape;

// const UNFURNISHED = "Unfurnished";
// const FULLY = "Fully Furnished";
// const SEMI = "Semi Furnished";

final UNFURNISHED = language.unfurnished;
final FULLY = language.fullyFurnished;
final SEMI = language.semiFurnished;

// const OWNER = "Owner";
// const BROKER = "Broker";
// const BUILDER = "Builder";
// const AGENT = "Agent";

final OWNER = language.owner;
final BROKER = language.broker;
final BUILDER = language.builder;
final AGENT = language.agent;

///PropertyFor
enum PropertyForIndex {
  RENT,
  SELL,
  PG_CO_LIVING,
}

extension PropertyForExtension on PropertyForIndex {
  int? get propertyForIndex {
    switch (this) {
      case PropertyForIndex.RENT:
        return 0;
      case PropertyForIndex.SELL:
        return 1;
      case PropertyForIndex.PG_CO_LIVING:
        return 2;
      default:
        return null;
    }
  }
}

///SellerType
enum SellerType {
  OWNER,
  BROKER,
  BUILDER,
}

extension SellerTypeExtension on SellerType {
  int? get sellerTypeIndex {
    switch (this) {
      case SellerType.OWNER:
        return 0;
      case SellerType.BROKER:
        return 1;
      case SellerType.BUILDER:
        return 2;
      default:
        return null;
    }
  }
}

///FurnishedType
enum FurnishedType {
  UNFURNISHED,
  FULLY,
  SEMI,
}

extension FurnishedTypeExtension on FurnishedType {
  int? get furnishedTypeIndex {
    switch (this) {
      case FurnishedType.UNFURNISHED:
        return 0;
      case FurnishedType.FULLY:
        return 1;
      case FurnishedType.SEMI:
        return 2;
      default:
        return null;
    }
  }
}

extension FurnishedTypeStringExtension on FurnishedType {
  String? get furnishedTypeStringIndex {
    switch (this) {
      case FurnishedType.UNFURNISHED:
        return UNFURNISHED;
      case FurnishedType.FULLY:
        return FULLY;
      case FurnishedType.SEMI:
        return SEMI;
      default:
        return null;
    }
  }
}
