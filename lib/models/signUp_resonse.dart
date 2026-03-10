
class SignUpResponse {
  String? message;
  UserModel? data;

  SignUpResponse({this.message, this.data});

  SignUpResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'] == null ?null :new UserModel.fromJson(json['data'])  ;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class UserModel {
  String? firstName;
  String? lastName;
  String? username;
  String? email;
  String? userType;
  String? status;
  String? address;
  int? isAgent;
  int? isBuilder;
  String? displayName;
  String? updatedAt;
  String? createdAt;
  int? id;
  String? apiToken;
  String? profileImage;
  // List<Roles>? roles;
  List<Media>? media;
  String? contactNumber;
  String? phoneNumber;


  UserModel(
      {this.firstName,
      this.lastName,
      this.username,
      this.email,
      this.userType,
      this.status,
      this.address,
      this.isAgent,
      this.isBuilder,
      this.displayName,
      this.updatedAt,
      this.createdAt,
      this.id,
      this.apiToken,
      this.profileImage,
      // this.roles,
      this.media,
      this.contactNumber,
      this.phoneNumber});

  UserModel.fromJson(Map<String, dynamic> json) {
    firstName = json['first_name']== null ? null :json['first_name'];
    lastName = json['last_name']== null ? null : json['last_name'];
    username = json['username']== null ? null : json['username'];
    email = json['email']== null ? null :json['email'];
    userType = json['user_type']== null ? null : json['user_type'];
    status = json['status']== null ? null : json['status'];
    address = json['address']== null ? null : json['address'];
    isAgent = json['is_agent']== null ? null : json['is_agent'];
    isBuilder = json['is_builder']== null ? null :json['is_builder'];
    displayName = json['display_name']== null ? null :json['display_name'];
    updatedAt = json['updated_at']== null ? null :json['updated_at'];
    createdAt = json['created_at']== null ? null : json['created_at'];
    id = json['id']== null ? null :json['id'];
    apiToken = json['api_token'] == null ? null : json['api_token'];
    profileImage = json['profile_image']== null ? null :json['profile_image'];
    phoneNumber= json['phone_number']== null? null: json['phone_number'];
    // if (json['roles'] != null) {
    //   roles = <Roles>[];
    //   json['roles'].forEach((v) {
    //     roles!.add(new Roles.fromJson(v));
    //   });
    // }
    if (json['media'] != null) {
      media = <Media>[];
      json['media'].forEach((v) {
        media!.add(new Media.fromJson(v));
      });
    }
    contactNumber = json['contact_number'] == null ? null : json['contact_number'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['username'] = this.username;
    data['email'] = this.email;
    data['user_type'] = this.userType;
    data['status'] = this.status;
    data['address'] = this.address;
    data['is_agent'] = this.isAgent;
    data['is_builder'] = this.isBuilder;
    data['display_name'] = this.displayName;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    data['id'] = this.id;
    data['api_token'] = this.apiToken;
    data['profile_image'] = this.profileImage;
    data['phone_number'] = this.phoneNumber;
    // if (this.roles != null) {
    //   data['roles'] = this.roles!.map((v) => v.toJson()).toList();
    // }
    if (this.media != null) {
      data['media'] = this.media!.map((v) => v.toJson()).toList();
    }
    data['contact_number'] = this.contactNumber;

    return data;
  }
}


class Media {
  int? id;
  String? modelType;
  int? modelId;
  String? uuid;
  String? collectionName;
  String? name;
  String? fileName;
  String? mimeType;
  String? disk;
  String? conversionsDisk;
  int? size;
  // List<Null>? manipulations;
  // List<Null>? customProperties;
  // List<Null>? generatedConversions;
  // List<Null>? responsiveImages;
  int? orderColumn;
  String? createdAt;
  String? updatedAt;
  String? originalUrl;
  String? previewUrl;

  Media(
      {this.id,
        this.modelType,
        this.modelId,
        this.uuid,
        this.collectionName,
        this.name,
        this.fileName,
        this.mimeType,
        this.disk,
        this.conversionsDisk,
        this.size,
        // this.manipulations,
        // this.customProperties,
        // this.generatedConversions,
        // this.responsiveImages,
        this.orderColumn,
        this.createdAt,
        this.updatedAt,
        this.originalUrl,
        this.previewUrl});

