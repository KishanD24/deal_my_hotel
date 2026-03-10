import 'dart:convert';

import 'package:mobx/mobx.dart';

import '../../extensions/shared_pref.dart';
import '../../extensions/system_utils.dart';
import '../../models/user_response.dart';
import '../../utils/constants.dart';

part 'UserStore.g.dart';

class UserStore = UserStoreBase with _$UserStore;

abstract class UserStoreBase with Store {
  @observable
  bool isLoggedIn = false;

  @observable
  int userId = 0;

  @observable
  String email = '';

  @observable
  String password = '';

  @observable
  String fName = '';

  @observable
  String lName = '';

  @observable
  String profileImage = '';

  @observable
  String token = '';

  @observable
  String username = '';

  @observable
  String displayName = '';

  @observable
  String phoneNo = '';

  @observable
  String gender = '';

  @observable
  String age = '';

  @observable
  int isSubscribe = 0;

  @observable
  SubscriptionDetail? subscriptionDetail;

  @observable
  String termsCondition = '';

  @observable
  String currencySymbol = '';

  @observable
  String currencyCode = '';

  @observable
  String currencyPosition = '';

  @observable
  String oneSignalAppID = '';

  @observable
  String onesignalRestApiKey = '';

  @observable
  String admobBannerId = '';

  @observable
  String admobInterstitialId = '';

  @observable
  String admobBannerIdIos = '';

  @observable
  String admobInterstitialIdIos = '';

  @observable
  String chatGptApiKey = '';

  @observable
  String privacyPolicy = "";

  @observable
  String recentSearch = "";

  @observable
  String latitude = "";

  @observable
  String longitude = "";

  @observable
  String minPrice = "";

  @observable
  String maxPrice = "";

  @observable
  String cityName = "";

  @observable
  String subscription = "";

  @observable
  int contactInfo = 0;

  @observable
  int addLimitCount = 0;

  @observable
  int advertisement = 0;

  @observable
  int totalContactInfo = 0;

  @observable
  int totalAddLimitCount = 0;

  @observable
  int totalAdvertisement = 0;

  @observable
  String userPlayerId = "";

  @observable
  List<String> mRecentSearchList = ObservableList<String>();

  @observable
  UserResponse? userResponse;

  @action
  Future<void> setChatGptApiKey(String val, {bool isInitialization = false}) async {
    chatGptApiKey = val;
    if (!isInitialization) await setValue(ChatGptApiKey, val);
  }

  @action
  Future<void> setContactInfo(int val, {bool isInitialization = false}) async {
    contactInfo=0;
    contactInfo = val;
    if (!isInitialization) await setValue(CONTACT_INFO, val);
  }

  @action
  Future<void> setTotalContactInfo(int val, {bool isInitialization = false}) async {
    totalContactInfo = val;
    if (!isInitialization) await setValue(TOTAL_CONTACT_INFO, val);
  }

  @action
  Future<void> setAddLimitCount(int val, {bool isInitialization = false}) async {
    addLimitCount = val;
    if (!isInitialization) await setValue(ADD_PROPERTY, val);
  }

  @action
  Future<void> setTotalAddLimitCount(int val, {bool isInitialization = false}) async {
    totalAddLimitCount = val;
    if (!isInitialization) await setValue(TOTAL_ADD_PROPERTY, val);
  }

  @action
  Future<void> setTotalAdvertisement(int val, {bool isInitialization = false}) async {
    totalAdvertisement = val;
    if (!isInitialization) await setValue(TOTAL_ADVERTISEMENT, val);
  }

  @action
  Future<void> setAdvertisement(int val, {bool isInitialization = false}) async {
    advertisement = val;
    if (!isInitialization) await setValue(ADVERTISEMENT, val);
  }

  @action
  Future<void> setSubscription(String val, {bool isInitialization = false}) async {
    subscription = val;
    if (!isInitialization) await setValue(subscriptions, val);
  }

  @action
  Future<void> addToRecentSearchList(String data) async {
    mRecentSearchList.add(data);
  }

  @action
  Future<void> setMinPrice(String val, {bool isInitialization = false}) async {
    minPrice = val;
    if (!isInitialization) await setValue(MIN_PRICE, val);
  }

  @action
  Future<void> setMaxPrice(String val, {bool isInitialization = false}) async {
    maxPrice = val;
    if (!isInitialization) await setValue(MAX_PRICE, val);
  }

  @action
  Future<void> storeSearchData() async {
    if (mRecentSearchList.isNotEmpty) {
      await setValue(RECENT_SEARCH, jsonEncode(mRecentSearchList));
      log(getStringAsync(RECENT_SEARCH));
    } else {
      await setValue(RECENT_SEARCH, '');
    }
  }

  @action
  Future<void> clearSearchList(String item) async {
    mRecentSearchList.remove(item);
  }

  @action
  Future<void> setRecentSearch(String val, {bool isInitialization = false}) async {
    recentSearch = val;
    if (!isInitialization) await setValue(RECENT_SEARCH, val);
  }

  @action
  Future<void> setTermsCondition(String val, {bool isInitialization = false}) async {
    termsCondition = val;
    if (!isInitialization) await setValue(TermsCondition, val);
  }

  @action
  Future<void> setCurrencyCodeID(String val, {bool isInitialization = false}) async {
    currencySymbol = val;
    if (!isInitialization) await setValue(CurrencySymbol, val);
  }

  @action
  Future<void> setCurrencyCode(String val, {bool isInitialization = false}) async {
    currencyCode = val;
    if (!isInitialization) await setValue(CurrencyCode, val);
  }

