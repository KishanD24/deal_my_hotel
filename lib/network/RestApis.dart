import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import '../extensions/extension_util/widget_extensions.dart';
import '../extensions/system_utils.dart';
import '../languageConfiguration/ServerLanguageResponse.dart';
import '../models/property_list_model.dart';
import '../extensions/extension_util/int_extensions.dart';
import '../extensions/extension_util/string_extensions.dart';
import '../extensions/shared_pref.dart';
import '../main.dart';
import '../models/app_setting_response.dart';
import '../models/article_response.dart';
import '../models/base_response.dart';
import '../models/category_list_model.dart';
import '../models/contact_info_detail_response.dart';
import '../models/dashBoard_response.dart';
import '../models/favourite_property_model.dart';
import '../models/filter_model.dart';
import '../models/get_setting_response.dart';
import '../models/limit_property_response.dart';
import '../models/login_Response.dart';
import '../models/my_advertisement_property_response.dart';
import '../models/my_properties_model.dart';
import '../models/notification_model.dart';
import '../models/otp_login_response.dart';
import '../models/payment_list_model.dart';
import '../models/property_contact_info_response.dart';
import '../models/property_details_model.dart';
import '../models/property_inquiry_response.dart';
import '../models/property_type_model.dart';
import '../models/purchase_extra_limit_response.dart';
import '../models/search_response_model.dart';
import '../models/signUp_resonse.dart';
import '../models/subscribe_package_reponse.dart';
import '../models/subscription_model.dart';
import '../models/subscription_plan_response.dart';
import '../models/user_response.dart';
import '../models/view_property_response.dart';
import '../screens/login_screen.dart';
import '../utils/constants.dart';
import 'network_utills.dart';

Future<SignUpResponse> signUpApi(Map request, BuildContext context) async {
  Response response = await buildHttpResponse('register',
      request: request, method: HttpMethod.POST);
  if (!response.statusCode.isSuccessful()) {
    await appStore.setLogin(true);
    await setValue(IS_USER_SIGNUP, true);
    if (response.body.isJson()) {
      var json = jsonDecode(response.body);
      if (json.containsKey('code') &&
          json['code'].toString().contains('invalid_username')) {
        await appStore.setLogin(false);

        throw 'invalid_username';
      }
    }
  }

  return await handleResponse(response).then((json) async {
    var signupResponse = SignUpResponse.fromJson(json);
    // if (signupResponse.data!.apiToken.validate().isNotEmpty) await userStore.setToken(signupResponse.data!.apiToken.validate());
    await setValue(USER_ID, signupResponse.data!.id);
    await setValue(FIRSTNAME, signupResponse.data!.firstName.validate());
    await setValue(LASTNAME, signupResponse.data!.lastName.validate());
    await setValue(EMAIL, signupResponse.data!.email.validate());
    await setValue(TOKEN, signupResponse.data!.apiToken.validate());
    await setValue(USER_TYPE, signupResponse.data!.userType.validate());
    await appStore.setLogin(true);

    return signupResponse;
  }).catchError((e) {
    log(e.toString());
    throw e.toString();
  });
}

Future<SocialLoginResponse> otpLogInApi(Map request) async {
  Response response = await buildHttpResponse('social-otp-login',
      request: request, method: HttpMethod.POST);
  if (!(response.statusCode >= 200 && response.statusCode <= 206)) {
    if (response.body.isJson()) {
      var json = jsonDecode(response.body);
      if (json.containsKey('code') &&
          json['code'].toString().contains('invalid_username')) {
        throw 'invalid_username';
      }
    }
  }

  return await handleResponse(response).then((json) async {
    SocialLoginResponse loginResponse = SocialLoginResponse.fromJson(json);

    // saveUserData(loginResponse.data!);
    // await appStore.setLogin(true);
    return loginResponse;
  }).catchError((e) {
    throw e.toString();
  });
}

///property type list
Future<PropertyTypeResponse> getPropertyTypeList() async {
  return PropertyTypeResponse.fromJson(await handleResponse(
          await buildHttpResponse('property-type-list', method: HttpMethod.GET))
      .then((value) => value));
}

/// Language Data
Future<ServerLanguageResponse> getLanguageList(versionNo) async {
  return ServerLanguageResponse.fromJson(await handleResponse(
          await buildHttpResponse('language-table-list?version_no=$versionNo',
              method: HttpMethod.GET))
      .then((value) => value));
}

Future<LogInResponse> updateProfileApi(Map req) async {
  return LogInResponse.fromJson(await handleResponse(await buildHttpResponse(
      'update-profile',
      request: req,
      method: HttpMethod.POST)));
}

// Future<LogInResponse> updatePlayerIdApi(Map req) async {
//   return LogInResponse.fromJson(await handleResponse(await buildHttpResponse('update-user-status', request: req, method: HttpMethod.POST)));
// }

Future<DashboardResponse> getDashBoardData(Map request) async {
  return DashboardResponse.fromJson(await handleResponse(
          await buildHttpResponse('dashboard-list',
              request: request, method: HttpMethod.POST))
      .then((value) => value));
}

