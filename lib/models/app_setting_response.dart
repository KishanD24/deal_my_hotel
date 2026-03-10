class AppSettingResponse {
  AppSetting? appSetting;
  TermsCondition? termsCondition;
  TermsCondition? privacyPolicy;
  CurrencySetting? currencySetting;

  AppSettingResponse({this.appSetting, this.termsCondition, this.privacyPolicy, this.currencySetting});

  AppSettingResponse.fromJson(Map<String, dynamic> json) {
    appSetting = json['app_setting'] != null ? new AppSetting.fromJson(json['app_setting']) : null;
    termsCondition = json['terms_condition'] != null ? new TermsCondition.fromJson(json['terms_condition']) : null;
    privacyPolicy = json['privacy_policy'] != null ? new TermsCondition.fromJson(json['privacy_policy']) : null;
    currencySetting = json['currency_setting'] != null ? new CurrencySetting.fromJson(json['currency_setting']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.appSetting != null) {
      data['app_setting'] = this.appSetting!.toJson();
    }
    data['terms_condition'] = this.termsCondition;
    data['privacy_policy'] = this.privacyPolicy;
    if (this.currencySetting != null) {
      data['currency_setting'] = this.currencySetting!.toJson();
    }
    return data;
  }
}

// class AppSetting {
//   int? id;
//   String? siteName;
//   String? siteEmail;
//   String? siteLogo;
//   String? siteFavicon;
//   String? siteDescription;
//   String? siteCopyright;
//   String? facebookUrl;
//   String? instagramUrl;
//   String? twitterUrl;
//   String? linkedinUrl;
//   List<String>? languageOption;
//   String? contactEmail;
//   String? contactNumber;
//   String? helpSupportUrl;
//   List<String>? notificationSettings;
//   String? createdAt;
//   String? updatedAt;
//
//   AppSetting(
//       {this.id,
//       this.siteName,
//       this.siteEmail,
//       this.siteLogo,
//       this.siteFavicon,
//       this.siteDescription,
//       this.siteCopyright,
//       this.facebookUrl,
//       this.instagramUrl,
//       this.twitterUrl,
//       this.linkedinUrl,
//       this.languageOption,
//       this.contactEmail,
//       this.contactNumber,
//       this.helpSupportUrl,
//       this.notificationSettings,
//       this.createdAt,
//       this.updatedAt});
//
//   AppSetting.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     siteName = json['site_name'];
//     siteEmail = json['site_email'];
//     siteLogo = json['site_logo'];
//     siteFavicon = json['site_favicon'];
//     siteDescription = json['site_description'];
//     siteCopyright = json['site_copyright'];
//     facebookUrl = json['facebook_url'];
//     instagramUrl = json['instagram_url'];
//     twitterUrl = json['twitter_url'];
//     linkedinUrl = json['linkedin_url'];
//     languageOption = json['language_option'].cast<String>();
//     contactEmail = json['contact_email'];
//     contactNumber = json['contact_number'];
//     helpSupportUrl = json['help_support_url'];
//     notificationSettings = json['notificationSettings'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['site_name'] = this.siteName;
//     data['site_email'] = this.siteEmail;
//     data['site_logo'] = this.siteLogo;
//     data['site_favicon'] = this.siteFavicon;
//     data['site_description'] = this.siteDescription;
//     data['site_copyright'] = this.siteCopyright;
//     data['facebook_url'] = this.facebookUrl;
//     data['instagram_url'] = this.instagramUrl;
//     data['twitter_url'] = this.twitterUrl;
//     data['linkedin_url'] = this.linkedinUrl;
//     data['language_option'] = this.languageOption;
//     data['contact_email'] = this.contactEmail;
//     data['contact_number'] = this.contactNumber;
//     data['help_support_url'] = this.helpSupportUrl;
//     data['notification_settings'] = this.notificationSettings;
//     data['created_at'] = this.createdAt;
//     data['updated_at'] = this.updatedAt;
//     return data;
//   }
// }

