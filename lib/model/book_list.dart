class BookListModel {
  final int id;
  final String? documentId;
  final String? title;
  final String? subTitle;
  final String? courseFlag;
  final String? description;
  final String? createdAt;
  final String? updatedAt;
  final String? publishedAt;
  final CourseImage? courseImage;
  final List<EnrolledUser> enrolledusers;
  final bool enrolled;
  final int? courseCompletion;
  final List<Instructor> instructors;
  final List<String> learnBulletPoints;
  final List<Curriculum> curriculum;
  final List<Announcement> announcements;
  final SubCategory? subCategory;
  final List<String> requirements;
  final List<Quiz> quiz;
  BookListModel({
    required this.id,
    this.documentId,
    this.title,
    this.subTitle,
    this.courseFlag,
    this.description,
    this.createdAt,
    this.updatedAt,
    this.publishedAt,
    this.courseImage,
    required this.instructors,
    required this.enrolled,
    required this.enrolledusers,
    required this.learnBulletPoints,
    required this.curriculum,
    required this.announcements,
    this.subCategory,
    required this.requirements,
    required this.quiz,
    required this.courseCompletion
  });

  factory BookListModel.fromJson(Map<String, dynamic> json) {
    return BookListModel(
      id: json['id'] as int,
      documentId: json['documentId'] as String?,
      title: json['title'] as String?,
      subTitle: json['sub_title'] as String?,
      courseFlag: json['course_flag'] as String?,
      description: json['description'] ?? "",
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      publishedAt: json['publishedAt'] as String?,
      enrolled: json['enrolled'] ?? false,
      courseCompletion: json['course_completion'] ?? 0,
      courseImage: json['course_image'] != null
          ? CourseImage.fromJson(json['course_image'] as Map<String, dynamic>)
          : null,
      instructors: (json['instructors'] as List<dynamic>? ?? [])
          .map((item) => Instructor.fromJson(item as Map<String, dynamic>))
          .toList(),
      enrolledusers: (json['enrolled_users'] as List<dynamic>? ?? [])
          .map((item) => EnrolledUser.fromJson(item as Map<String, dynamic>))
          .toList(),
      learnBulletPoints: (json['learn_bullet_points'] as List<dynamic>? ?? [])
          .map((item) => item.toString())
          .toList(),
      curriculum: (json['curriculum'] as List<dynamic>? ?? [])
          .map((item) => Curriculum.fromJson(item as Map<String, dynamic>))
          .toList(),
      announcements: (json['announcements'] as List<dynamic>? ?? [])
          .map((item) => Announcement.fromJson(item as Map<String, dynamic>))
          .toList(),
      subCategory: json['sub_category'] != null
          ? SubCategory.fromJson(json['sub_category'] as Map<String, dynamic>)
          : null,
      requirements: (json['requirements'] as List<dynamic>? ?? [])
          .map((item) => item.toString())
          .toList(),
      quiz: (json['quizzes'] as List<dynamic>? ?? [])
          .map((item) => Quiz.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}

class CourseImage {
  final int id;
  final String? documentId;
  final String? name;
  final String? alternativeText;
  final String? caption;
  final int? width;
  final int? height;
  final String? url;
  final Formats? formats;
  final String? createdAt;
  final String? updatedAt;

  CourseImage({
    required this.id,
    this.documentId,
    this.name,
    this.alternativeText,
    this.caption,
    this.width,
    this.height,
    this.url,
    this.formats,
    this.createdAt,
    this.updatedAt,
  });

  factory CourseImage.fromJson(Map<String, dynamic> json) {
    return CourseImage(
      id: json['id'] as int,
      documentId: json['documentId'] as String?,
      name: json['name'] as String?,
      alternativeText: json['alternativeText'] as String?,
      caption: json['caption'] as String?,
      width: json['width'] as int?,
      height: json['height'] as int?,
      url: json['url'] as String?,
      formats: json['formats'] != null
          ? Formats.fromJson(json['formats'] as Map<String, dynamic>)
          : null,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );
  }
}

class Formats {
  final ImageFormat? large;
  final ImageFormat? medium;
  final ImageFormat? small;
  final ImageFormat? thumbnail;

  Formats({
    this.large,
    this.medium,
    this.small,
    this.thumbnail,
  });

  factory Formats.fromJson(Map<String, dynamic> json) {
    return Formats(
      large: json['large'] != null
          ? ImageFormat.fromJson(json['large'] as Map<String, dynamic>)
          : null,
      medium: json['medium'] != null
          ? ImageFormat.fromJson(json['medium'] as Map<String, dynamic>)
          : null,
      small: json['small'] != null
          ? ImageFormat.fromJson(json['small'] as Map<String, dynamic>)
          : null,
      thumbnail: json['thumbnail'] != null
          ? ImageFormat.fromJson(json['thumbnail'] as Map<String, dynamic>)
          : null,
    );
  }
}

class ImageFormat {
  final String? ext;
  final String? url;
  final int? width;
  final int? height;
  final double? size;

  ImageFormat({
    this.ext,
    this.url,
    this.width,
    this.height,
    this.size,
  });

  factory ImageFormat.fromJson(Map<String, dynamic> json) {
    return ImageFormat(
      ext: json['ext'] as String?,
      url: json['url'] as String?,
      width: json['width'] as int?,
      height: json['height'] as int?,
      size: (json['size'] as num?)?.toDouble(),
    );
  }
}

class Instructor {
  final int id;
  final String? documentId;
  final String? name;

  Instructor({
    required this.id,
    this.documentId,
    this.name,
  });

  factory Instructor.fromJson(Map<String, dynamic> json) {
    return Instructor(
      id: json['id'] as int,
      documentId: json['documentId'] as String?,
      name: json['name'] as String?,
    );
  }
}

class EnrolledUser {
  final int id;
  final String documentId;
  final String username;
  final String email;
  final String provider;
  final bool confirmed;
  final bool blocked;
  final String firstName;
  final String lastName;
  final String birthdate;
  final String phoneNumber;
  final String otpTokenExpiration;
  final String gender;
  final String createdAt;
  final String updatedAt;
  final String publishedAt;

  EnrolledUser({
    required this.id,
    required this.documentId,
    required this.username,
    required this.email,
    required this.provider,
    required this.confirmed,
    required this.blocked,
    required this.firstName,
    required this.lastName,
    required this.birthdate,
    required this.phoneNumber,
    required this.otpTokenExpiration,
    required this.gender,
    required this.createdAt,
    required this.updatedAt,
    required this.publishedAt,
  });

  // تحويل JSON إلى كائن Dart مع قيم افتراضية
  factory EnrolledUser.fromJson(Map<String, dynamic> json) {
    return EnrolledUser(
      id: json['id'] ?? 0,
      // إذا كانت null تعطي 0
      documentId: json['documentId'] ?? '',
      // قيمة فارغة كافتراضية
      username: json['username'] ?? '',
      email: json['email'] ?? 'no_email@example.com',
      // بريد إلكتروني افتراضي
      provider: json['provider'] ?? 'unknown',
      confirmed: json['confirmed'] ?? false,
      // قيمة افتراضية إذا لم يتم التأكيد
      blocked: json['blocked'] ?? false,
      firstName: json['first_name'] ?? 'غير محدد',
      // اسم افتراضي
      lastName: json['last_name'] ?? 'غير محدد',
      birthdate: json['birthdate'] ?? '1990-01-01',
      // تاريخ ميلاد افتراضي
      phoneNumber: json['phone_number'] ?? '0000000000',
      // رقم افتراضي
      otpTokenExpiration:
          json['otp_token_expiration'] ?? '1970-01-01T00:00:00Z',
      gender: json['gender'] ?? 'غير محدد',
      // قيمة افتراضية للجنس
      createdAt: json['createdAt'] ?? '1970-01-01T00:00:00Z',
      updatedAt: json['updatedAt'] ?? '1970-01-01T00:00:00Z',
      publishedAt: json['publishedAt'] ?? '1970-01-01T00:00:00Z',
    );
  }

// // تحويل كائن Dart إلى JSON
// Map<String, dynamic> toJson() {
//   return {
//     'id': id,
//     'documentId': documentId,
//     'username': username,
//     'email': email,
//     'provider': provider,
//     'confirmed': confirmed,
//     'blocked': blocked,
//     'first_name': firstName,
//     'last_name': lastName,
//     'birthdate': birthdate,
//     'phone_number': phoneNumber,
//     'otp_token_expiration': otpTokenExpiration,
//     'gender': gender,
//     'createdAt': createdAt,
//     'updatedAt': updatedAt,
//     'publishedAt': publishedAt,
//   };
// }
}

class Curriculum {
  final int id;
  final String? sectionName;
  final List<Curricula> curricula;

  Curriculum({required this.id, this.sectionName, required this.curricula});

  factory Curriculum.fromJson(Map<String, dynamic> json) {
    return Curriculum(
      id: json['id'] as int,
      sectionName: json['section_name'] as String?,
      curricula: (json['curricula'] as List<dynamic>? ?? [])
          .map((item) => Curricula.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}

class Curricula {
  final int id;
  final String documentId;
  final String title;
  final String type;
  final String videoLink;
  final bool downloadable;
  final String fileLink;
  final String articleContent;
  final String downloadableVideoLink;
  final String videoDuration;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime publishedAt;
  final String locale;
  final List<dynamic> users;
  final bool completed;

  Curricula({
    required this.id,
    required this.documentId,
    required this.title,
    required this.type,
    required this.videoLink,
    required this.downloadable,
    required this.fileLink,
    required this.articleContent,
    required this.downloadableVideoLink,
    required this.videoDuration,
    required this.createdAt,
    required this.updatedAt,
    required this.publishedAt,
    required this.locale,
    required this.users,
    required this.completed,
  });

  factory Curricula.fromJson(Map<String, dynamic> json) {
    return Curricula(
      id: json['id'],
      documentId: json['documentId'] ?? '',
      title: json['title'] ?? '',
      type: json['type'] ?? '',
      videoLink: json['video_link'] ?? '',
      downloadable: json['downloadable'] ?? false,
      fileLink: json['file_link'] ?? '',
      articleContent: json['article_content'] ?? '',
      downloadableVideoLink: json['downloadable_video_link'] ?? '',
      videoDuration: json['video_duration'] ?? '',
      createdAt:
          DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime(1970, 1, 1),
      updatedAt:
          DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime(1970, 1, 1),
      publishedAt:
          DateTime.tryParse(json['publishedAt'] ?? '') ?? DateTime(1970, 1, 1),
      locale: json['locale'] ?? '',
      users: json['users'] ?? [],
      completed: json['completed'] ?? false,
    );
  }
}

class Announcement {
  final int id;
  final String? documentId;
  final String? title;
  final String? content;

  Announcement({
    required this.id,
    this.documentId,
    this.title,
    this.content,
  });

  factory Announcement.fromJson(Map<String, dynamic> json) {
    return Announcement(
      id: json['id'] as int,
      documentId: json['documentId'] as String?,
      title: json['title'] as String?,
      content: json['content'] as String?,
    );
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
}

// نموذج البيانات الرئيسي
class Quiz {
  final int id;
  final String documentId;
  final String name;
  final bool randomSorting;
  final String createdAt;
  final String updatedAt;
  final String publishedAt;
  final String? locale;
  final bool completed;
  final List<Question> questions;
  final List<dynamic> userAnswers;

  Quiz({
    required this.id,
    required this.documentId,
    required this.name,
    required this.randomSorting,
    required this.createdAt,
    required this.updatedAt,
    required this.publishedAt,
    this.locale,
    required this.completed,
    required this.questions,
    required this.userAnswers,
  });

  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      id: json['id'] ?? 0,
      documentId: json['documentId'] ?? '',
      name: json['name'] ?? '',
      randomSorting: json['random_sorting'] ?? false,
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      publishedAt: json['publishedAt'] ?? '',
      locale: json['locale'],
      // قد تكون null
      completed: json['completed'] ?? false,
      questions: (json['questions'] as List<dynamic>?)
              ?.map((item) => Question.fromJson(item))
              .toList() ??
          [],
      userAnswers: json['user_answers'] != null
          ? List<dynamic>.from(json['user_answers'])
          : [],
    );
  }
}

// نموذج السؤال
class Question {
  final int id;
  final String documentId;
  final String questionTitle;
  final String type;
  final String createdAt;
  final String updatedAt;
  final String publishedAt;
  final String? locale;

  Question({
    required this.id,
    required this.documentId,
    required this.questionTitle,
    required this.type,
    required this.createdAt,
    required this.updatedAt,
    required this.publishedAt,
    this.locale,
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
      locale: json['locale'], // قد تكون null
    );
  }
}
