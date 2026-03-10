class AmenityDynamicModel {
  int? dynamicAmenityId;
  dynamic dynamicAmenityValue;
  // List<String>? dynamicAmenityValues;

  AmenityDynamicModel({
    this.dynamicAmenityId,
    this.dynamicAmenityValue,
    // this.dynamicAmenityValues,
  });

  AmenityDynamicModel.fromJson(Map<String, dynamic> json) {
    dynamicAmenityId = json['id'];
    dynamicAmenityValue = json['value'] == null ? null : json['value'];
    // dynamicAmenityValues = json['value'] == null ? null : json['value'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.dynamicAmenityId;
    data['value'] = this.dynamicAmenityValue;
    // data['value'] = this.dynamicAmenityValues;
    return data;
  }
}