Future<ViewPropertyResponse> getPropertiesView(int id) async {
  return ViewPropertyResponse.fromJson(await handleResponse(
          await buildHttpResponse('property-view?id=$id',
              method: HttpMethod.POST))
      .then((value) => value));
}

Future<FilterResponse> filterApi(Map request, {int? page}) async {
  return FilterResponse.fromJson(await handleResponse(await buildHttpResponse(
          'filter-property-list?page=$page',
          request: request,
          method: HttpMethod.POST))
      .then((value) => value));
}

/// Category Api
Future<CategoryListModel> getCategory({int? page = 1}) async {
  return CategoryListModel.fromJson(await handleResponse(
          await buildHttpResponse('category-list?page=$page',
              method: HttpMethod.GET))
      .then((value) => value));
}

/// PropertyList Api
Future<PropertyListModel> getProperty() async {
  return PropertyListModel.fromJson(await handleResponse(
          await buildHttpResponse('property-list', method: HttpMethod.GET))
      .then((value) => value));
}

/// property detail
Future<PropertyDetailsModel> propertyDetails(Map request) async {
  return PropertyDetailsModel.fromJson(await handleResponse(
          await buildHttpResponse('property-detail',
              request: request, method: HttpMethod.POST))
      .then((value) => value));
}

///Search Api
Future<SearchResponse> searchProperty(Map request, {int? page}) async {
  return SearchResponse.fromJson(await handleResponse(await buildHttpResponse(
          'search-location?per_page=$page',
          request: request,
          method: HttpMethod.POST))
      .then((value) => value));
}

///article
Future<ArticleResponse> getArticles({int? id, int? page}) async {
  return ArticleResponse.fromJson(await (handleResponse(await buildHttpResponse(
      "article-list?tags_id=$id&page=$page",
      method: HttpMethod.GET))));
}

/// subscription
Future<SubscribePackageResponse> subscribePackageApi(Map req) async {
  return SubscribePackageResponse.fromJson(await handleResponse(
      await buildHttpResponse('subscribe-package',
          request: req, method: HttpMethod.POST)));
}

Future<SubscriptionResponse> getSubscription() async {
  return SubscriptionResponse.fromJson(await (handleResponse(
      await buildHttpResponse("package-list", method: HttpMethod.GET))));
}

Future<SubscriptionPlanResponse> getSubscriptionPlanList({int page = 2}) async {
  return SubscriptionPlanResponse.fromJson(await (handleResponse(
      await buildHttpResponse("subscriptionplan-list?page=$page",
          method: HttpMethod.GET))));
}

Future<SubscribePackageResponse> cancelPlanApi(Map req) async {
  return SubscribePackageResponse.fromJson(await handleResponse(
      await buildHttpResponse('cancel-subscription',
          request: req, method: HttpMethod.POST)));
}

/// payment
Future<PaymentListModel> getPaymentApi() async {
  return PaymentListModel.fromJson(await handleResponse(
      await buildHttpResponse('payment-gateway-list', method: HttpMethod.GET)));
}

/// Favourite Property Api
Future<FavouritePropertyModel> getFavouriteProperty(int page) async {
  return FavouritePropertyModel.fromJson(await (handleResponse(
      await buildHttpResponse("get-favourite-property?page=$page",
          method: HttpMethod.GET))));
}

/// Set Favourite Property
Future<EPropertyBaseResponse> setFavouriteProperty(Map request) async {
  return EPropertyBaseResponse.fromJson(await (handleResponse(
      await buildHttpResponse("set-favourite-property",
          request: request, method: HttpMethod.POST))));
}

///User Detail
Future<UserResponse> getUserDataApi({int? id}) async {
  return UserResponse.fromJson(await (handleResponse(
      await buildHttpResponse("user-detail?id=$id", method: HttpMethod.GET))));
}

///get AppSetting
Future<AppSettingResponse> getAppSettingApi() async {
  return AppSettingResponse.fromJson(await handleResponse(
      await buildHttpResponse('appsetting', method: HttpMethod.GET)));
}

///get setting
Future<GetSettingResponse> getSettingApi() async {
  return GetSettingResponse.fromJson(await handleResponse(
      await buildHttpResponse('get-setting', method: HttpMethod.GET)));
}

///Notification
Future<NotificationResponse> notificationDetailsApi(String? id) async {
  return NotificationResponse.fromJson(await handleResponse(
      await buildHttpResponse('notification-detail?id=$id',
          method: HttpMethod.GET)));
}

Future<NotificationResponse> notificationListApi(Map request) async {
  return NotificationResponse.fromJson(await handleResponse(
      await buildHttpResponse('notification-list',
          request: request, method: HttpMethod.POST)));
}

/// Property Add

Future<EPropertyBaseResponse> addProperty(Map request) async {
  return EPropertyBaseResponse.fromJson(await handleResponse(
      await buildHttpResponse('property-save',
          request: request, method: HttpMethod.POST)));
}

///Delete User
Future<EPropertyBaseResponse> deleteUserAccountApi() async {
  return EPropertyBaseResponse.fromJson(await handleResponse(
      await buildHttpResponse('delete-user-account', method: HttpMethod.POST)));
}

