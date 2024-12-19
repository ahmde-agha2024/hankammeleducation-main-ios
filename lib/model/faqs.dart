class FAQ {
  final int id;
  final String documentId;
  final String question;
  final String answer;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime publishedAt;

  FAQ({
    required this.id,
    required this.documentId,
    required this.question,
    required this.answer,
    required this.createdAt,
    required this.updatedAt,
    required this.publishedAt,
  });

  factory FAQ.fromJson(Map<String, dynamic> json) {
    return FAQ(
      id: json['id'] ?? 0,
      documentId: json['documentId'] ?? '',
      question: json['question'] ?? 'لا يوجد سؤال',
      answer: json['answer'] ?? 'لا توجد إجابة',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime(2000, 1, 1),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime(2000, 1, 1),
      publishedAt: DateTime.tryParse(json['publishedAt'] ?? '') ?? DateTime(2000, 1, 1),
    );
  }
}

