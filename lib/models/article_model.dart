import 'article_response.dart';

class Article {
  int? id;
  String? name;
  List<Tags>? tags;
  String? description;
  int? status;
  String? articleImage;
  String? createdAt;
  String? updatedAt;

  Article({this.id, this.name, this.tags, this.description, this.status, this.articleImage, this.createdAt, this.updatedAt});

  Article.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    if (json['tags'] != null) {
      tags = <Tags>[];
      json['tags'].forEach((v) {
        tags!.add(new Tags.fromJson(v));
      });
    }
    description = json['description'];
    status = json['status'];
    articleImage = json['article_image'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    if (this.tags != null) {
      data['tags'] = this.tags!.map((v) => v.toJson()).toList();
    }
    data['description'] = this.description;
    data['status'] = this.status;
    data['article_image'] = this.articleImage;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
