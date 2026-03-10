import 'article_model.dart';

class DashboardResponse {
  AppSetting? appSetting;
  List<Category>? category;
  List<MSlider>? slider;
  List<Amenity>? amenity;

  // List<UserProperty>? userProperty;
  List<OwnerProperty>? ownerProperty;
  List<Property>? property;
  List<NearbyProperty>? nearByProperty;
  List<Property>? fullyFurnishedProperty;
  List<PropertyType>? propertyType;
  List<Article>? article;
  List<PropertyCity>? propertyCity;
  FilterConfiguration? filterConfiguration;
  List<Property>? advertisementProperty;
  String? crispChatWebsiteId;
  String? isCrispChatEnabled;

  DashboardResponse(
      {this.appSetting,
      this.category,
      this.slider,
      this.amenity,
      // this.userProperty,
      this.ownerProperty,
      this.property,
      this.nearByProperty,
      this.fullyFurnishedProperty,
      this.propertyType,
      this.article,
      this.propertyCity,
      this.filterConfiguration,
      this.advertisementProperty,
      this.crispChatWebsiteId,
      this.isCrispChatEnabled});

  DashboardResponse.fromJson(Map<String, dynamic> json) {
    appSetting = json['app_setting'] != null ? new AppSetting.fromJson(json['app_setting']) : null;
    if (json['category'] != null) {
      category = <Category>[];
      json['category'].forEach((v) {
        category!.add(Category.fromJson(v));
      });
    }
    if (json['slider'] != null) {
      slider = <MSlider>[];
      json['slider'].forEach((v) {
        slider!.add(MSlider.fromJson(v));
      });
    }
    if (json['amenity'] != null) {
      amenity = <Amenity>[];
      json['amenity'].forEach((v) {
        amenity!.add(Amenity.fromJson(v));
      });
    }
    // if (json['user_property'] != null) {
    //   userProperty = <UserProperty>[];
    //   json['user_property'].forEach((v) {
    //     userProperty!.add(new UserProperty.fromJson(v));
    //   });
    // }
    if (json['owner_property'] != null) {
      ownerProperty = <OwnerProperty>[];
      json['owner_property'].forEach((v) {
        ownerProperty!.add(OwnerProperty.fromJson(v));
      });
    }
    if (json['property'] != null) {
      property = <Property>[];
      json['property'].forEach((v) {
        property!.add(Property.fromJson(v));
      });
    }
    if (json['near_by_property'] != null) {
      nearByProperty = <NearbyProperty>[];
      json['near_by_property'].forEach((v) {
        nearByProperty!.add(NearbyProperty.fromJson(v));
      });
    }
    if (json['fully_furnished_property'] != null) {
      fullyFurnishedProperty = <Property>[];
      json['fully_furnished_property'].forEach((v) {
        fullyFurnishedProperty!.add(Property.fromJson(v));
      });
    }
    if (json['property_type'] != null) {
      propertyType = <PropertyType>[];
      json['property_type'].forEach((v) {
        propertyType!.add(PropertyType.fromJson(v));
      });
    }
    if (json['article'] != null) {
      article = <Article>[];
      json['article'].forEach((v) {
        article!.add(Article.fromJson(v));
      });
    }
    if (json['property_city'] != null) {
      propertyCity = <PropertyCity>[];
      json['property_city'].forEach((v) {
        propertyCity!.add(PropertyCity.fromJson(v));
      });
    }
    filterConfiguration = json['filter_configuration'] != null ? new FilterConfiguration.fromJson(json['filter_configuration']) : null;
    if (json['advertisement_property'] != null) {
      advertisementProperty = <Property>[];
      json['advertisement_property'].forEach((v) {
        advertisementProperty!.add(Property.fromJson(v));
      });
    }
    crispChatWebsiteId = json['crisp_chat_website_id'];
    isCrispChatEnabled = json['is_crisp_chat_enabled'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.appSetting != null) {
      data['app_setting'] = this.appSetting!.toJson();
    }
    if (this.category != null) {
      data['category'] = this.category!.map((v) => v.toJson()).toList();
    }
    if (this.slider != null) {
      data['slider'] = this.slider!.map((v) => v.toJson()).toList();
    }
    if (this.amenity != null) {
      data['amenity'] = this.amenity!.map((v) => v.toJson()).toList();
    }
    // if (this.userProperty != null) {
    //   data['user_property'] = this.userProperty!.map((v) => v.toJson()).toList();
    // }
    if (this.ownerProperty != null) {
      data['owner_property'] = this.ownerProperty!.map((v) => v.toJson()).toList();
    }
    if (this.property != null) {
      data['property'] = this.property!.map((v) => v.toJson()).toList();
    }
    if (this.nearByProperty != null) {
      data['near_by_property'] = this.nearByProperty!.map((v) => v.toJson()).toList();
    }
    if (this.fullyFurnishedProperty != null) {
      data['fully_furnished_property'] = this.fullyFurnishedProperty!.map((v) => v.toJson()).toList();
    }
    if (this.propertyType != null) {
      data['property_type'] = this.propertyType!.map((v) => v.toJson()).toList();
    }
    if (this.article != null) {
      data['article'] = this.article!.map((v) => v.toJson()).toList();
    }
    if (this.propertyCity != null) {
      data['property_city'] = this.propertyCity!.map((v) => v.toJson()).toList();
    }
    if (this.filterConfiguration != null) {
      data['filter_configuration'] = this.filterConfiguration!.toJson();
    }
    if (this.advertisementProperty != null) {
      data['advertisement_property'] = this.advertisementProperty!.map((v) => v.toJson()).toList();
    }
    data['crisp_chat_website_id'] = this.crispChatWebsiteId;
    data['is_crisp_chat_enabled'] = this.isCrispChatEnabled;
    return data;
  }
}

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

  // List<String>? languageOption;
  String? contactEmail;
  String? contactNumber;
  String? helpSupportUrl;

  // List<Null>? notificationSettings;
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
      // this.languageOption,
      this.contactEmail,
      this.contactNumber,
      this.helpSupportUrl,
      // this.notificationSettings,
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
    // languageOption = json['language_option'].cast<String>();
    contactEmail = json['contact_email'];
    contactNumber = json['contact_number'];
    helpSupportUrl = json['help_support_url'];
    // if (json['notification_settings'] != null) {
    //   notificationSettings = <Null>[];
    //   json['notification_settings'].forEach((v) {
    //     notificationSettings!.add(new Null.fromJson(v));
    //   });
    // }
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
    // data['language_option'] = this.languageOption;
    data['contact_email'] = this.contactEmail;
    data['contact_number'] = this.contactNumber;
    data['help_support_url'] = this.helpSupportUrl;
    // if (this.notificationSettings != null) {
    //   data['notification_settings'] =
    //       this.notificationSettings!.map((v) => v.toJson()).toList();
    // }
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

