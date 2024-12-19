import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hankammeleducation/api/controllers/auth_api_controllers.dart';
import 'package:hankammeleducation/model/api_response.dart';
import 'package:hankammeleducation/screens/bottomNavigationBar.dart';
import 'package:hankammeleducation/utils/helpers.dart';
import 'register_screen.dart';
import 'verifyPhone_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with Helpers {
  late TextEditingController _phonecontroller;
  bool loading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _phonecontroller = TextEditingController();
  }

  @override
  void dispose() {
    _phonecontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      // appBar: AppBar(
      //     centerTitle: true,
      //     title: Text(
      //       ' تسجيل الدخول',
      //       style: GoogleFonts.cairo(color: Color(0xff118ab2),fontSize: 16,
      //       fontWeight: FontWeight.bold),
      //     )),
      body: Padding(
        padding:  EdgeInsets.all(16.0.r),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 200.h,
              width: 200.w,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    'images/thumbnail_Logo.png',
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            SizedBox(
              width: double.infinity.w,
              height: 40.h,
              child: TextField(
                controller: _phonecontroller,
                onChanged: (value) {},
                keyboardType: TextInputType.phone,
                maxLength: 14,
                style: TextStyle(fontSize: 8.sp),
                decoration: InputDecoration(
                    labelText: 'رقم الهاتف',
                    hintText: "أدخل رقم الموبايل",
                    hintStyle: GoogleFonts.cairo(fontSize: 8.sp),
                    counterText: "",
                    labelStyle:
                        GoogleFonts.cairo(fontSize: 8.sp, color: Colors.black54),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                        borderSide:
                            BorderSide(width: 1.w, color: Color(0xffef476f))),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                        borderSide:
                            BorderSide(width: 1.w, color: Color(0xffef476f)))),
              ),
            ),
            // SizedBox(
            //   height: 20,
            // ),
            // SizedBox(
            //   width: double.infinity,
            //   height: 40,
            //   child: TextField(
            //     onChanged: (value) {
            //       setState(() {
            //         password = value;
            //       });
            //     },
            //     obscureText: true,
            //     decoration: InputDecoration(
            //         labelText: 'كلمة المرور',
            //         labelStyle: GoogleFonts.cairo(fontSize: 8),
            //         enabledBorder: OutlineInputBorder(
            //             borderRadius: BorderRadius.circular(8),
            //             borderSide:
            //                 BorderSide(width: 1, color: Color(0xffef476f))),
            //         focusedBorder: OutlineInputBorder(
            //             borderRadius: BorderRadius.circular(8),
            //             borderSide:
            //                 BorderSide(width: 1, color: Color(0xffef476f)))),
            //   ),
            // ),
            SizedBox(height: 20.h),
            loading
                ?  SizedBox(
                    width: 20.w,
                    height: 20.h,
                    child: CircularProgressIndicator(
                      strokeWidth: 1.0.w,
                      color: Color(0xff073b4c),
                    ),
                  )
                : ElevatedButton(
                    onPressed: () async => await _performLogin(),
                    child: Text(
                      'تسجيل الدخول',
                      style: GoogleFonts.cairo(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 9.sp),
                    ),
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        minimumSize:  Size(double.infinity.w, 40.h),
                        elevation: 0,
                        textStyle: GoogleFonts.cairo(),
                        backgroundColor: Color(0xff118ab2)),
                  ),

            TextButton(
              style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterScreen()),
                );
              },
              child: Text(
                'تسجيل مستخدم جديد',
                style: GoogleFonts.cairo(
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                  fontSize: 8.sp,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.person,
                  color: Color(0xff118ab2),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                      padding: EdgeInsets.zero.r,),
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BottomNavigationScreen()),
                      (route) => false,
                    );

                  },
                  child: Text(
                    'تصفح كزائر',
                    style: GoogleFonts.cairo(
                      color: Color(0xff118ab2),
                      fontWeight: FontWeight.bold,
                      fontSize: 9.sp,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _performLogin() async {
    if (_checkData()) {
      return await _login();
    }
  }

  bool _checkData() {
    if (_phonecontroller.text.isNotEmpty) {
      return true;
    }
    showSnackBar(context, message: "أدخل رقم الموبايل!", error: true);

    return false;
  }

  Future<void> _login() async {
    setState(() {
      loading = true;
    });
    ApiResponse apiResponse =
        await AuthApiController().login(_phonecontroller.text);
    if (apiResponse.success) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => VerifyPhone(
                    phoneNumber: _phonecontroller.text,
                  )));
    } else {
      setState(() {
        showSnackBar(context,
            message: apiResponse.message, error: !apiResponse.success);
      });
    }
    setState(() {
      loading = false;
    });
  }
}