///My Properties
Future<MyPropertiesResponseModel> getMyPropertiesApi(
    {int? currentPage, required int property_for}) async {
  return MyPropertiesResponseModel.fromJson(await handleResponse(
      await buildHttpResponse(
          'my-property?page=$currentPage&property_for=$property_for',
          method: HttpMethod.GET)));
}

///inquiry for other property
Future<PropertyInquiryResponse> getPropertyInquiryApi() async {
  return PropertyInquiryResponse.fromJson(await handleResponse(
      await buildHttpResponse('user-inquiry-property',
          method: HttpMethod.GET)));
}

///my advertisement property
Future<MyAdvertisementPropertyResponse> getMyAdvertisementApi(int page) async {
  return MyAdvertisementPropertyResponse.fromJson(await handleResponse(
      await buildHttpResponse('get-my-advertisement-property',
          method: HttpMethod.GET)));
}

///my own property history
Future<MyAdvertisementPropertyResponse> getMyOwnPropertyApi(int page) async {
  return MyAdvertisementPropertyResponse.fromJson(await handleResponse(
      await buildHttpResponse('my-property?page=$page',
          method: HttpMethod.GET)));
}

///set as advertisement
Future<PropertyDetailsModel> setPropertyAdvertisement(Map request) async {
  return PropertyDetailsModel.fromJson(await (handleResponse(
      await buildHttpResponse("set-property-advertisement",
          request: request, method: HttpMethod.POST))));
}

///who contact_info
Future<PropertyContactInfoResponse> getWhoInquiredMyPropertyUserListApi(
    int? page) async {
  return PropertyContactInfoResponse.fromJson(await handleResponse(
      await buildHttpResponse('who-inquired-my-property-user-list?page=$page',
          method: HttpMethod.GET)));
}

///contact info details
Future<ContactInfoDetailsResponse> getWhoInquiredMyPropertyUserDetailsListApi(
    int? id) async {
  return ContactInfoDetailsResponse.fromJson(await handleResponse(
          await buildHttpResponse('who-inquired-my-property?customer_id=$id',
              method: HttpMethod.GET))
      .then((value) => value));
}

///save property history
Future<PropertyDetailsModel> savePropertyHistory(Map req) async {
  return PropertyDetailsModel.fromJson(await handleResponse(
          await buildHttpResponse('inquiry-for-property',
              request: req, method: HttpMethod.POST))
      .then((value) => value));
}

///extra property limit
Future<LimitPropertyResponse> getExtraPropertyLimit(
    String? propertyType) async {
  return LimitPropertyResponse.fromJson(await handleResponse(
          await buildHttpResponse(
              'extra-property-limit-list?type=$propertyType',
              method: HttpMethod.GET))
      .then((value) => value));
}

///near by property
Future<PropertyListModel> getNearByProperty(Map request, {int? page}) async {
  return PropertyListModel.fromJson(await handleResponse(
          await buildHttpResponse('nearby-property-list?page=$page',
              request: request, method: HttpMethod.POST))
      .then((value) => value));
}

///advertisement
Future<PropertyListModel> getAdvertisementList(String? city) async {
  return PropertyListModel.fromJson(await handleResponse(
          await buildHttpResponse(
              'get-others-advertisement-property?city=$city',
              method: HttpMethod.GET))
      .then((value) => value));
}

///property update
Future<PropertyListModel> updatePropertyDetail(Map request) async {
  return PropertyListModel.fromJson(await handleResponse(
          await buildHttpResponse('property-update',
              request: request, method: HttpMethod.POST))
      .then((value) => value));
}

///delete property
Future<EPropertyBaseResponse> deleteProperty(int? id) async {
  return EPropertyBaseResponse.fromJson(await handleResponse(
          await buildHttpResponse('property-delete/$id',
              method: HttpMethod.POST))
      .then((value) => value));
}

/// Purchase extra Limit add Property
Future<PurchaseExtraLimitResponse> purchaseExtraLimitApi(Map req) async {
  return PurchaseExtraLimitResponse.fromJson(await handleResponse(
      await buildHttpResponse('purchase-extra-property-limit',
          request: req, method: HttpMethod.POST)));
}

///DeleteUserFirebase
Future deleteUserFirebase() async {
  if (FirebaseAuth.instance.currentUser != null) {
    FirebaseAuth.instance.currentUser!.delete();
    await FirebaseAuth.instance.signOut();
  }
}

Future<void> logout(BuildContext context, {bool isFromLogin = false}) async {
  await sharedPreferences.remove(IS_LOGGED_IN);
  await sharedPreferences.remove(USER_ID);
  await sharedPreferences.remove(USER_TYPE);
  await sharedPreferences.remove(NAME);
  await sharedPreferences.remove(USER_PROFILE_PHOTO);
  await sharedPreferences.remove(USER_CONTACT_NUMBER);
  await sharedPreferences.remove(USER_NAME);
  await sharedPreferences.remove(USER_ADDRESS);
  await sharedPreferences.remove(IS_OTP);
  userStore.setLogin(false);
  if (!isFromLogin) {
    LoginScreen().launch(context, isNewTask: true);
    appStore.setLoading(true);
  }
}
