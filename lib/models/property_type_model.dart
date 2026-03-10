import 'pagination_model.dart';

class PropertyTypeResponse {
  bool? status;
  Pagination? pagination;
  List<PropertyTypeModel>? data;

  PropertyTypeResponse({this.status, this.pagination, this.data});

  PropertyTypeResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    pagination = json['pagination'] != null ? new Pagination.fromJson(json['pagination']) : null;
    if (json['data'] != null) {
      data = <PropertyTypeModel>[];
      json['data'].forEach((v) {
        data!.add(new PropertyTypeModel.fromJson(v));
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

class PropertyTypeModel {
  int? id;
  String? name;
  int? status;
  String? propertyTypeImage;
  String? createdAt;
  String? updatedAt;
  bool? select;

  PropertyTypeModel({
    this.id,
    this.name,
    this.status,
    this.propertyTypeImage,
    this.createdAt,
    this.updatedAt,
    this.select,
  });

  PropertyTypeModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    status = json['status'];
    propertyTypeImage = json['property_type_image'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    // select = json['select'];
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
