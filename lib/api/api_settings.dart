class ApiSettings {
  static const String _baseurl = 'https://app.ht12.ly/api/';
  static const String register = '${_baseurl}auth/local/register';
  static const String verifyPhoneNumber = '${_baseurl}auth/verify';
  static const String login = '${_baseurl}auth/local';
  static const String privacyPolicy = '${_baseurl}privacy-policy';
  static const String termsAndConditions = '${_baseurl}terms-and-condition';
  static const String about = '${_baseurl}about';
  static const String deleteAccount = '${_baseurl}users/:id';
  static const String home = '${_baseurl}categories';
  static const String subCategory =
      '${_baseurl}sub-categories?{filters[category][\$eq]=}&&{populate=}';
  static const String bookList =
      '${_baseurl}courses?{filters[sub_category][\$eq]=}&&{populate=}';
  static const String courseDetails =
      '${_baseurl}courses/:documentId?{populate=}';
  static const String allCourses = '${_baseurl}courses?{populate=}';
  static const String enrolledCourse = '${_baseurl}courses/:id';
  static const String getEnrolledCourse =
      '${_baseurl}courses?{filters[enrolled_users][\$eq]=}&populate=*';
  static const String getAllQuizzes =
      '${_baseurl}quizzes?{filters[course][documentId][\$eq]=}&{populate[questions][populate]=*}';

  static const String search = '${_baseurl}courses?{filters[sub_category][\$eq]=}&{filters[title][\$contains]=}';
  static const String completeLessons = '${_baseurl}curricula/:id';

  static const String submitAnswers = '${_baseurl}user-answers';
  static const String addDeviceForNotification = '${_baseurl}notification-tokens';
  static const String faq = '${_baseurl}faqs';
}
