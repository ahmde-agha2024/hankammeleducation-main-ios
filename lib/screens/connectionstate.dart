import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hankammeleducation/mydownloadcourses.dart';
import 'package:hankammeleducation/pref/shared_pref_controller.dart';
import 'package:hankammeleducation/screens/auth_screens/login_screen.dart';
import 'package:hankammeleducation/screens/bottomNavigationBar.dart';
import 'package:hankammeleducation/utils/helpers.dart';

class ConnectionStateScreen extends StatefulWidget {
  const ConnectionStateScreen({super.key});

  @override
  State<ConnectionStateScreen> createState() => _ConnectionStateScreenState();
}

class _ConnectionStateScreenState extends State<ConnectionStateScreen>
    with Helpers {
  bool isConnected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        color: Colors.black,
        backgroundColor: Colors.white,
        strokeWidth: 1.7.w,
        onRefresh: checkInternetConnection,
        child: Center(
          child: Padding(
            padding:  EdgeInsets.all(8.0.r),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(), // لتمكين السحب دائمًا
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Container(
                      height: 220.h,
                      width: 220.w,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                            'images/noconnection.jpg',
                          ),
                        ),
                      ),
                    ),
                  ),
                  Text(
                    textAlign: TextAlign.center,
                    "أوه!",
                    style:
                        GoogleFonts.cairo(fontSize: 18.sp, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Text(
                    textAlign: TextAlign.center,
                    "يبدو أنك غير متصل بالإنترنت, تأكد من الشبكة لنستمر معًا",
                    style:
                        GoogleFonts.cairo(fontSize: 10.sp, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Text(
                    textAlign: TextAlign.center,
                    "قم بالسحب للأسفل لتحديث الصفحة",
                    style:
                    GoogleFonts.cairo(fontSize: 10.sp, fontWeight: FontWeight.bold),
                  ),
                  // ElevatedButton(
                  //   onPressed: () async {
                  //     await checkInternetConnection();
                  //   },
                  //   style: ElevatedButton.styleFrom(
                  //       shape: RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.circular(8.r),
                  //       ),
                  //       minimumSize:  Size(double.infinity.w, 40.h),
                  //       elevation: 0,
                  //       textStyle: GoogleFonts.cairo(),
                  //       backgroundColor: const Color(0xff118ab2)),
                  //   child: Text(
                  //     'حاول مرة أخرى',
                  //     style: GoogleFonts.cairo(
                  //         color: Colors.white,
                  //         fontWeight: FontWeight.bold,
                  //         fontSize: 9.sp),
                  //   ),
                  // ),
                  SharedPrefController().getByKey(key: PrefKeys.isLoggedIn.name)
                      ? TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MyDownloads()));
                          },
                          child: Text(
                            'إذهب إلى التحميلات',
                            style: GoogleFonts.cairo(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                                fontSize: 9.sp),
                          ),
                        )
                      : const SizedBox()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> checkInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          var route = SharedPrefController().loggedIn
              ? BottomNavigationScreen()
              : LoginScreen();

          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => route));
        });
      }
    } on SocketException catch (_) {}
  }
}
