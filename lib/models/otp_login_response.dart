import '../models/signUp_resonse.dart';

class SocialLoginResponse {
  bool? status;
  bool? isUserExist;
  String? message;
  UserModel? data;

  SocialLoginResponse({this.status, this.message, this.data, this.isUserExist});

  SocialLoginResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    isUserExist = json['is_user_exist'] != null ? json['is_user_exist'] : true;
    message = json['message'] == null ? null : json['message'];
    data = json['data'] != null ? new UserModel.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.isUserExist != null) {
      data['is_user_exist'] = this.isUserExist;
    }
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}
