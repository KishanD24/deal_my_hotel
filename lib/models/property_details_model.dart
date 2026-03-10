import '../models/category_list_model.dart';

class PropertyDetailsModel {
  PropertyDetail? data;
  List<AmenityName>? propertyAmenityValue;
  Customer? customer;
  NearByPlace? nearByPlace;

  PropertyDetailsModel({this.data, this.propertyAmenityValue, this.customer, this.nearByPlace});

  PropertyDetailsModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new PropertyDetail.fromJson(json['data']) : null;

    if (json['property_amenity_value'] != null) {
      propertyAmenityValue = <AmenityName>[];
      json['property_amenity_value'].forEach((v) {
        propertyAmenityValue!.add(new AmenityName.fromJson(v));
      });
    }

    customer = json['customer'] != null ? new Customer.fromJson(json['customer']) : null;

    // nearByPlace = json['near_by_place'] != null ? new NearByPlace.fromJson(json['near_by_place']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    if (this.propertyAmenityValue != null) {
      data['property_amenity_value'] = this.propertyAmenityValue!.map((v) => v.toJson()).toList();
    }
    if (this.customer != null) {
      data['customer'] = this.customer!.toJson();
    }
    if (this.nearByPlace != null) {
      data['near_by_place'] = this.nearByPlace!.toJson();
    }
    return data;
  }
}

class PropertyDetail {
  int? id;
  String? name;
  int? categoryId;
  String? category;
  String? categoryImage;
  int? propertyTypeId;
  String? propertyType;
  int? price;
  String? priceFormat;
  int? furnishedType;
  int? sallerType;
  int? propertyFor;
  String? priceDuration;
  num? ageOfProperty;
  int? maintenance;
  int? securityDeposit;
  int? brokerage;
  int? bhk;
  String? sqft;
  String? description;
  String? country;
  String? state;
  String? city;
  String? latitude;
  String? longitude;
  String? address;
  dynamic videoUrl;
  int? status;
  int? premiumProperty;
  String? propertyImage;
  List<dynamic>? propertyGallary;
  List<PropertyGallaryArray>? propertyGallaryArray;
  String? createdAt;
  String? updatedAt;
  int? isFavourite;
  int? advertisementProperty;
  String? advertisementPropertyDate;
  int? checkedPropertyInquiry;

  PropertyDetail(
      {this.id,
      this.name,
      this.categoryId,
      this.category,
      this.categoryImage,
      this.price,
      this.priceFormat,
      this.furnishedType,
      this.sallerType,
      this.propertyFor,
      this.priceDuration,
      this.ageOfProperty,
      this.maintenance,
      this.securityDeposit,
      this.brokerage,
      this.bhk,
      this.sqft,
      this.description,
      this.country,
      this.state,
      this.city,
      this.latitude,
      this.longitude,
      this.address,
      this.videoUrl,
      this.status,
      this.premiumProperty,
      this.propertyImage,
      this.propertyGallary,
      this.propertyGallaryArray,
      this.createdAt,
      this.updatedAt,
      this.isFavourite,
      this.advertisementProperty,
      this.advertisementPropertyDate,
      this.checkedPropertyInquiry});


