import 'pagination_model.dart';

class ContactInfoDetailsResponse {
  Pagination? pagination;
  List<ContactInfoDetailsModel>? data;

  ContactInfoDetailsResponse({this.pagination, this.data});

  ContactInfoDetailsResponse.fromJson(Map<String, dynamic> json) {
    pagination = json['pagination'] != null
        ? new Pagination.fromJson(json['pagination'])
        : null;
    if (json['data'] != null) {
      data = <ContactInfoDetailsModel>[];
      json['data'].forEach((v) {
        data!.add(new ContactInfoDetailsModel.fromJson(v));
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

class ContactInfoDetailsModel {
  int? id;
  int? propertyId;
  String? propertyName;
  String? propertyImage;
  int? customerId;
  String? customerName;
  String? customerProfileImage;
  String? createdAt;
  String? updatedAt;

  ContactInfoDetailsModel(
      {this.id,
        this.propertyId,
        this.propertyName,
        this.propertyImage,
        this.customerId,
        this.customerName,
        this.customerProfileImage,
        this.createdAt,
        this.updatedAt});

  ContactInfoDetailsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    propertyId = json['property_id'];
    propertyName = json['property_name'];
    propertyImage = json['property_image'];
    customerId = json['customer_id'];
    customerName = json['customer_name'];
    customerProfileImage = json['customer_profile_image'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['property_id'] = this.propertyId;
    data['property_name'] = this.propertyName;
    data['property_image'] = this.propertyImage;
    data['customer_id'] = this.customerId;
    data['customer_name'] = this.customerName;
    data['customer_profile_image'] = this.customerProfileImage;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