  @action
  Future<void> setCurrencyPositionID(String val, {bool isInitialization = false}) async {
    currencyPosition = val;
    if (!isInitialization) await setValue(CurrencyPosition, val);
  }

  @action
  Future<void> setOneSignalAppID(String val, {bool isInitialization = false}) async {
    oneSignalAppID = val;
    if (!isInitialization) await setValue(OneSignalAppID, val);
  }

  @action
  Future<void> setOnesignalRestApiKey(String val, {bool isInitialization = false}) async {
    onesignalRestApiKey = val;
    if (!isInitialization) await setValue(OnesignalRestApiKey, val);
  }

  @action
  Future<void> setAdmobBannerId(String val, {bool isInitialization = false}) async {
    admobBannerId = val;
    if (!isInitialization) await setValue(AdmobBannerId, val);
  }

  @action
  Future<void> setAdmobInterstitialId(String val, {bool isInitialization = false}) async {
    admobInterstitialId = val;
    if (!isInitialization) await setValue(AdmobInterstitialId, val);
  }

  @action
  Future<void> setAdmobBannerIdIos(String val, {bool isInitialization = false}) async {
    admobBannerIdIos = val;
    if (!isInitialization) await setValue(AdmobBannerIdIos, val);
  }

  @action
  Future<void> setAdmobInterstitialIdIos(String val, {bool isInitialization = false}) async {
    admobInterstitialIdIos = val;
    if (!isInitialization) await setValue(AdmobInterstitialIdIos, val);
  }

  @action
  Future<void> setPrivacyPolicy(String val, {bool isInitialization = false}) async {
    privacyPolicy = val;
    if (!isInitialization) await setValue(PRIVACY_POLICY, val);
  }

  @action
  Future<void> setGender(String val, {bool isInitialization = false}) async {
    gender = val;
    if (!isInitialization) await setValue(GENDER, val);
  }

  @action
  Future<void> setPhoneNo(String val, {bool isInitialization = false}) async {
    phoneNo = val;
    if (!isInitialization) await setValue(PHONE_NUMBER, val);
  }

  @action
  Future<void> setDisplayName(String val, {bool isInitialization = false}) async {
    displayName = val;
    if (!isInitialization) await setValue(DISPLAY_NAME, val);
  }

  @action
  Future<void> setUsername(String val, {bool isInitialization = false}) async {
    username = val;
    if (!isInitialization) await setValue(USERNAME, val);
  }

  @action
  Future<void> setToken(String val, {bool isInitialization = false}) async {
    token = val;
    if (!isInitialization) await setValue(TOKEN, val);
  }

  @action
  Future<void> setUserImage(String val, {bool isInitialization = false}) async {
    profileImage = val;
    if (!isInitialization) await setValue(USER_PROFILE_IMG, val);
  }

  @action
  Future<void> setUserID(int val, {bool isInitialization = false}) async {
    userId = val;
    if (!isInitialization) await setValue(USER_ID, val);
  }

  @action
  Future<void> setLogin(bool val, {bool isInitializing = false}) async {
    isLoggedIn = val;
    if (!isInitializing) await setValue(IS_LOGIN, val);
  }

  @action
  Future<void> setFirstName(String val, {bool isInitialization = false}) async {
    fName = val;
    if (!isInitialization) await setValue(FIRSTNAME, val);
  }

  @action
  Future<void> setLastName(String val, {bool isInitialization = false}) async {
    lName = val;
    if (!isInitialization) await setValue(LASTNAME, val);
  }

  @action
  Future<void> setUserEmail(String val, {bool isInitialization = false}) async {
    email = val;
    if (!isInitialization) await setValue(EMAIL, val);
  }

  @action
  Future<void> setUserPassword(String val, {bool isInitialization = false}) async {
    password = val;
    if (!isInitialization) await setValue(PASSWORD, val);
  }

  @action
  Future<void> setSubscriptionDetail(SubscriptionDetail val, {bool isInitialization = false}) async {
    subscriptionDetail = val;
    if (!isInitialization) await setValue(SUBSCRIPTION_DETAIL, jsonEncode(val));
  }

  @action
  Future<void> setUserDetail(UserResponse val, {bool isInitialization = false}) async {
    userResponse = val;
    if (!isInitialization) await setValue(USER_DETAIL, jsonEncode(val));
  }

  @action
  Future<void> setSubscribe(int val, {bool isInitialization = false}) async {
    isSubscribe = val;
    if (!isInitialization) await setValue(IS_SUBSCRIBE, val);
  }

  @action
  Future<void> setUserLatitude(String val, {bool isInitialization = false}) async {
    latitude = val;
    if (!isInitialization) await setValue(LATITUDE, val);
  }

  @action
  Future<void> setUserLongitude(String val, {bool isInitialization = false}) async {
    longitude = val;
    if (!isInitialization) await setValue(LONGITUDE, val);
  }

  @action
  Future<void> setUserCity(String val, {bool isInitialization = false}) async {
    cityName = val;
    if (!isInitialization) await setValue(CITY, val);
  }

  @action
  Future<void> setUserPlayerId(String val, {bool isInitialization = false}) async {
    userPlayerId = val;
    if (!isInitialization) await setValue(PLAYER_ID, val);
  }

  @action
  Future<void> clearUserData() async {
    fName = '';
    lName = '';
    profileImage = '';
    token = '';
    username = '';
    displayName = '';
    phoneNo = '';
    gender = '';
    age = '';
  }
}
