class HomeModel {
  final int id;
  final String? documentId;
  final String? title;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? publishedAt;
  final ImagePer? imagePerson;
  final List<SubCategory>? subCategories;

  HomeModel({
    required this.id,
    this.documentId,
    this.title,
    this.createdAt,
    this.updatedAt,
    this.publishedAt,
    this.imagePerson,
    this.subCategories,
  });

  // تحليل JSON إلى نموذج
  factory HomeModel.fromJson(Map<String, dynamic> json) {
    return HomeModel(
      id: json['id'] as int,
      documentId: json['documentId'] as String?,
      title: json['title'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
      publishedAt: json['publishedAt'] != null
          ? DateTime.parse(json['publishedAt'])
          : null,
      imagePerson: json['image'] != null ? ImagePer.fromJson(json['image']) : null,
      subCategories: json['sub_categories'] != null
          ? (json['sub_categories'] as List)
          .map((e) => SubCategory.fromJson(e))
          .toList()
          : null,
    );
  }

  // تحويل النموذج إلى JSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    if (documentId != null) data['documentId'] = documentId;
    if (title != null) data['title'] = title;
    if (createdAt != null) data['createdAt'] = createdAt?.toIso8601String();
    if (updatedAt != null) data['updatedAt'] = updatedAt?.toIso8601String();
    if (publishedAt != null) data['publishedAt'] = publishedAt?.toIso8601String();
    if (imagePerson != null) data['image'] = imagePerson?.toJson();
    if (subCategories != null) {
      data['sub_categories'] = subCategories?.map((e) => e.toJson()).toList();
    }
    return data;
  }
}

class ImagePer {
  final int id;
  final String? documentId;
  final String? name;
  final String? url;

  ImagePer({
    required this.id,
    this.documentId,
    this.name,
    this.url,
  });

  factory ImagePer.fromJson(Map<String, dynamic> json) {
    return ImagePer(
      id: json['id'] as int,
      documentId: json['documentId'] as String?,
      name: json['name'] as String?,
      url: json['url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    if (documentId != null) data['documentId'] = documentId;
    if (name != null) data['name'] = name;
    if (url != null) data['url'] = url;
    return data;
  }
}

class SubCategory {
  final int id;
  final String? documentId;
  final String? title;

  SubCategory({
    required this.id,
    this.documentId,
    this.title,
  });

  factory SubCategory.fromJson(Map<String, dynamic> json) {
    return SubCategory(
      id: json['id'] as int,
      documentId: json['documentId'] as String?,
      title: json['title'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    if (documentId != null) data['documentId'] = documentId;
    if (title != null) data['title'] = title;
    return data;
  }
}