  PropertyDetail.fromJson(Map<String, dynamic> json) {
    id = int.tryParse(json['id']?.toString() ?? '0');
    name = json['name'];

    categoryId = int.tryParse(json['category_id']?.toString() ?? '0');
    category = json['category'];
    categoryImage = json['category_image'];

    propertyTypeId = int.tryParse(json['property_type_id']?.toString() ?? '0');
    propertyType = json['property_type'];

    price = int.tryParse(json['price']?.toString() ?? '0');
    priceFormat = json['price_format'];

    furnishedType = int.tryParse(json['furnished_type']?.toString() ?? '0');
    sallerType = int.tryParse(json['saller_type']?.toString() ?? '0');
    propertyFor = int.tryParse(json['property_for']?.toString() ?? '0');

    priceDuration = json['price_duration'];
    ageOfProperty = num.tryParse(json['age_of_property']?.toString() ?? '0');

    maintenance = int.tryParse(json['maintenance']?.toString() ?? '0');
    securityDeposit = int.tryParse(json['security_deposit']?.toString() ?? '0');
    brokerage = int.tryParse(json['brokerage']?.toString() ?? '0');
    bhk = int.tryParse(json['bhk']?.toString() ?? '0');

    sqft = json['sqft'];
    description = json['description'];

    country = json['country'];
    state = json['state'];
    city = json['city'];

    latitude = json['latitude']?.toString();
    longitude = json['longitude']?.toString();
    address = json['address'];

    videoUrl = json['video_url'];

    status = int.tryParse(json['status']?.toString() ?? '0');
    premiumProperty = int.tryParse(json['premium_property']?.toString() ?? '0');

    propertyImage = json['property_image'];

    propertyGallary = json['property_gallary'] != null
        ? List<String>.from(json['property_gallary'])
        : [];

    if (json['property_gallary_array'] != null) {
      propertyGallaryArray = (json['property_gallary_array'] as List)
          .map((v) => PropertyGallaryArray.fromJson(v))
          .toList();
    }

    createdAt = json['created_at'];
    updatedAt = json['updated_at'];

    isFavourite = int.tryParse(json['is_favourite']?.toString() ?? '0');
    advertisementProperty =
        int.tryParse(json['advertisement_property']?.toString() ?? '0');

    advertisementPropertyDate = json['advertisement_property_date'];

    checkedPropertyInquiry =
        int.tryParse(json['checked_property_inquiry']?.toString() ?? '0');
  }

  // PropertyDetail.fromJson(Map<String, dynamic> json) {
  //   id = json['id'];
  //
  //   name = json['name'];
  //   categoryId = json['category_id'];
  //   category = json['category'];
  //   categoryImage = json['category_image'];
  //   price = json['price'];
  //   priceFormat = json['price_format'];
  //   furnishedType = json['furnished_type'];
  //   sallerType = json['saller_type'];
  //   propertyFor = json['property_for'];
  //   priceDuration = json['price_duration'];
  //   ageOfProperty = json['age_of_property'];
  //   maintenance = json['maintenance'];
  //   securityDeposit = json['security_deposit'];
  //
  //   brokerage = json['brokerage'];
  //   bhk = json['bhk'];
  //   sqft = json['sqft'];
  //   description = json['description'];
  //   country = json['country'];
  //   state = json['state'];
  //   city = json['city'];
  //   latitude = json['latitude'];
  //   longitude = json['longitude'];
  //   address = json['address'];
  //   videoUrl = json['video_url'];
  //   status = json['status'];
  //   premiumProperty = json['premium_property'];
  //
  //   propertyImage = json['property_image'];
  //   propertyGallary = json['property_gallary'].cast<String>();
  //
  //   if (json['property_gallary_array'] != null) {
  //     propertyGallaryArray = <PropertyGallaryArray>[];
  //     json['property_gallary_array'].forEach((v) {
  //       propertyGallaryArray!.add(new PropertyGallaryArray.fromJson(v));
  //     });
  //   }
  //
  //   createdAt = json['created_at'];
  //   updatedAt = json['updated_at'];
  //   isFavourite = json['is_favourite'];
  //   advertisementProperty = json['advertisement_property'];
  //   advertisementPropertyDate = json['advertisement_property_date'];
  //   checkedPropertyInquiry = json['checked_property_inquiry'];
  // }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['category_id'] = this.categoryId;
    data['category'] = this.category;
    data['category_image'] = this.categoryImage;
    data['price'] = this.price;
    data['price_format'] = this.priceFormat;
    data['furnished_type'] = this.furnishedType;
    data['saller_type'] = this.sallerType;
    data['property_for'] = this.propertyFor;
    data['price_duration'] = this.priceDuration;
    data['age_of_property'] = this.ageOfProperty;
    data['maintenance'] = this.maintenance;
    data['security_deposit'] = this.securityDeposit;
    data['brokerage'] = this.brokerage;
    data['bhk'] = this.bhk;
    data['sqft'] = this.sqft;
    data['description'] = this.description;
    data['country'] = this.country;
    data['state'] = this.state;
    data['city'] = this.city;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['address'] = this.address;
    data['video_url'] = this.videoUrl;
    data['status'] = this.status;
    data['premium_property'] = this.premiumProperty;
    data['property_image'] = this.propertyImage;
    data['property_gallary'] = this.propertyGallary;
    if (this.propertyGallaryArray != null) {
      data['property_gallary_array'] = this.propertyGallaryArray!.map((v) => v.toJson()).toList();
    }
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['is_favourite'] = this.isFavourite;
    data['advertisement_property'] = this.advertisementProperty;
    data['advertisement_property_date'] = this.advertisementPropertyDate;
    data['checked_property_inquiry'] = this.checkedPropertyInquiry;
    return data;
  }
}

