class SubCategoryModel {
  final int id;
  final String documentId;
  final String title;
  final String? createdAt;
  final String? updatedAt;
  final String? publishedAt;
  final Category category;
  final List<Course> courses;

  SubCategoryModel({
    required this.id,
    required this.documentId,
    required this.title,
    this.createdAt,
    this.updatedAt,
    this.publishedAt,
    required this.category,
    required this.courses,
  });

  // تحويل من JSON إلى كائن Dart
  factory SubCategoryModel.fromJson(Map<String, dynamic> json) {
    return SubCategoryModel(
      id: json['id'] as int,
      documentId: json['documentId'] as String,
      title: json['title'] as String,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      publishedAt: json['publishedAt'] as String?,
      category: Category.fromJson(json['category']),
      courses: (json['courses'] as List<dynamic>)
          .map((e) => Course.fromJson(e))
          .toList(),
    );
  }

  // تحويل من كائن Dart إلى JSON
  Map<String, dynamic> toJson() => {
    'id': id,
    'documentId': documentId,
    'title': title,
    'createdAt': createdAt,
    'updatedAt': updatedAt,
    'publishedAt': publishedAt,
    'category': category.toJson(),
    'courses': courses.map((e) => e.toJson()).toList(),
  };
}

class Category {
  final int id;
  final String documentId;
  final String title;
  final String? createdAt;
  final String? updatedAt;
  final String? publishedAt;

  Category({
    required this.id,
    required this.documentId,
    required this.title,
    this.createdAt,
    this.updatedAt,
    this.publishedAt,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as int,
      documentId: json['documentId'] as String,
      title: json['title'] as String,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      publishedAt: json['publishedAt'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'documentId': documentId,
    'title': title,
    'createdAt': createdAt,
    'updatedAt': updatedAt,
    'publishedAt': publishedAt,
  };
}

class Course {
  final int id;
  final String documentId;
  final String title;
  final String? subTitle;
  final String? courseFlag;
  final String? description;
  final String? createdAt;
  final String? updatedAt;
  final String? publishedAt;

  Course({
    required this.id,
    required this.documentId,
    required this.title,
    this.subTitle,
    this.courseFlag,
    this.description,
    this.createdAt,
    this.updatedAt,
    this.publishedAt,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'] as int,
      documentId: json['documentId'] as String,
      title: json['title'] as String,
      subTitle: json['sub_title'] as String?,
      courseFlag: json['course_flag'] as String?,
      description: json['description'] as String?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      publishedAt: json['publishedAt'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'documentId': documentId,
    'title': title,
    'sub_title': subTitle,
    'course_flag': courseFlag,
    'description': description,
    'createdAt': createdAt,
    'updatedAt': updatedAt,
    'publishedAt': publishedAt,
  };
}