class Category {
  int? id;
  String? name;
  String? status;
  String? categoryImage;
  List<AmenityName>? amenityName;
  String? createdAt;
  String? updatedAt;

  Category({this.id, this.name, this.status, this.categoryImage, this.amenityName, this.createdAt, this.updatedAt});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    status = json['status'];
    categoryImage = json['category_image'];
    if (json['amenity_name'] != null) {
      amenityName = <AmenityName>[];
      json['amenity_name'].forEach((v) {
        amenityName!.add(new AmenityName.fromJson(v));
      });
    }
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['status'] = this.status;
    data['category_image'] = this.categoryImage;
    if (this.amenityName != null) {
      data['amenity_name'] = this.amenityName!.map((v) => v.toJson()).toList();
    }
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class AmenityName {
  int? id;
  String? name;
  String? status;
  String? type;

  // List<String>? value;
  String? createdAt;
  String? updatedAt;
  String? amenityImage;

  AmenityName(
      {this.id,
      this.name,
      this.status,
      this.type,
      // this.value,
      this.createdAt,
      this.updatedAt,
      this.amenityImage});

  AmenityName.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    status = json['status'];
    type = json['type'];
    // value = json['value'].cast<String>();
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    amenityImage = json['amenity_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['status'] = this.status;
    data['type'] = this.type;
    // data['value'] = this.value;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['amenity_image'] = this.amenityImage;
    return data;
  }
}

class MSlider {
  int? id;
  int? categoryId;
  String? categoryName;
  int? propertyId;
  String? propertyName;
  String? description;
  int? status;
  String? sliderImage;
  String? createdAt;
  String? updatedAt;

