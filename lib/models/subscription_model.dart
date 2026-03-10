import 'pagination_model.dart';

class SubscriptionResponse {
  Pagination? pagination;
  List<SubscriptionModel>? data;

  SubscriptionResponse({this.pagination, this.data});

  SubscriptionResponse.fromJson(Map<String, dynamic> json) {
    pagination = json['pagination'] != null
        ? new Pagination.fromJson(json['pagination'])
        : null;
    if (json['data'] != null) {
      data = <SubscriptionModel>[];
      json['data'].forEach((v) {
        data!.add(new SubscriptionModel.fromJson(v));
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


class SubscriptionModel {
  int? id;
  String name;
  String durationUnit;
  int duration;
  num price;
  int property;
  int addProperty;
  int advertisement;
  int viewPropertyLimit;
  int addPropertyLimit;
  int advertisementLimit;
  int status;
  String description;
  String createdAt;
  String updatedAt;

  SubscriptionModel({
    this.id,
    this.name = "",
    this.durationUnit = "",
    this.duration = 0,
    this.price = 0,
    this.property = 0,
    this.addProperty = 0,
    this.advertisement = 0,
    this.viewPropertyLimit = 0,
    this.addPropertyLimit = 0,
    this.advertisementLimit = 0,
    this.status = 0,
    this.description = "",
    this.createdAt = "",
    this.updatedAt = "",
  });

  SubscriptionModel.fromJson(Map<String, dynamic> json)
      : id = _int(json['id']),
        name = _str(json['name']),
        durationUnit = _str(json['duration_unit']),
        duration = _int(json['duration']) ?? 0,
        price = _num(json['price']) ?? 0,
        property = _int(json['property']) ?? 0,
        addProperty = _int(json['add_property']) ?? 0,
        advertisement = _int(json['advertisement']) ?? 0,
        viewPropertyLimit = _int(json['view_property_limit']) ?? 0,
        addPropertyLimit = _int(json['add_property_limit']) ?? 0,
        advertisementLimit = _int(json['advertisement_limit']) ?? 0,
        status = _int(json['status']) ?? 0,
        description = _str(json['description']),
        createdAt = _str(json['created_at']),
        updatedAt = _str(json['updated_at']);

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'duration_unit': durationUnit,
    'duration': duration,
    'price': price,
    'property': property,
    'add_property': addProperty,
    'advertisement': advertisement,
    'view_property_limit': viewPropertyLimit,
    'add_property_limit': addPropertyLimit,
    'advertisement_limit': advertisementLimit,
    'status': status,
    'description': description,
    'created_at': createdAt,
    'updated_at': updatedAt,
  };
}

int _int(dynamic v) =>
    v == null ? 0 : int.tryParse(v.toString()) ?? 0;

String _str(dynamic v) =>
    v?.toString() ?? "";

num? _num(dynamic v) =>
    v == null ? null : num.tryParse(v.toString());

// class SubscriptionModel {
//   int? id;
//   String? name;
//   String? durationUnit;
//   int? duration;
//   num? price;
//   int? property;
//   int? addProperty;
//   int? advertisement;
//   int? viewPropertyLimit;
//   int? addPropertyLimit;
//   int? advertisementLimit;
//   int? status;
//   String? description;
//   String? createdAt;
//   String? updatedAt;
//
//   SubscriptionModel(
//       {this.id,
//         this.name,
//         this.durationUnit,
//         this.duration,
//         this.price,
//         this.property,
//         this.addProperty,
//         this.advertisement,
//         this.viewPropertyLimit,
//         this.addPropertyLimit,
//         this.advertisementLimit,
//         this.status,
//         this.description,
//         this.createdAt,
//         this.updatedAt});
//
//   SubscriptionModel.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     name = json['name'];
//     durationUnit = json['duration_unit'];
//     duration = json['duration'];
//     price = json['price'];
//     property = json['property'];
//     addProperty = json['add_property'];
//     advertisement = json['advertisement'];
//     viewPropertyLimit = json['view_property_limit'];
//     addPropertyLimit = json['add_property_limit'];
//     advertisementLimit = json['advertisement_limit'];
//     status = json['status'];
//     description = json['description'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['name'] = this.name;
//     data['duration_unit'] = this.durationUnit;
//     data['duration'] = this.duration;
//     data['price'] = this.price;
//     data['property'] = this.property;
//     data['add_property'] = this.addProperty;
//     data['advertisement'] = this.advertisement;
//     data['view_property_limit'] = this.viewPropertyLimit;
//     data['add_property_limit'] = this.addPropertyLimit;
//     data['advertisement_limit'] = this.advertisementLimit;
//     data['status'] = this.status;
//     data['description'] = this.description;
//     data['created_at'] = this.createdAt;
//     data['updated_at'] = this.updatedAt;
//     return data;
//   }
// }
