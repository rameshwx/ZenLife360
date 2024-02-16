import 'dart:typed_data';

class HealthArticle {
  int? articleId;
  String? title;
  String? description;
  Uint8List? imageFile; // Use Uint8List for BLOB data
  DateTime? publishedDate;
  DateTime? lastUpdated;
  bool? deleteFlag;

  HealthArticle({
    this.articleId,
    this.title,
    this.description,
    this.imageFile,
    this.publishedDate,
    this.lastUpdated,
    this.deleteFlag,
  });

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'title': title,
      'description': description,
      'image_file': imageFile,
      'published_date': publishedDate?.toIso8601String(),
      'last_updated': lastUpdated?.toIso8601String(),
      'delete_flag': deleteFlag ?? false ? 1 : 0, // Provide a default value of false if deleteFlag is null
    };
    if (articleId != null) {
      map['article_id'] = articleId;
    }
    return map;
  }

  static HealthArticle fromMap(Map<String, dynamic> map) {
    return HealthArticle(
      articleId: map['article_id'],
      title: map['title'],
      description: map['description'],
      imageFile: map['image_file'],
      publishedDate: map['published_date'] is String ? DateTime.tryParse(map['published_date']) : null,
      lastUpdated: map['updated_at'] is String ? DateTime.tryParse(map['updated_at']) : null,
      deleteFlag: map['delete_flag'] == 1,
    );
  }



}