class PropertyGallaryArray {
  int? id;
  String? url;

  PropertyGallaryArray({this.id, this.url});

  PropertyGallaryArray.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['url'] = this.url;
    return data;
  }
}

// class PropertyAmenityValue {
//   int? id;
//   int? propertyId;
//   int? amenityId;
//   String? name;
//   String? type;
//
//   // String? value;
//   dynamic value;
//   String? amenityImage;
//
//   PropertyAmenityValue({this.id, this.propertyId, this.amenityId, this.name, this.type, this.value, this.amenityImage});
//
//   PropertyAmenityValue.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     // propertyId = json['property_id'];
//     print("-------------+++property_id Clar");
//     // amenityId = json['amenity_id'];
//     print("-------------++++amenity_id Clar");
//     name = json['name'];
//     // type = json['type'];
//     // value = json['value'];
//     print("-------------++++value Clar");
//     amenityImage = json['amenity_image'];
//     print("-------------++++++amenity_image Clar");
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['property_id'] = this.propertyId;
//     data['amenity_id'] = this.amenityId;
//     data['name'] = this.name;
//     data['type'] = this.type;
//     data['value'] = this.value;
//     data['amenity_image'] = this.amenityImage;
//     return data;
//   }
// }

class Customer {
  int? id;
  String? firstName;
  String? lastName;
  String? email;
  String? address;
  String? contactNumber;
  String? profileImage;
  int? isAgent;
  int? isBuilder;

  Customer({this.id, this.firstName, this.lastName, this.email, this.address, this.contactNumber, this.profileImage, this.isAgent, this.isBuilder});

  Customer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    address = json['address'];

    contactNumber = json['contact_number'];
    profileImage = json['profile_image'];
    isAgent = json['is_agent'];
    isBuilder = json['is_builder'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['email'] = this.email;
    data['address'] = this.address;
    data['contact_number'] = this.contactNumber;
    data['profile_image'] = this.profileImage;
    data['is_agent'] = this.isAgent;
    data['is_builder'] = this.isBuilder;
    return data;
  }
}

class NearByPlace {
  List<Results>? results;
  String? status;

  NearByPlace({this.results, this.status});

  NearByPlace.fromJson(Map<String, dynamic> json) {
    if (json['results'] != null) {
      results = <Results>[];
      json['results'].forEach((v) {
        results!.add(new Results.fromJson(v));
      });
    }

    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.results != null) {
      data['results'] = this.results!.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    return data;
  }
}

class Results {
  Geometry? geometry;
  String? icon;
  String? iconBackgroundColor;
  String? iconMaskBaseUri;
  String? name;
  List<Photos>? photos;
  String? placeId;
  String? reference;
  String? scope;
  List<String>? types;
  String? vicinity;
  String? businessStatus;
  dynamic rating;
  int? userRatingsTotal;
  bool? permanentlyClosed;
  PlusCode? plusCode;
  OpeningHours? openingHours;

  Results(
      {this.geometry,
      this.icon,
      this.iconBackgroundColor,
      this.iconMaskBaseUri,
      this.name,
      this.photos,
      this.placeId,
      this.reference,
      this.scope,
      this.types,
      this.vicinity,
      this.businessStatus,
      this.rating,
      this.userRatingsTotal,
      this.permanentlyClosed,
      this.plusCode,
      this.openingHours});

