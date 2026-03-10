import '../models/pagination_model.dart';

class PaymentListModel {
  Pagination? pagination;
  List<PaymentModel>? data;

  PaymentListModel({this.pagination, this.data});

  PaymentListModel.fromJson(Map<String, dynamic> json) {
    pagination = json['pagination'] != null
        ? new Pagination.fromJson(json['pagination'])
        : null;
    if (json['data'] != null) {
      data = <PaymentModel>[];
      json['data'].forEach((v) {
        data!.add(new PaymentModel.fromJson(v));
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


class PaymentModel {
  int? id;
  String? title;
  String? type;
  int? status;
  int? isTest;
  LiveValue? testValue;
  LiveValue? liveValue;
  String? gatewayImage;
  String? createdAt;
  String? updatedAt;

  PaymentModel(
      {this.id,
        this.title,
        this.type,
        this.status,
        this.isTest,
        this.testValue,
        this.liveValue,
        this.gatewayImage,
        this.createdAt,
        this.updatedAt});

  PaymentModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    type = json['type'];
    status = json['status'];
    isTest = json['is_test'];
    testValue = json['test_value'] != null
        ? new LiveValue.fromJson(json['test_value'])
        : null;
    liveValue = json['live_value'] != null
        ? new LiveValue.fromJson(json['live_value'])
        : null;
    gatewayImage = json['gateway_image'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['type'] = this.type;
    data['status'] = this.status;
    data['is_test'] = this.isTest;
    if (this.testValue != null) {
      data['test_value'] = this.testValue!.toJson();
    }
    if (this.liveValue != null) {
      data['live_value'] = this.liveValue!.toJson();
    }
    data['gateway_image'] = this.gatewayImage;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class TestValue {
  String? url;
  String? secretKey;
  String? publishableKey;

  TestValue({this.url, this.secretKey, this.publishableKey});

  TestValue.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    secretKey = json['secret_key'];
    publishableKey = json['publishable_key'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    data['secret_key'] = this.secretKey;
    data['publishable_key'] = this.publishableKey;
    return data;
  }
}


class LiveValue {
  String? publishableKey;
  String? url;
  String? secretId;
  String? keyId;
  String? publicKey;
  String? secretKey;
  String? tokenizationKey;
  String? accessToken;
  String? encryptionKey;
  String? profileId;
  String? serverKey;
  String? clientKey;
  String? merchantId;
  String? merchantKey;

  LiveValue({
    this.publishableKey,
    this.secretKey,
    this.url,
    this.secretId,
    this.keyId,
    this.publicKey,
    this.tokenizationKey,
    this.accessToken,
    this.encryptionKey,
    this.profileId,
    this.serverKey,
    this.clientKey,
    this.merchantId,
    this.merchantKey,
  });

  factory LiveValue.fromJson(Map<String, dynamic> json) {
    return LiveValue(
      publishableKey: json['publishable_key'],
      secretKey: json['secret_key'],
      url: json['url'],
      secretId: json['secret_id'],
      keyId: json['key_id'],
      publicKey: json['public_key'],
      tokenizationKey: json['tokenization_key'],
      accessToken: json['access_token'],
      encryptionKey: json['encryption_key'],
      profileId: json['profile_id'],
      serverKey: json['server_key'],
      clientKey: json['client_key'],
      merchantId: json['merchant_id'],
      merchantKey: json['merchant_key'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['publishable_key'] = this.publishableKey;
    data['secret_key'] = this.secretKey;
    data['url'] = this.url;
    data['secret_id'] = this.secretId;
    data['key_id'] = this.keyId;
    data['public_key'] = this.publicKey;
    data['tokenization_key'] = this.tokenizationKey;
    data['access_token'] = this.accessToken;
    data['encryption_key'] = this.encryptionKey;
    data['profile_id'] = this.profileId;
    data['server_key'] = this.serverKey;
    data['client_key'] = this.clientKey;
    data['merchant_id'] = this.merchantId;
    data['merchant_key'] = this.merchantKey;

    return data;
  }
}
