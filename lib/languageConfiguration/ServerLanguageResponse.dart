// class ServerLanguageResponse {
//   bool? status;
//   int? currentVersionNo;
//   List<LanguageJsonData>? data;
//
//   ServerLanguageResponse({this.status, this.data, this.currentVersionNo});
//
//   ServerLanguageResponse.fromJson(Map<String, dynamic> json) {
//     status = json['status'];
//     currentVersionNo = json['version_code'];
//     if (json['data'] != null) {
//       data = <LanguageJsonData>[];
//       json['data'].forEach((v) {
//         data!.add(new LanguageJsonData.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['status'] = this.status;
//     data['version_code'] = this.currentVersionNo;
//     if (this.data != null) {
//       data['data'] = this.data!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
//
// class LanguageJsonData {
//   int? id;
//   String? languageName;
//   String? languageCode;
//   String? countryCode;
//   int? isRtl;
//   int? isDefaultLanguage;
//   List<ContentData>? contentData;
//   String? createdAt;
//   String? updatedAt;
//
//   LanguageJsonData({this.id, this.languageName, this.isRtl, this.contentData, this.isDefaultLanguage, this.createdAt, this.updatedAt, this.languageCode, this.countryCode});
//
//   LanguageJsonData.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     languageName = json['language_name'];
//     isDefaultLanguage = json['id_default_language'];
//     languageCode = json['language_code'];
//     countryCode = json['country_code'];
//     isRtl = json['is_rtl'];
//     if (json['contentdata'] != null) {
//       contentData = <ContentData>[];
//       json['contentdata'].forEach((v) {
//         contentData!.add(new ContentData.fromJson(v));
//       });
//     }
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['language_name'] = this.languageName;
//     data['country_code'] = this.countryCode;
//     data['language_code'] = this.languageCode;
//     data['id_default_language'] = this.isDefaultLanguage;
//     data['is_rtl'] = this.isRtl;
//     if (this.contentData != null) {
//       data['contentdata'] = this.contentData!.map((v) => v.toJson()).toList();
//     }
//     data['created_at'] = this.createdAt;
//     data['updated_at'] = this.updatedAt;
//     return data;
//   }
// }
//
// class ContentData {
//   int? keywordId;
//   String? keywordName;
//   String? keywordValue;
//
//   ContentData({this.keywordId, this.keywordName, this.keywordValue});
//
//   ContentData.fromJson(Map<String, dynamic> json) {
//     keywordId = json['keyword_id'];
//     keywordName = json['keyword_name'];
//     keywordValue = json['keyword_value'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['keyword_id'] = this.keywordId;
//     data['keyword_name'] = this.keywordName;
//     data['keyword_value'] = this.keywordValue;
//     return data;
//   }
// }
//
//


class ServerLanguageResponse {
  bool? status;
  int? currentVersionNo;
  List<LanguageJsonData>? data;

  ServerLanguageResponse({this.status, this.data, this.currentVersionNo});

  ServerLanguageResponse.fromJson(Map<String, dynamic> json) {
    status = _parseBool(json['status']);
    currentVersionNo = _parseInt(json['version_code']);

    if (json['data'] != null && json['data'] is List) {
      data = <LanguageJsonData>[];
      for (var v in json['data']) {
        if (v != null && v is Map<String, dynamic>) {
          data!.add(LanguageJsonData.fromJson(v));
        }
      }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['version_code'] = currentVersionNo;

    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }

    return data;
  }

  // Helper method to parse bool from dynamic value
  bool? _parseBool(dynamic value) {
    if (value == null) return null;
    if (value is bool) return value;
    if (value is String) {
      return value.toLowerCase() == 'true' || value == '1';
    }
    if (value is int) {
      return value == 1;
    }
    return null;
  }

  // Helper method to parse int from dynamic value
  int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) {
      return int.tryParse(value);
    }
    if (value is double) {
      return value.toInt();
    }
    return null;
  }
}

class LanguageJsonData {
  int? id;
  String? languageName;
  String? languageCode;
  String? countryCode;
  int? isRtl;
  int? isDefaultLanguage;
  List<ContentData>? contentData;
  String? createdAt;
  String? updatedAt;

  LanguageJsonData({
    this.id,
    this.languageName,
    this.isRtl,
    this.contentData,
    this.isDefaultLanguage,
    this.createdAt,
    this.updatedAt,
    this.languageCode,
    this.countryCode,
  });

  LanguageJsonData.fromJson(Map<String, dynamic> json) {
    id = _parseInt(json['id']);
    languageName = _parseString(json['language_name']);
    isDefaultLanguage = _parseInt(json['id_default_language'] ?? json['is_default_language']);
    languageCode = _parseString(json['language_code']);
    countryCode = _parseString(json['country_code']);
    isRtl = _parseInt(json['is_rtl']);

    if (json['contentdata'] != null && json['contentdata'] is List) {
      contentData = <ContentData>[];
      for (var v in json['contentdata']) {
        if (v != null && v is Map<String, dynamic>) {
          contentData!.add(ContentData.fromJson(v));
        }
      }
    }

    createdAt = _parseString(json['created_at']);
    updatedAt = _parseString(json['updated_at']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['language_name'] = languageName;
    data['country_code'] = countryCode;
    data['language_code'] = languageCode;
    data['id_default_language'] = isDefaultLanguage;
    data['is_rtl'] = isRtl;

    if (contentData != null) {
      data['contentdata'] = contentData!.map((v) => v.toJson()).toList();
    }

    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }

  // Helper method to parse string from dynamic value
  String? _parseString(dynamic value) {
    if (value == null) return null;
    if (value is String) return value;
    return value.toString();
  }

  // Helper method to parse int from dynamic value
  int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) {
      return int.tryParse(value);
    }
    if (value is double) {
      return value.toInt();
    }
    return null;
  }
}

class ContentData {
  int? keywordId;
  String? keywordName;
  String? keywordValue;

  ContentData({this.keywordId, this.keywordName, this.keywordValue});

  ContentData.fromJson(Map<String, dynamic> json) {
    keywordId = _parseInt(json['keyword_id']);
    keywordName = _parseString(json['keyword_name']);
    keywordValue = _parseString(json['keyword_value']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['keyword_id'] = keywordId;
    data['keyword_name'] = keywordName;
    data['keyword_value'] = keywordValue;
    return data;
  }

  // Helper method to parse string from dynamic value
  String? _parseString(dynamic value) {
    if (value == null) return null;
    if (value is String) return value;
    return value.toString();
  }

  // Helper method to parse int from dynamic value
  int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) {
      return int.tryParse(value);
    }
    if (value is double) {
      return value.toInt();
    }
    return null;
  }
}