  Results.fromJson(Map<String, dynamic> json) {
    geometry = json['geometry'] != null ? new Geometry.fromJson(json['geometry']) : null;
    icon = json['icon'];
    iconBackgroundColor = json['icon_background_color'];
    iconMaskBaseUri = json['icon_mask_base_uri'];
    name = json['name'];
    if (json['photos'] != null) {
      photos = <Photos>[];
      json['photos'].forEach((v) {
        photos!.add(new Photos.fromJson(v));
      });
    }
    placeId = json['place_id'];
    reference = json['reference'];
    scope = json['scope'];
    types = json['types'].cast<String>();
    vicinity = json['vicinity'];
    businessStatus = json['business_status'];
    rating = json['rating'];
    userRatingsTotal = json['user_ratings_total'];
    permanentlyClosed = json['permanently_closed'];
    plusCode = json['plus_code'] != null ? new PlusCode.fromJson(json['plus_code']) : null;
    openingHours = json['opening_hours'] != null ? new OpeningHours.fromJson(json['opening_hours']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.geometry != null) {
      data['geometry'] = this.geometry!.toJson();
    }
    data['icon'] = this.icon;
    data['icon_background_color'] = this.iconBackgroundColor;
    data['icon_mask_base_uri'] = this.iconMaskBaseUri;
    data['name'] = this.name;
    if (this.photos != null) {
      data['photos'] = this.photos!.map((v) => v.toJson()).toList();
    }
    data['place_id'] = this.placeId;
    data['reference'] = this.reference;
    data['scope'] = this.scope;
    data['types'] = this.types;
    data['vicinity'] = this.vicinity;
    data['business_status'] = this.businessStatus;
    data['rating'] = this.rating;
    data['user_ratings_total'] = this.userRatingsTotal;
    data['permanently_closed'] = this.permanentlyClosed;
    if (this.plusCode != null) {
      data['plus_code'] = this.plusCode!.toJson();
    }
    if (this.openingHours != null) {
      data['opening_hours'] = this.openingHours!.toJson();
    }
    return data;
  }
}

class Geometry {
  Location? location;
  Viewport? viewport;

  Geometry({this.location, this.viewport});

  Geometry.fromJson(Map<String, dynamic> json) {
    location = json['location'] != null ? new Location.fromJson(json['location']) : null;
    viewport = json['viewport'] != null ? new Viewport.fromJson(json['viewport']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.location != null) {
      data['location'] = this.location!.toJson();
    }
    if (this.viewport != null) {
      data['viewport'] = this.viewport!.toJson();
    }
    return data;
  }
}

class Location {
  double? lat;
  double? lng;

  Location({this.lat, this.lng});

  Location.fromJson(Map<String, dynamic> json) {
    lat = json['c'];
    lng = json['lng'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    return data;
  }
}

class Viewport {
  Location? northeast;
  Location? southwest;

  Viewport({this.northeast, this.southwest});

  Viewport.fromJson(Map<String, dynamic> json) {
    northeast = json['northeast'] != null ? new Location.fromJson(json['northeast']) : null;
    southwest = json['southwest'] != null ? new Location.fromJson(json['southwest']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.northeast != null) {
      data['northeast'] = this.northeast!.toJson();
    }
    if (this.southwest != null) {
      data['southwest'] = this.southwest!.toJson();
    }
    return data;
  }
}

class Photos {
  int? height;
  List<String>? htmlAttributions;
  String? photoReference;
  int? width;

  Photos({this.height, this.htmlAttributions, this.photoReference, this.width});

  Photos.fromJson(Map<String, dynamic> json) {
    height = json['height'];
    htmlAttributions = json['html_attributions'].cast<String>();
    photoReference = json['photo_reference'];
    width = json['width'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['height'] = this.height;
    data['html_attributions'] = this.htmlAttributions;
    data['photo_reference'] = this.photoReference;
    data['width'] = this.width;
    return data;
  }
}

class PlusCode {
  String? compoundCode;
  String? globalCode;

  PlusCode({this.compoundCode, this.globalCode});

  PlusCode.fromJson(Map<String, dynamic> json) {
    compoundCode = json['compound_code'];
    globalCode = json['global_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['compound_code'] = this.compoundCode;
    data['global_code'] = this.globalCode;
    return data;
  }
}

class OpeningHours {
  bool? openNow;

  OpeningHours({this.openNow});

  OpeningHours.fromJson(Map<String, dynamic> json) {
    openNow = json['open_now'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['open_now'] = this.openNow;
    return data;
  }
}
