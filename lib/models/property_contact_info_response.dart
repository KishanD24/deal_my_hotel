import 'pagination_model.dart';

class PropertyContactInfoResponse {
  Pagination? pagination;
  List<ContactInfoModel>? data;

  PropertyContactInfoResponse({this.pagination, this.data});

  PropertyContactInfoResponse.fromJson(Map<String, dynamic> json) {
    pagination = json['pagination'] != null ? new Pagination.fromJson(json['pagination']) : null;
    if (json['data'] != null) {
      data = <ContactInfoModel>[];
      json['data'].forEach((v) {
        data!.add(new ContactInfoModel.fromJson(v));
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

class ContactInfoModel {
  int? id;
  int? propertyId;
  int? customerId;
  String? propertyName;
  String? customerName;
  String? customerProfileImage;
  String? contactNumber;
  String? createdAt;
  String? updatedAt;

  ContactInfoModel({this.id, this.customerId, this.customerName, this.customerProfileImage, this.createdAt, this.updatedAt});

  ContactInfoModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    propertyId = json['property_id'];
    customerId = json['customer_id'];
    propertyName = json['property_name'];
    customerName = json['customer_name'];
    customerProfileImage = json['customer_profile_image'];
    contactNumber = json['contact_number'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['property_id'] = this.propertyId;
    data['customer_id'] = this.customerId;
    data['customer_name'] = this.customerName;
    data['property_name'] = this.propertyName;
    data['contact_number'] = this.contactNumber;
    data['customer_profile_image'] = this.customerProfileImage;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