class AppSetting {
  int? id;
  String? siteName;
  String? siteEmail;
  String? siteLogo;
  String? siteFavicon;
  String? siteDescription;
  String? siteCopyright;
  String? facebookUrl;
  String? instagramUrl;
  String? twitterUrl;
  String? linkedinUrl;
  List<String>? languageOption;
  String? contactEmail;
  String? contactNumber;
  String? helpSupportUrl;
  List<String>? notificationSettings;
  String? createdAt;
  String? updatedAt;
  TermsCondition? termsCondition;
  TermsCondition? privacyPolicy;
  String? subscription;
  CurrencySetting? currencySetting;

  AppSetting(
      {this.id,
      this.siteName,
      this.siteEmail,
      this.siteLogo,
      this.siteFavicon,
      this.siteDescription,
      this.siteCopyright,
      this.facebookUrl,
      this.instagramUrl,
      this.twitterUrl,
      this.linkedinUrl,
      this.languageOption,
      this.contactEmail,
      this.contactNumber,
      this.helpSupportUrl,
      this.notificationSettings,
      this.createdAt,
      this.updatedAt,
      this.termsCondition,
      this.privacyPolicy,
      this.subscription,
      this.currencySetting});

  AppSetting.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    siteName = json['site_name'];
    siteEmail = json['site_email'];
    siteLogo = json['site_logo'];
    siteFavicon = json['site_favicon'];
    siteDescription = json['site_description'];
    siteCopyright = json['site_copyright'];
    facebookUrl = json['facebook_url'];
    instagramUrl = json['instagram_url'];
    twitterUrl = json['twitter_url'];
    linkedinUrl = json['linkedin_url'];
    languageOption = json['language_option'].cast<String>();
    contactEmail = json['contact_email'];
    contactNumber = json['contact_number'];
    helpSupportUrl = json['help_support_url'];
    notificationSettings = json['notificationSettings'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    termsCondition = json['terms_condition'] != null ? new TermsCondition.fromJson(json['terms_condition']) : null;
    privacyPolicy = json['privacy_policy'] != null ? new TermsCondition.fromJson(json['privacy_policy']) : null;
    subscription = json['subscription'];
    currencySetting = json['currency_setting'] != null ? new CurrencySetting.fromJson(json['currency_setting']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['site_name'] = this.siteName;
    data['site_email'] = this.siteEmail;
    data['site_logo'] = this.siteLogo;
    data['site_favicon'] = this.siteFavicon;
    data['site_description'] = this.siteDescription;
    data['site_copyright'] = this.siteCopyright;
    data['facebook_url'] = this.facebookUrl;
    data['instagram_url'] = this.instagramUrl;
    data['twitter_url'] = this.twitterUrl;
    data['linkedin_url'] = this.linkedinUrl;
    data['language_option'] = this.languageOption;
    data['contact_email'] = this.contactEmail;
    data['contact_number'] = this.contactNumber;
    data['help_support_url'] = this.helpSupportUrl;
    data['notification_settings'] = this.notificationSettings;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.termsCondition != null) {
      data['terms_condition'] = this.termsCondition!.toJson();
    }
    if (this.privacyPolicy != null) {
      data['privacy_policy'] = this.privacyPolicy!.toJson();
    }
    data['subscription'] = this.subscription;
    if (this.currencySetting != null) {
      data['currency_setting'] = this.currencySetting!.toJson();
    }
    return data;
  }
}

class TermsCondition {
  int? id;
  String? key;
  String? type;
  String? value;

  TermsCondition({this.id, this.key, this.type, this.value});

  TermsCondition.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    key = json['key'];
    type = json['type'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['key'] = this.key;
    data['type'] = this.type;
    data['value'] = this.value;
    return data;
  }
}

class CurrencySetting {
  String? name;
  String? symbol;
  String? code;
  String? position;

  CurrencySetting({this.name, this.symbol, this.code, this.position});

  CurrencySetting.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    symbol = json['symbol'];
    code = json['code'];
    position = json['position'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['symbol'] = this.symbol;
    data['code'] = this.code;
    data['position'] = this.position;
    return data;
  }
}