  MSlider({this.id, this.categoryId, this.categoryName, this.propertyId, this.propertyName, this.description, this.status, this.sliderImage, this.createdAt, this.updatedAt});

  MSlider.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryId = json['category_id'];
    categoryName = json['category_name'];
    propertyId = json['property_id'];
    propertyName = json['property_name'];
    description = json['description'];
    status = json['status'];
    sliderImage = json['slider_image'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['category_id'] = this.categoryId;
    data['category_name'] = this.categoryName;
    data['property_id'] = this.propertyId;
    data['property_name'] = this.propertyName;
    data['description'] = this.description;
    data['status'] = this.status;
    data['slider_image'] = this.sliderImage;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class Amenity {
  int? id;
  String? name;
  String? type;
  int? status;

  // List<String>? values;
  String? amenityImage;
  String? createdAt;
  String? updatedAt;

  Amenity(
      {this.id,
      this.name,
      this.type,
      this.status,
      // this.values,
      this.amenityImage,
      this.createdAt,
      this.updatedAt});

  Amenity.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    type = json['type'];
    status = json['status'];
    // values = json['values'].cast<String>();
    amenityImage = json['amenity_image'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['type'] = this.type;
    data['status'] = this.status;
    // data['values'] = this.values;
    data['amenity_image'] = this.amenityImage;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class Property {
  int? id;
  String? name;
  int? categoryId;
  String? category;
  String? categoryImage;
  int? price;
  String? priceFormat;
  String? address;
  int? status;
  int? premiumProperty;
  String? propertyImage;
  int? isFavourite;
  int? propertyTypeId;
  String? propertyType;
  int? propertyFor;
  int? advertisementProperty;
  String? advertisementPropertyDate;

  Property(
      {this.id,
      this.name,
      this.categoryId,
      this.category,
      this.categoryImage,
      this.price,
      this.priceFormat,
      this.address,
      this.status,
      this.premiumProperty,
      this.propertyImage,
      this.isFavourite,
      this.propertyTypeId,
      this.propertyType,
      this.propertyFor,this.advertisementProperty,
        this.advertisementPropertyDate});

  Property.fromJson(Map<String, dynamic> json) {
    id = int.tryParse(json['id']?.toString() ?? '0');
    categoryId = int.tryParse(json['category_id']?.toString() ?? '0');
    price = int.tryParse(json['price']?.toString() ?? '0');
    status = int.tryParse(json['status']?.toString() ?? '0');
    premiumProperty = int.tryParse(json['premium_property']?.toString() ?? '0');
    isFavourite = int.tryParse(json['is_favourite']?.toString() ?? '0');
    propertyFor = int.tryParse(json['property_for']?.toString() ?? '0');
    advertisementProperty = int.tryParse(json['advertisement_property']?.toString() ?? '0');

    name = json['name'];
    category = json['category'];
    categoryImage = json['category_image'];
    priceFormat = json['price_format'];
    address = json['address'];
    propertyImage = json['property_image'];
    propertyType = json['property_type'];
    advertisementPropertyDate = json['advertisement_property_date'];
  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['category_id'] = this.categoryId;
    data['category'] = this.category;
    data['category_image'] = this.categoryImage;
    data['price'] = this.price;
    data['price_format'] = this.priceFormat;
    data['address'] = this.address;
    data['status'] = this.status;
    data['premium_property'] = this.premiumProperty;
    data['property_image'] = this.propertyImage;
    data['is_favourite'] = this.isFavourite;
    data['property_type_id'] = this.propertyTypeId;
    data['property_type'] = this.propertyType;
    data['property_for'] = this.propertyFor;
    data['advertisement_property'] = this.advertisementProperty;
    data['advertisement_property_date'] = this.advertisementPropertyDate;
    return data;
  }
}

class PropertyType {
  int? id;
  String? name;
  int? status;
  String? propertyTypeImage;
  String? createdAt;
  String? updatedAt;

  PropertyType({this.id, this.name, this.status, this.propertyTypeImage, this.createdAt, this.updatedAt});

  PropertyType.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    status = json['status'];
    propertyTypeImage = json['property_type_image'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['status'] = this.status;
    data['property_type_image'] = this.propertyTypeImage;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class OwnerProperty {
  int? id;
  String? name;
  int? categoryId;
  String? category;
  String? categoryImage;
  int? price;
  String? priceFormat;
  String? address;
  int? status;
  int? premiumProperty;
  String? priceDuration;
  String? propertyImage;
  int? isFavourite;
  int? propertyFor;
  int? advertisementProperty;
  String? advertisementPropertyDate;

  OwnerProperty(
      {this.id,
      this.name,
      this.categoryId,
      this.category,
      this.categoryImage,
      this.price,
      this.priceFormat,
      this.address,
      this.status,
      this.premiumProperty,
      this.priceDuration,
      this.propertyImage,
      this.isFavourite,
      this.propertyFor,
      this.advertisementProperty,
      this.advertisementPropertyDate});

  OwnerProperty.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    categoryId = json['category_id'];
    category = json['category'];
    categoryImage = json['category_image'];
    price = json['price'];
    priceFormat = json['price_format'];
    address = json['address'];
    status = json['status'];
    premiumProperty = json['premium_property'];
    priceDuration = json['price_duration'];
    propertyImage = json['property_image'];
    isFavourite = json['is_favourite'];
    propertyFor = json['property_for'];
    advertisementProperty = json['advertisement_property'];
    advertisementPropertyDate = json['advertisement_property_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['category_id'] = this.categoryId;
    data['category'] = this.category;
    data['category_image'] = this.categoryImage;
    data['price'] = this.price;
    data['price_format'] = this.priceFormat;
    data['address'] = this.address;
    data['status'] = this.status;
    data['premium_property'] = this.premiumProperty;
    data['price_duration'] = this.priceDuration;
    data['property_image'] = this.propertyImage;
    data['is_favourite'] = this.isFavourite;
    data['property_for'] = this.propertyFor;
    data['advertisement_property'] = this.advertisementProperty;
    data['advertisement_property_date'] = this.advertisementPropertyDate;
    return data;
  }
}

class AdvertisementProperty {
  int? id;
  String? name;
  int? categoryId;
  String? category;
  String? categoryImage;
  int? price;
  String? priceFormat;
  String? address;
  int? status;
  int? premiumProperty;
  String? priceDuration;
  String? propertyImage;
  int? isFavourite;
  int? propertyFor;
  int? advertisementProperty;
  String? advertisementPropertyDate;

  AdvertisementProperty(
      {this.id,
      this.name,
      this.categoryId,
      this.category,
      this.categoryImage,
      this.price,
      this.priceFormat,
      this.address,
      this.status,
      this.premiumProperty,
      this.priceDuration,
      this.propertyImage,
      this.isFavourite,
      this.propertyFor,
      this.advertisementProperty,
      this.advertisementPropertyDate});

  AdvertisementProperty.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    categoryId = json['category_id'];
    category = json['category'];
    categoryImage = json['category_image'];
    price = json['price'];
    priceFormat = json['price_format'];
    address = json['address'];
    status = json['status'];
    premiumProperty = json['premium_property'];
    priceDuration = json['price_duration'];
    propertyImage = json['property_image'];
    isFavourite = json['is_favourite'];
    propertyFor = json['property_for'];
    advertisementProperty = json['advertisement_property'];
    advertisementPropertyDate = json['advertisement_property_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['category_id'] = this.categoryId;
    data['category'] = this.category;
    data['category_image'] = this.categoryImage;
    data['price'] = this.price;
    data['price_format'] = this.priceFormat;
    data['address'] = this.address;
    data['status'] = this.status;
    data['premium_property'] = this.premiumProperty;
    data['price_duration'] = this.priceDuration;
    data['property_image'] = this.propertyImage;
    data['is_favourite'] = this.isFavourite;
    data['property_for'] = this.propertyFor;
    data['advertisement_property'] = this.advertisementProperty;
    data['advertisement_property_date'] = this.advertisementPropertyDate;
    return data;
  }
}

class NearbyProperty {
  int? id;
  String? name;
  int? categoryId;
  String? category;
  String? categoryImage;
  int? price;
  String? priceFormat;
  String? address;
  int? status;
  int? premiumProperty;
  String? priceDuration;
  String? propertyImage;
  int? isFavourite;
  int? propertyFor;
  int? advertisementProperty;
  String? advertisementPropertyDate;

  NearbyProperty(
      {this.id,
      this.name,
      this.categoryId,
      this.category,
      this.categoryImage,
      this.price,
      this.priceFormat,
      this.address,
      this.status,
      this.premiumProperty,
      this.priceDuration,
      this.propertyImage,
      this.isFavourite,
      this.propertyFor,
      this.advertisementProperty,
      this.advertisementPropertyDate});

  NearbyProperty.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    categoryId = json['category_id'];
    category = json['category'];
    categoryImage = json['category_image'];
    price = json['price'];
    priceFormat = json['price_format'];
    address = json['address'];
    status = json['status'];
    premiumProperty = json['premium_property'];
    priceDuration = json['price_duration'];
    propertyImage = json['property_image'];
    isFavourite = json['is_favourite'];
    propertyFor = json['property_for'];
    advertisementProperty = json['advertisement_property'];
    advertisementPropertyDate = json['advertisement_property_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['category_id'] = this.categoryId;
    data['category'] = this.category;
    data['category_image'] = this.categoryImage;
    data['price'] = this.price;
    data['price_format'] = this.priceFormat;
    data['address'] = this.address;
    data['status'] = this.status;
    data['premium_property'] = this.premiumProperty;
    data['price_duration'] = this.priceDuration;
    data['property_image'] = this.propertyImage;
    data['is_favourite'] = this.isFavourite;
    data['property_for'] = this.propertyFor;
    data['advertisement_property'] = this.advertisementProperty;
    data['advertisement_property_date'] = this.advertisementPropertyDate;
    return data;
  }
}

class FullyFurnishedProperty {
  int? id;
  String? name;
  int? categoryId;
  String? category;
  String? categoryImage;
  int? price;
  String? priceFormat;
  String? address;
  int? status;
  int? premiumProperty;
  String? priceDuration;
  String? propertyImage;
  int? isFavourite;
  int? propertyFor;
  int? advertisementProperty;
  String? advertisementPropertyDate;

  FullyFurnishedProperty(
      {this.id,
      this.name,
      this.categoryId,
      this.category,
      this.categoryImage,
      this.price,
      this.priceFormat,
      this.address,
      this.status,
      this.premiumProperty,
      this.priceDuration,
      this.propertyImage,
      this.isFavourite,
      this.propertyFor,
      this.advertisementProperty,
      this.advertisementPropertyDate});

  FullyFurnishedProperty.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    categoryId = json['category_id'];
    category = json['category'];
    categoryImage = json['category_image'];
    price = json['price'];
    priceFormat = json['price_format'];
    address = json['address'];
    status = json['status'];
    premiumProperty = json['premium_property'];
    priceDuration = json['price_duration'];
    propertyImage = json['property_image'];
    isFavourite = json['is_favourite'];
    propertyFor = json['property_for'];
    advertisementProperty = json['advertisement_property'];
    advertisementPropertyDate = json['advertisement_property_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['category_id'] = this.categoryId;
    data['category'] = this.category;
    data['category_image'] = this.categoryImage;
    data['price'] = this.price;
    data['price_format'] = this.priceFormat;
    data['address'] = this.address;
    data['status'] = this.status;
    data['premium_property'] = this.premiumProperty;
    data['price_duration'] = this.priceDuration;
    data['property_image'] = this.propertyImage;
    data['is_favourite'] = this.isFavourite;
    data['property_for'] = this.propertyFor;
    data['advertisement_property'] = this.advertisementProperty;
    data['advertisement_property_date'] = this.advertisementPropertyDate;
    return data;
  }
}

class Tags {
  int? id;
  String? name;

  Tags({this.id, this.name});

  Tags.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}

class PropertyCity {
  String? name;

  PropertyCity({this.name});

  PropertyCity.fromJson(Map<String, dynamic> json) {
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    return data;
  }
}

class FilterConfiguration {
  int? minPrice;
  int? maxPrice;
  int? minBrokerage;
  int? maxBrokerage;
  int? minSecurityDeposit;
  int? maxSecurityDeposit;
  num? minAgeOfProperty;
  num? maxAgeOfProperty;

  FilterConfiguration({this.minPrice, this.maxPrice, this.minBrokerage, this.maxBrokerage, this.minSecurityDeposit, this.maxSecurityDeposit, this.minAgeOfProperty, this.maxAgeOfProperty});


  FilterConfiguration.fromJson(Map<String, dynamic> json) {
    minPrice = int.tryParse(json['min_price']?.toString() ?? '0');
    maxPrice = int.tryParse(json['max_price']?.toString() ?? '0');
    minBrokerage = int.tryParse(json['min_brokerage']?.toString() ?? '0');
    maxBrokerage = int.tryParse(json['max_brokerage']?.toString() ?? '0');
    minSecurityDeposit = int.tryParse(json['min_security_deposit']?.toString() ?? '0');
    maxSecurityDeposit = int.tryParse(json['max_security_deposit']?.toString() ?? '0');
    minAgeOfProperty = num.tryParse(json['min_age_of_property']?.toString() ?? '0');
    maxAgeOfProperty = num.tryParse(json['max_age_of_property']?.toString() ?? '0');
  }

  // FilterConfiguration.fromJson(Map<String, dynamic> json) {
  //   minPrice = json['min_price'];
  //   maxPrice = json['max_price'];
  //   minBrokerage = json['min_brokerage'];
  //   maxBrokerage = json['max_brokerage'];
  //   minSecurityDeposit = json['min_security_deposit'];
  //   maxSecurityDeposit = json['max_security_deposit'];
  //   minAgeOfProperty = json['min_age_of_property'];
  //   maxAgeOfProperty = json['max_age_of_property'];
  // }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['min_price'] = this.minPrice;
    data['max_price'] = this.maxPrice;
    data['min_brokerage'] = this.minBrokerage;
    data['max_brokerage'] = this.maxBrokerage;
    data['min_security_deposit'] = this.minSecurityDeposit;
    data['max_security_deposit'] = this.maxSecurityDeposit;
    data['min_age_of_property'] = this.minAgeOfProperty;
    data['max_age_of_property'] = this.maxAgeOfProperty;
    return data;
  }
}
