import 'dart:convert';
import 'dart:core';
import 'package:hankammeleducation/api/api_helper.dart';
import 'package:hankammeleducation/api/api_settings.dart';
import 'package:hankammeleducation/model/api_response.dart';
import 'package:hankammeleducation/model/login_user.dart';
import 'package:hankammeleducation/model/register_user.dart';
import 'package:http/http.dart' as http;
import 'package:hankammeleducation/pref/shared_pref_controller.dart';

class AuthApiController with ApiHelper {
  Future<ApiResponse> register(RegisterUser user) async {
    Uri uri = Uri.parse(ApiSettings.register);
    var response = await http.post(uri, body: {
      'first_name': user.firstName,
      'last_name': user.lastName,
      'gender': user.gender,
      'phone_number': user.phoneNumber,
    });
    var jsonResponse = jsonDecode(response.body);
    return ApiResponse(
        message: jsonResponse['data']['message'],
        success: jsonResponse['data']['success']);
  }

  Future<ApiResponse> verifyPhoneNumber(
      {required String phoneNumber, required String otpToken}) async {
    Uri uri = Uri.parse(ApiSettings.verifyPhoneNumber);
    var response = await http.post(uri, body: {
      'phone_number': phoneNumber,
      'otp_token': otpToken,
    });
    var jsonResponse = jsonDecode(response.body);
    if (jsonResponse["data"]['success']) {
      LoginResponse user = LoginResponse.fromJson(jsonResponse);
     await SharedPrefController().save(user: user);
      return ApiResponse(
          message: jsonResponse["data"]['message'],
          success: jsonResponse["data"]['success']);
    } else {
      return ApiResponse(
          message: jsonResponse["data"]['message'],
          success: jsonResponse["data"]['success']);
    }
  }

  Future<ApiResponse> login(String PhoneNumber) async {
    Uri uri = Uri.parse(ApiSettings.login);
    var response = await http.post(uri, body: {
      'identifier': PhoneNumber,
    });
    var jsonResponse = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return ApiResponse(
          message: jsonResponse['data']['message'],
          success: jsonResponse['data']['success']);
    } else {
      return ApiResponse(message: "حدث خطأ ما , حاول ثانية", success: false);
    }
  }
}
