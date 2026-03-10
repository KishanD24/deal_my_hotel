import 'dashBoard_response.dart';
import 'pagination_model.dart';

class FavouritePropertyModel {
  Pagination? pagination;
  List<Property>? data;

  FavouritePropertyModel({this.pagination, this.data});

  FavouritePropertyModel.fromJson(Map<String, dynamic> json) {
    pagination = json['pagination'] != null ? new Pagination.fromJson(json['pagination']) : null;
    if (json['data'] != null) {
      data = <Property>[];
      json['data'].forEach((v) {
        data!.add(new Property.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.pagination != null) {
      data['pagination'] = this.pagination!.toJson();
    }
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

// class FavouriteProperty {
//   int? id;
//   String? name;
//   int? categoryId;
//   String? category;
//   int? propertyTypeId;
//   String? propertyType;
//   int? price;
//   int? furnishedType;
//   int? sallerType;
//   int? propertyFor;
//   int? ageOfProperty;
//   int? maintenance;
//   int? securityDeposit;
//   int? brokerage;
//   int? bhk;
//   String? sqft;
//   String? description;
//   List<AmenityValue>? amenityValue;
//   String? country;
//   String? state;
//   String? city;
//   String? latitude;
//   String? longitude;
//   String? address;
//   String? videoUrl;
//   int? status;
//   String? propertyImage;
//
//   // List<PropertyGallery>? propertyGallery;
//   Customer? customer;
//   String? createdAt;
//   String? updatedAt;
//   int? isFavourite;
//
//   FavouriteProperty(
//       {this.id,
//       this.name,
//       this.categoryId,
//       this.category,
//       this.propertyTypeId,
//       this.propertyType,
//       this.price,
//       this.furnishedType,
//       this.sallerType,
//       this.propertyFor,
//       this.ageOfProperty,
//       this.maintenance,
//       this.securityDeposit,
//       this.brokerage,
//       this.bhk,
//       this.sqft,
//       this.description,
//       this.amenityValue,
//       this.country,
//       this.state,
//       this.city,
//       this.latitude,
//       this.longitude,
//       this.address,
//       this.videoUrl,
//       this.status,
//       this.propertyImage,
//       // this.propertyGallery,
//       this.customer,
//       this.createdAt,
//       this.updatedAt,
//       this.isFavourite});
//
//   FavouriteProperty.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     name = json['name'];
//     categoryId = json['category_id'];
//     category = json['category'];
//     propertyTypeId = json['property_type_id'];
//     propertyType = json['property_type'];
//     price = json['price'];
//     furnishedType = json['furnished_type'];
//     sallerType = json['saller_type'];
//     propertyFor = json['property_for'];
//     ageOfProperty = json['age_of_property'];
//     maintenance = json['maintenance'];
//     securityDeposit = json['security_deposit'];
//     brokerage = json['brokerage'];
//     bhk = json['bhk'];
//     sqft = json['sqft'] == null ? null : json['sqft'];
//     description = json['description'] == null ? null : json['description'];
//     if (json['amenity_value'] != null) {
//       amenityValue = <AmenityValue>[];
//       json['amenity_value'].forEach((v) {
//         amenityValue!.add(new AmenityValue.fromJson(v));
//       });
//     }
//     country = json['country'];
//     state = json['state'];
//     city = json['city'];
//     latitude = json['latitude'];
//     longitude = json['longitude'];
//     address = json['address'];
//     videoUrl = json['video_url'];
//     status = json['status'];
//     propertyImage = json['property_image'];
//     // if (json['property_gallery'] != null) {
//     //   propertyGallery = <PropertyGallery>[];
//     //   json['property_gallery'].forEach((v) {
//     //     propertyGallery!.add(new PropertyGallery.fromJson(v));
//     //   });
//     // }
//     customer = json['customer'] != null ? new Customer.fromJson(json['customer']) : null;
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//     isFavourite = json['is_favourite'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['name'] = this.name;
//     data['category_id'] = this.categoryId;
//     data['category'] = this.category;
//     data['property_type_id'] = this.propertyTypeId;
//     data['property_type'] = this.propertyType;
//     data['price'] = this.price;
//     data['furnished_type'] = this.furnishedType;
//     data['saller_type'] = this.sallerType;
//     data['property_for'] = this.propertyFor;
//     data['age_of_property'] = this.ageOfProperty;
//     data['maintenance'] = this.maintenance;
//     data['security_deposit'] = this.securityDeposit;
//     data['brokerage'] = this.brokerage;
//     data['bhk'] = this.bhk;
//     data['sqft'] = this.sqft;
//     data['description'] = this.description;
//     if (this.amenityValue != null) {
//       data['amenity_value'] = this.amenityValue!.map((v) => v.toJson()).toList();
//     }
//     data['country'] = this.country;
//     data['state'] = this.state;
//     data['city'] = this.city;
//     data['latitude'] = this.latitude;
//     data['longitude'] = this.longitude;
//     data['address'] = this.address;
//     data['video_url'] = this.videoUrl;
//     data['status'] = this.status;
//     data['property_image'] = this.propertyImage;
//     // if (this.propertyGallery != null) {
//     //   data['property_gallery'] =
//     //       this.propertyGallery!.map((v) => v.toJson()).toList();
//     // }
//     if (this.customer != null) {
//       data['customer'] = this.customer!.toJson();
//     }
//     data['created_at'] = this.createdAt;
//     data['updated_at'] = this.updatedAt;
//     data['is_favourite'] = this.isFavourite;
//     return data;
//   }
// }

class FavouriteProperty {
  int? id;
  String? name;
  int? categoryId;
  String? category;
  String? categoryImage;
  int? propertyTypeId;
  String? propertyType;
  int? price;
  int? furnishedType;
  int? sallerType;
  int? propertyFor;
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
  // List<PropertyGallaryArray>? propertyGallaryArray;
  String? createdAt;
  String? updatedAt;
  int? isFavourite;
  int? advertisementProperty;
  String? advertisementPropertyDate;

  FavouriteProperty(
      {this.id,
        this.name,
        this.categoryId,
        this.category,
        this.categoryImage,
        this.propertyTypeId,
        this.propertyType,
        this.price,
        this.furnishedType,
        this.sallerType,
        this.propertyFor,
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
        // this.propertyGallaryArray,
        this.createdAt,
        this.updatedAt,
        this.isFavourite,
        this.advertisementProperty,
        this.advertisementPropertyDate
      });

  FavouriteProperty.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    categoryId = json['category_id'];
    category = json['category'];
    categoryImage = json['category_image'];
    propertyTypeId = json['property_type_id'];
    propertyType = json['property_type'];
    price = json['price'];
    furnishedType = json['furnished_type'];
    sallerType = json['saller_type'];
    propertyFor = json['property_for'];
    ageOfProperty = json['age_of_property'];
    maintenance = json['maintenance'];
    securityDeposit = json['security_deposit'];
    brokerage = json['brokerage'];
    bhk = json['bhk'];
    sqft = json['sqft'];
    description = json['description'];
    country = json['country'];
    state = json['state'];
    city = json['city'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    address = json['address'];
    videoUrl = json['video_url'];
    status = json['status'];
    premiumProperty = json['premium_property'];
    propertyImage = json['property_image'];
    propertyGallary = json['property_gallary'];
    // if (json['property_gallary_array'] != null) {
    //   propertyGallaryArray = <PropertyGallaryArray>[];
    //   json['property_gallary_array'].forEach((v) {
    //     propertyGallaryArray!.add(new PropertyGallaryArray.fromJson(v));
    //   });
    // }
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    isFavourite = json['is_favourite'];
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
    data['property_type_id'] = this.propertyTypeId;
    data['property_type'] = this.propertyType;
    data['price'] = this.price;
    data['furnished_type'] = this.furnishedType;
    data['saller_type'] = this.sallerType;
    data['property_for'] = this.propertyFor;
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
    // if (this.propertyGallaryArray != null) {
    //   data['property_gallary_array'] =
    //       this.propertyGallaryArray!.map((v) => v.toJson()).toList();
    // }
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['is_favourite'] = this.isFavourite;
    data['advertisement_property'] = this.advertisementProperty;
    data['advertisement_property_date'] = this.advertisementPropertyDate;
    return data;
  }
}

class AmenityValue {
  int? id;
  String? name;
  String? value;
  List<dynamic>? values;

  AmenityValue({this.id, this.name, this.value, this.values});

  AmenityValue.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    value = json['value'];
    values = json['values'] == null ? null : json['values'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['value'] = this.value;
    data['values'] = this.values;
    return data;
  }
}

class Customer {
  int? id;
  String? firstName;
  String? lastName;
  String? email;
  String? contactNumber;
  String? address;
  String? userType;

  Customer({this.id, this.firstName, this.lastName, this.email, this.contactNumber, this.address, this.userType});

  Customer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    contactNumber = json['contact_number'];
    address = json['address'];
    userType = json['user_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['email'] = this.email;
    data['contact_number'] = this.contactNumber;
    data['address'] = this.address;
    data['user_type'] = this.userType;
    return data;
  }
}

class PropertyGallery {
  String? images;

  PropertyGallery({this.images});

  PropertyGallery.fromJson(Map<String, dynamic> json) {
    images = json['images'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['images'] = this.images;

    return data;
  }
}
