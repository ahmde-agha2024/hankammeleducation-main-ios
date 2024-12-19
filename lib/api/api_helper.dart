import 'dart:io';
import 'package:hankammeleducation/model/api_response.dart';
import 'package:hankammeleducation/pref/shared_pref_controller.dart';

mixin ApiHelper {
  ApiResponse get failedResponse => ApiResponse(
      message: 'Something went wrong', success: false, code: 'error');

  Map<String, String> get headres {
    return {
      HttpHeaders.authorizationHeader: SharedPrefController().token,
      HttpHeaders.acceptHeader: 'application/json',
    };
  }
}