  Media.fromJson(Map<String, dynamic> json) {
    id = json['id']== null ? null :json['id'] ;
    modelType = json['model_type']== null ? null : json['model_type'] ;
    modelId = json['model_id']== null ? null : json['model_id'] ;
    uuid = json['uuid']== null ? null : json['uuid'] ;
    collectionName = json['collection_name']== null ? null : json['collection_name'] ;
    name = json['name']== null ? null :json['name'] ;
    fileName = json['file_name']== null ? null :json['file_name'] ;
    mimeType = json['mime_type']== null ? null : json['mime_type'] ;
    disk = json['disk']== null ? null : json['disk'] ;
    conversionsDisk = json['conversions_disk']== null ? null :  json['conversions_disk'];
    size = json['size']== null ? null : json['size'] ;
    // if (json['manipulations'] != null) {
    //   manipulations = <Null>[];
    //   json['manipulations'].forEach((v) {
    //     manipulations!.add(new Null.fromJson(v));
    //   });
    // }
    // if (json['custom_properties'] != null) {
    //   customProperties = <Null>[];
    //   json['custom_properties'].forEach((v) {
    //     customProperties!.add(new Null.fromJson(v));
    //   });
    // }
    // if (json['generated_conversions'] != null) {
    //   generatedConversions = <Null>[];
    //   json['generated_conversions'].forEach((v) {
    //     generatedConversions!.add(new Null.fromJson(v));
    //   });
    // }
    // if (json['responsive_images'] != null) {
    //   responsiveImages = <Null>[];
    //   json['responsive_images'].forEach((v) {
    //     responsiveImages!.add(new Null.fromJson(v));
    //   });
    // }
    orderColumn = json['order_column']== null ? null :json['order_column'] ;
    createdAt = json['created_at']== null ? null :  json['created_at'];
    updatedAt = json['updated_at']== null ? null : json['updated_at'] ;
    originalUrl = json['original_url']== null ? null : json['original_url'] ;
    previewUrl = json['preview_url']== null ? null :json['preview_url'] ;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['model_type'] = this.modelType;
    data['model_id'] = this.modelId;
    data['uuid'] = this.uuid;
    data['collection_name'] = this.collectionName;
    data['name'] = this.name;
    data['file_name'] = this.fileName;
    data['mime_type'] = this.mimeType;
    data['disk'] = this.disk;
    data['conversions_disk'] = this.conversionsDisk;
    data['size'] = this.size;
    // if (this.manipulations != null) {
    //   data['manipulations'] =
    //       this.manipulations!.map((v) => v.toJson()).toList();
    // }
    // if (this.customProperties != null) {
    //   data['custom_properties'] =
    //       this.customProperties!.map((v) => v.toJson()).toList();
    // }
    // if (this.generatedConversions != null) {
    //   data['generated_conversions'] =
    //       this.generatedConversions!.map((v) => v.toJson()).toList();
    // }
    // if (this.responsiveImages != null) {
    //   data['responsive_images'] =
    //       this.responsiveImages!.map((v) => v.toJson()).toList();
    // }
    data['order_column'] = this.orderColumn;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['original_url'] = this.originalUrl;
    data['preview_url'] = this.previewUrl;
    return data;
  }
}

//
// class Roles {
//   int? id;
//   String? name;
//   String? guardName;
//   int? status;
//   String? createdAt;
//   String? updatedAt;
//   Pivot? pivot;
//
//   Roles({this.id, this.name, this.guardName, this.status, this.createdAt, this.updatedAt, this.pivot});
//
//   Roles.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     name = json['name'];
//     guardName = json['guard_name'];
//     status = json['status'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//     pivot = json['pivot'] != null ? new Pivot.fromJson(json['pivot']) : null;
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['name'] = this.name;
//     data['guard_name'] = this.guardName;
//     data['status'] = this.status;
//     data['created_at'] = this.createdAt;
//     data['updated_at'] = this.updatedAt;
//     if (this.pivot != null) {
//       data['pivot'] = this.pivot!.toJson();
//     }
//     return data;
//   }
// }
//
// class Pivot {
//   int? modelId;
//   int? roleId;
//   String? modelType;
//
//   Pivot({this.modelId, this.roleId, this.modelType});
//
//   Pivot.fromJson(Map<String, dynamic> json) {
//     modelId = json['model_id'];
//     roleId = json['role_id'];
//     modelType = json['model_type'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['model_id'] = this.modelId;
//     data['role_id'] = this.roleId;
//     data['model_type'] = this.modelType;
//     return data;
//   }
// }
