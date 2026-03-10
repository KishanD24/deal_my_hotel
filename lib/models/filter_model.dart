import '../models/pagination_model.dart';

import 'dashBoard_response.dart';

class FilterResponse {
  Pagination? pagination;
  List<Property>? property;

  FilterResponse({this.pagination, this.property});

  FilterResponse.fromJson(Map<String, dynamic> json) {
    pagination = json['pagination'] != null ? new Pagination.fromJson(json['pagination']) : null;
    if (json['property'] != null) {
      property = <Property>[];
      json['property'].forEach((v) {
        property!.add(new Property.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.pagination != null) {
      data['pagination'] = this.pagination!.toJson();
    }
    if (this.property != null) {
      data['property'] = this.property!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

