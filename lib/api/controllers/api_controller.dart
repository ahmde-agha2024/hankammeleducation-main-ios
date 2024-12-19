import 'dart:convert';
import 'dart:io';

import 'package:hankammeleducation/api/api_helper.dart';
import 'package:hankammeleducation/api/api_settings.dart';
import 'package:hankammeleducation/model/about.dart';
import 'package:hankammeleducation/model/api_response.dart';
import 'package:hankammeleducation/model/faqs.dart';
import 'package:hankammeleducation/model/quiz.dart';
import 'package:hankammeleducation/screens/faqs.dart';
import 'package:http/http.dart' as http;
import 'package:hankammeleducation/model/book_list.dart';
import 'package:hankammeleducation/model/home.dart';
import 'package:hankammeleducation/model/privacypolicy.dart';
import 'package:hankammeleducation/model/subcategory.dart';
import 'package:hankammeleducation/pref/shared_pref_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiController with ApiHelper {
  Future<DataResponse> getPrivacyPolicy() async {
    Uri uri = Uri.parse(ApiSettings.privacyPolicy);
    var response = await http.get(uri, headers: headres);
    var jsonResponse = jsonDecode(response.body);
    if (response.statusCode == 200) {
      var data = jsonResponse['data'];
      return DataResponse.fromJson(data);
    } else {
      return throw Exception('حدث خطأ ما , حاول مرة أخرى ');
    }
  }

  Future<DataResponse> getTermsAndConditions() async {
    Uri uri = Uri.parse(ApiSettings.termsAndConditions);
    var response = await http.get(uri, headers: headres);
    var jsonResponse = jsonDecode(response.body);
    if (response.statusCode == 200) {
      var data = jsonResponse['data'];
      return DataResponse.fromJson(data);
    } else {
      return throw Exception('حدث خطأ ما , حاول مرة أخرى ');
    }
  }

  Future<DataResponseAbout> getAbout() async {
    Uri uri = Uri.parse(ApiSettings.about);
    var response = await http.get(uri);
    var jsonResponse = jsonDecode(response.body);

    if (response.statusCode == 200) {
      var data = jsonResponse['data'];
      return DataResponseAbout.fromJson(data);
    } else {
      return throw Exception('حدث خطأ ما , حاول مرة أخرى ');
    }
  }

  Future<bool> deleteAccount({required int id}) async {
    Uri uri = Uri.parse(
        ApiSettings.deleteAccount.replaceFirst('{id}', id.toString()));
    var response = await http.delete(uri, headers: headres);
    if (response.statusCode == 200) {
      SharedPrefController().clear();
      return true;
    } else {
      return false;
    }
  }

  Future<List<HomeModel>> getHome() async {
    Uri uri = Uri.parse(ApiSettings.home);
    var response = await http.get(uri);
    var jsonResponse = jsonDecode(response.body);

    if (response.statusCode == 200) {
      var data = jsonResponse['data'] as List;
      return data.map((jsonObject) => HomeModel.fromJson(jsonObject)).toList();
    } else {
      return [];
    }
  }

  Future<List<SubCategoryModel>> getSubCategory(
      {required String categoryEqual, required populate}) async {
    Uri uri = Uri.parse(ApiSettings.subCategory
        .replaceFirst('{filters[category][\$eq]=}',
            'filters[category][\$eq]=${categoryEqual.toString()}')
        .replaceFirst('{populate=}', 'populate=${populate.toString()}'));
    var response = await http.get(uri);
    var jsonResponse = jsonDecode(response.body);

    if (response.statusCode == 200) {
      var data = jsonResponse['data'] as List;
      return data
          .map((jsonObject) => SubCategoryModel.fromJson(jsonObject))
          .toList();
    } else {
      return [];
    }
  }

  Future<List<BookListModel>> getBookList(
      {required String subCategoryEqual, required populate}) async {
    Uri uri = Uri.parse(ApiSettings.bookList
        .replaceFirst('{filters[sub_category][\$eq]=}',
            'filters[sub_category][\$eq]=${subCategoryEqual.toString()}')
        .replaceFirst('{populate=}', 'populate=${populate.toString()}'));
    var response = await http.get(uri, headers: headres);
    var jsonResponse = jsonDecode(response.body);

    if (response.statusCode == 200) {
      var data = jsonResponse['data'] as List;

      return data
          .map((jsonObject) => BookListModel.fromJson(jsonObject))
          .toList();
    } else {
      return [];
    }
  }

  Future<List<BookListModel>> getAllCourses() async {
    Uri uri = Uri.parse(
        ApiSettings.bookList.replaceFirst('{populate=}', 'populate=*'));
    var response = await http.get(uri, headers: headres);
    var jsonResponse = jsonDecode(response.body);

    if (response.statusCode == 200) {
      var data = jsonResponse['data'] as List;

      return data
          .map((jsonObject) => BookListModel.fromJson(jsonObject))
          .toList();
    } else {
      return [];
    }
  }

  Future<BookListModel> getCourseDetails(
      {required String documentId, required String pop}) async {
    Uri uri = Uri.parse(ApiSettings.courseDetails
        .replaceFirst(':documentId', documentId)
        .replaceFirst('{populate=}', pop));
    var response = await http.get(uri, headers: headres);
    var jsonResponse = jsonDecode(response.body);

    if (response.statusCode == 200) {
      var data = jsonResponse['data'];

      return BookListModel.fromJson(data);
    } else {
      return throw Exception('حدث خطأ ما , حاول مرة أخرى ');
    }
  }

  Future<ApiResponse> enrolledCours(String connect, String id) async {
    Uri uri = Uri.parse(ApiSettings.enrolledCourse.replaceFirst(':id', id));
    var response = await http.put(uri,
        headers: {
          HttpHeaders.authorizationHeader: SharedPrefController().token,
          HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
        },
        body: json.encode({
          "data": {
            "enrolled_users": {
              "connect": [connect]
            }
          }
        }));

    var jsonResponse = jsonDecode(response.body);
    return ApiResponse(
        message: jsonResponse["data"]["message"],
        success: jsonResponse["data"]["success"]);
  }

  Future<List<BookListModel>> getEnrolledCourses({required int userId}) async {
    Uri uri = Uri.parse(ApiSettings.getEnrolledCourse.replaceFirst(
        '{filters[enrolled_users][\$eq]=}',
        'filters[enrolled_users][\$eq]=${userId.toString()}'));
    var response = await http.get(uri, headers: headres);
    var jsonResponse = jsonDecode(response.body);

    if (response.statusCode == 200) {
      var data = jsonResponse['data'] as List;

      return data
          .map((jsonObject) => BookListModel.fromJson(jsonObject))
          .toList();
    } else {
      return [];
    }
  }

  Future<BookListModel> getMyCourseDetails({required int userId}) async {
    Uri uri = Uri.parse(ApiSettings.getEnrolledCourse.replaceFirst(
        '{filters[enrolled_users][\$eq]=}',
        'filters[enrolled_users][\$eq]=${userId.toString()}'));
    var response = await http.get(uri, headers: headres);
    var jsonResponse = jsonDecode(response.body);

    if (response.statusCode == 200) {
      var data = jsonResponse['data'];

      return BookListModel.fromJson(data);
    } else {
      return throw Exception('حدث خطأ ما , حاول مرة أخرى ');
    }
  }

  Future<List<QuizRoot>> getAllQuizzes({required String docId}) async {
    Uri uri = Uri.parse(ApiSettings.getAllQuizzes
        .replaceFirst('{quizzes?filters[course][documentId][\$eq]}',
            'quizzes?filters[course][documentId][\$eq]=$docId')
        .replaceFirst('{populate[questions][populate]=*}',
            'populate[questions][populate]=*'));
    var response = await http.get(uri);
    var jsonResponse = jsonDecode(response.body);

    if (response.statusCode == 200) {
      var data = jsonResponse['data'] as List;

      return data.map((jsonObject) => QuizRoot.fromJson(jsonObject)).toList();
    } else {
      return [];
    }
  }

  // البحث عن الكورسات باستخدام API
  Future<List<BookListModel>> searchCourses(
      String grade, String searchText) async {
    Uri uri = Uri.parse(ApiSettings.search
        .replaceFirst('{filters[sub_category][\$eq]=}',
            'filters[sub_category][\$eq]=$grade')
        .replaceFirst('{filters[title][\$contains]=}',
            'filters[title][\$contains]=$searchText'));
    final response = await http.get(uri);
    var jsonResponse = jsonDecode(response.body);
    if (response.statusCode == 200) {
      //  final data = json.decode(response.body);
      final List<dynamic> coursesData = jsonResponse['data'];
      return coursesData.map((item) => BookListModel.fromJson(item)).toList();
    } else {
      return throw Exception('حدث خطأ ما , حاول مرة أخرى ');
    }
  }

  Future<ApiResponse> completeLessons(String id) async {
    Uri uri = Uri.parse(ApiSettings.completeLessons.replaceFirst(':id', id));
    var response = await http.put(uri, headers: {
      HttpHeaders.authorizationHeader: SharedPrefController().token,
      HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
    });

    // var jsonResponse = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return ApiResponse(message: "تم إكمال الدرس", success: true);
    }
    return ApiResponse(message: "حدث خطأ ما , حاول مرة أخرى", success: false);
  }

  Future<ApiResponse> submitAnswerQuiz(
      {required String quizConnect,
      required String questionConnect,
      required answer,
      required String answerId}) async {
    Uri uri = Uri.parse(ApiSettings.submitAnswers);
    var response = await http.post(uri,
        headers: {
          HttpHeaders.authorizationHeader: SharedPrefController().token,
          HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
        },
        body: json.encode({
          "data": {
            "quiz": {
              "connect": [quizConnect]
            },
            "question": {
              "connect": [questionConnect]
            },
            "answer": answer,
            "answer_id": answerId
          }
        }));

    if (response.statusCode == 201) {
      return ApiResponse(message: "", success: true);
    }
    return ApiResponse(message: "", success: false);
  }

  Future<ApiResponse> addDeviceNotification(
      {required String tokenDevice,
      required String deviceType,
      required deviceName,
      required String osVersion}) async {
    Uri uri = Uri.parse(ApiSettings.addDeviceForNotification);
    var response = await http.post(uri,
        headers: {
          HttpHeaders.authorizationHeader: SharedPrefController().token,
          HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
        },
        body: json.encode({
          "data": {
            "token_id": tokenDevice,
            "device_type": deviceType,
            "device_name": deviceName,
            "os_version": osVersion
          }
        }));
    if (response.statusCode == 201) {
      return ApiResponse(message: "", success: true);
    }
    return ApiResponse(message: "", success: false);
  }

  Future<List<FAQ>> getFaqs() async {
    Uri uri = Uri.parse(ApiSettings.faq);
    var response = await http.get(uri);
    var jsonResponse = jsonDecode(response.body);

    if (response.statusCode == 200) {
      var data = jsonResponse['data'] as List;
      return data.map((jsonObject) => FAQ.fromJson(jsonObject)).toList();
    } else {
      return [];
    }
  }
}
