
class QuizRoot {
  final int id;
  final String documentId;
  final String name;
  final bool randomSorting;
  final String createdAt;
  final String updatedAt;
  final String publishedAt;
  final List<Question> questions;


  QuizRoot({
    required this.id,
    required this.documentId,
    required this.name,
    required this.randomSorting,
    required this.createdAt,
    required this.updatedAt,
    required this.publishedAt,
    required this.questions,
  });

  factory QuizRoot.fromJson(Map<String, dynamic> json) {
    return QuizRoot(
      id: json['id'] ?? 0,
      documentId: json['documentId'] ?? '',
      name: json['name'] ?? '',
      randomSorting: json['random_sorting'] ?? false,
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      publishedAt: json['publishedAt'] ?? '',
      questions: (json['questions'] as List<dynamic>?)
          ?.map((question) => Question.fromJson(question))
          .toList() ??
          [],

    );
  }
}
class Question {
  final int id;
  final String documentId;
  final String questionTitle;
  final String type;
  final String createdAt;
  final String updatedAt;
  final String publishedAt;
  final List<Answer> answers;

  Question({
    required this.id,
    required this.documentId,
    required this.questionTitle,
    required this.type,
    required this.createdAt,
    required this.updatedAt,
    required this.publishedAt,
    required this.answers,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'] ?? 0,
      documentId: json['documentId'] ?? '',
      questionTitle: json['question_title'] ?? '',
      type: json['type'] ?? 'select one',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      publishedAt: json['publishedAt'] ?? '',
      answers: (json['Answers'] as List)
          .map((answer) => Answer.fromJson(answer))
          .toList(),
    );
  }
}

class Answer {
  final int id;
  final String title;
  final bool correctAnswer;
  final bool isColorAnswer;
  final String? color;
  final String uuid;

  Answer({
    required this.id,
    required this.title,
    required this.correctAnswer,
    required this.isColorAnswer,
    this.color,
    required this.uuid,
  });

  factory Answer.fromJson(Map<String, dynamic> json) {
    return Answer(
      id: json['id']??0,
      title: json['title']??'',
      correctAnswer: json['correct_answer']??false,
      isColorAnswer: json['is_color_answer']??false,
      color: json['color']??'',
      uuid: json['uuid']??'',
    );
  }
}






