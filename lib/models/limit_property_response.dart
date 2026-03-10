import 'pagination_model.dart';

class LimitPropertyResponse {
  Pagination? pagination;
  List<LimitPropertyModel>? data;

  LimitPropertyResponse({this.pagination, this.data});

  LimitPropertyResponse.fromJson(Map<String, dynamic> json) {
    pagination = json['pagination'] != null
        ? new Pagination.fromJson(json['pagination'])
        : null;
    if (json['data'] != null) {
      data = <LimitPropertyModel>[];
      json['data'].forEach((v) {
        data!.add(new LimitPropertyModel.fromJson(v));
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



class LimitPropertyModel {
  int? id;
  int? limit;
  int? price;
  String? priceFormat;
  String? type;
  String? createdAt;
  String? updatedAt;
  bool? select=false;

  LimitPropertyModel(
      {this.id,
        this.limit,
        this.price,
        this.priceFormat,
        this.type,
        this.createdAt,
        this.updatedAt,this.select});

  LimitPropertyModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    limit = json['limit'];
    price = json['price'];
    priceFormat = json['price_format'];
    type = json['type'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['limit'] = this.limit;
    data['price'] = this.price;
    data['price_format'] = this.priceFormat;
    data['type'] = this.type;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
