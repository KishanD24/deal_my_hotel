

import 'dashBoard_response.dart';

class SearchResponse {
  bool? status;
  List<Property>? propertyData;
  List<Property>? nearByProperty;

  SearchResponse({this.status, this.propertyData, this.nearByProperty});

  SearchResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      propertyData = <Property>[];
      json['data'].forEach((v) {
        propertyData!.add(new Property.fromJson(v));
      });
    }
    if (json['near_by_property'] != null) {
      nearByProperty = <Property>[];
      json['near_by_property'].forEach((v) {
        nearByProperty!.add(new Property.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.propertyData != null) {
      data['data'] = this.propertyData!.map((v) => v.toJson()).toList();
    }
    if (this.nearByProperty != null) {
      data['near_by_property'] =
          this.nearByProperty!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class NearByProperty {
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

  NearByProperty(
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
        this.propertyFor});

  NearByProperty.fromJson(Map<String, dynamic> json) {
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
    propertyImage = json['property_image'];
    isFavourite = json['is_favourite'];
    propertyTypeId = json['property_type_id'];
    propertyType = json['property_type'];
    propertyFor = json['property_for'];
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
    return data;
  }
}
