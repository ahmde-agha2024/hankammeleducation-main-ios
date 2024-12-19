class DataResponseAbout {
  final int id;
  final String documentId;
  final String aboutapp;
  final String createdAt;
  final String updatedAt;
  final String publishedAt;

  DataResponseAbout({
    required this.id,
    required this.documentId,
    required this.aboutapp,
    required this.createdAt,
    required this.updatedAt,
    required this.publishedAt,
  });

  // Factory method لتحويل JSON إلى كائن Dart
  factory DataResponseAbout.fromJson(Map<String, dynamic> json) {
    return DataResponseAbout(
      id: json['id'],
      documentId: json['documentId'],
      aboutapp: json['about_app'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      publishedAt: json['publishedAt'],
    );
  }

  // Method لتحويل كائن Dart إلى JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'documentId': documentId,
      'about_app': aboutapp,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'publishedAt': publishedAt,
    };
  }
}
