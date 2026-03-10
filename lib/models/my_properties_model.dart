
import 'dashBoard_response.dart';
import 'pagination_model.dart';

class MyPropertiesResponseModel {
  bool? status;
  Pagination? pagination;
  List<Property>? data;

  MyPropertiesResponseModel({this.status, this.pagination, this.data});

  MyPropertiesResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
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

class PropertyTypeList {
  int? id;
  String? title;
  bool? select;

  PropertyTypeList(this.id, this.title, this.select);
}