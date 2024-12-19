
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hankammeleducation/api/controllers/auth_api_controllers.dart';
import 'package:hankammeleducation/model/api_response.dart';
import 'package:hankammeleducation/screens/bottomNavigationBar.dart';
import 'package:hankammeleducation/utils/helpers.dart';
import 'package:hankammeleducation/widget/code_text_field.dart';

class VerifyPhone extends StatefulWidget {
  VerifyPhone({required this.phoneNumber, super.key});

  String phoneNumber;


  @override
  State<VerifyPhone> createState() => _VerifyPhoneState();
}

class _VerifyPhoneState extends State<VerifyPhone> with Helpers {
  // int counter = 1;
  // bool ststuae = false;
  int remainingTime = 15 * 60; // عدد الثواني للعد التنازلي
  Timer? timer; // مؤقت
  late TextEditingController _firstCodeTextController;
  late TextEditingController _secondCodeTextController;
  late TextEditingController _thirdCodeTextController;
  late TextEditingController _fourthCodeTextController;
  late FocusNode _firstFocusNode;
  late FocusNode _secondFocusNode;
  late FocusNode _thirdFocusNode;
  late FocusNode _fourthFocusNode;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTimer(); // بدء العداد

    _firstCodeTextController = TextEditingController();
    _secondCodeTextController = TextEditingController();
    _thirdCodeTextController = TextEditingController();
    _fourthCodeTextController = TextEditingController();

    _firstFocusNode = FocusNode();
    _secondFocusNode = FocusNode();
    _thirdFocusNode = FocusNode();
    _fourthFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _firstCodeTextController.dispose();
    _secondCodeTextController.dispose();
    _thirdCodeTextController.dispose();
    _fourthCodeTextController.dispose();
    _firstFocusNode.dispose();
    _secondFocusNode.dispose();
    _thirdFocusNode.dispose();
    _fourthFocusNode.dispose();
    timer?.cancel(); // تنظيف المؤقت عند التخلص من الـ Widget
    super.dispose();
  }
  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (remainingTime > 0) {
        setState(() {
          remainingTime--;
        });
      } else {
        timer.cancel(); // إيقاف العداد عند الوصول إلى الصفر
      }
    });
  }

  String formatTime(int seconds) {
    int minutes = seconds ~/ 60; // حساب الدقائق
    int remainingSeconds = seconds % 60; // حساب الثواني
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding:  EdgeInsets.symmetric(horizontal: 45.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              ' قم بإدخال رمز التأكيد المكون من 4 خانات '"${formatTime(remainingTime)}",
              style:
                  GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 8.sp),
            ),
            SizedBox(
              height: 10.h,
            ),
            Row(
              children: [
                CodeTextField(
                  controllerText: _firstCodeTextController,
                  focusNode: _firstFocusNode,
                  onChanged: (String value) {
                    if (value.isNotEmpty) {
                      _secondFocusNode.requestFocus();
                    }
                  },
                  onSubmitted: (String value) {},
                ),
                 SizedBox(
                  width: 10.w,
                ),
                CodeTextField(
                  controllerText: _secondCodeTextController,
                  focusNode: _secondFocusNode,
                  onChanged: (String value) {
                    value.isNotEmpty
                        ? _thirdFocusNode.requestFocus()
                        : _firstFocusNode.requestFocus();
                  },
                  onSubmitted: (String value) {},
                ),
                 SizedBox(
                  width: 10.w,
                ),
                CodeTextField(
                  controllerText: _thirdCodeTextController,
                  focusNode: _thirdFocusNode,
                  onChanged: (String value) {
                    value.isNotEmpty
                        ? _fourthFocusNode.requestFocus()
                        : _secondFocusNode.requestFocus();
                  },
                  onSubmitted: (String value) {},
                ),
                 SizedBox(
                  width: 10.w,
                ),
                CodeTextField(
                  controllerText: _fourthCodeTextController,
                  focusNode: _fourthFocusNode,
                  onChanged: (String value) {
                    if (value.isEmpty) {
                      _thirdFocusNode.requestFocus();
                    }
                  },
                  onSubmitted: (String value) {},
                ),
              ],
            ),
            SizedBox(
              height: 20.h,
            ),
            ElevatedButton(
              onPressed: () async => await _performPhoneNumber(),
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  minimumSize: const Size(double.infinity, 40),
                  elevation: 0,
                  textStyle: GoogleFonts.cairo(),
                  backgroundColor: Color(0xff073b4c)),
              child: Text(
                'تأكيد',
                style: GoogleFonts.cairo(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 10.sp),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _performPhoneNumber() async {
    if (_checkData()) {
      return await _verifyNumber();
    }
  }

  bool _checkData() {
    if (_firstCodeTextController.text.isNotEmpty &&
        _secondCodeTextController.text.isNotEmpty &&
        _thirdCodeTextController.text.isNotEmpty &&
        _fourthCodeTextController.text.isNotEmpty) {
      return true;
    }
    showSnackBar(context, message: "أدخل البيانات المطلوبة!", error: true);

    return false;
  }

  Future<void> _verifyNumber() async {
    String otpToken =
        "${_firstCodeTextController.text}${_secondCodeTextController.text}${_thirdCodeTextController.text}${_fourthCodeTextController.text}";
    ApiResponse apiResponse = await AuthApiController()
        .verifyPhoneNumber(phoneNumber: widget.phoneNumber, otpToken: otpToken);

    if (apiResponse.success) {
      showSnackBar(context,
          message: apiResponse.message, error: !apiResponse.success);
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => BottomNavigationScreen()));
    } else {
      showSnackBar(context,
          message: apiResponse.message, error: !apiResponse.success);
    }
  }
}
