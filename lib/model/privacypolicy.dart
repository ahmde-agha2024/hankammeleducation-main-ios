class DataResponse {
  final int id;
  final String documentId;
  final String content;
  final String createdAt;
  final String updatedAt;
  final String publishedAt;

  DataResponse({
    required this.id,
    required this.documentId,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    required this.publishedAt,
  });

  // Factory method لتحويل JSON إلى كائن Dart
  factory DataResponse.fromJson(Map<String, dynamic> json) {
    return DataResponse(
      id: json['id'],
      documentId: json['documentId'],
      content: json['content'],
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
      'content': content,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'publishedAt': publishedAt,
    };
  }
}
