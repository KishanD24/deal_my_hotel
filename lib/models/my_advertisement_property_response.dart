import 'pagination_model.dart';

class MyAdvertisementPropertyResponse {
  bool? status;
  Pagination? pagination;
  List<MyAdvertisementPropertyModel>? data;

  MyAdvertisementPropertyResponse({this.status, this.pagination, this.data});

  MyAdvertisementPropertyResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    pagination = json['pagination'] != null
        ? new Pagination.fromJson(json['pagination'])
        : null;
    if (json['data'] != null) {
      data = <MyAdvertisementPropertyModel>[];
      json['data'].forEach((v) {
        data!.add(new MyAdvertisementPropertyModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.pagination != null) {
      data['pagination'] = this.pagination!.toJson();
    }
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}


class MyAdvertisementPropertyModel {
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

  MyAdvertisementPropertyModel(
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
        this.propertyFor,
        this.advertisementProperty,
        this.advertisementPropertyDate});

  MyAdvertisementPropertyModel.fromJson(Map<String, dynamic> json) {
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
    advertisementProperty = json['advertisement_property'];
    advertisementPropertyDate = json['advertisement_property_date'] ?? "";
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
