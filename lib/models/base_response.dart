// class EPropertyBaseResponse {
//   String? message;
//
//   EPropertyBaseResponse({this.message});
//
//   EPropertyBaseResponse.fromJson(Map<String, dynamic> json) {
//     message = json['message'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['message'] = this.message;
//     return data;
//   }
// }

class EPropertyBaseResponse {
  String? message;
  bool? status;
  int? propertyId;

  EPropertyBaseResponse({this.message, this.propertyId, this.status});

  EPropertyBaseResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    propertyId = json['property_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['status'] = this.status;
    data['property_id'] = this.propertyId;
    return data;
  }
}
