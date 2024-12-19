import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hankammeleducation/api/controllers/api_controller.dart';
import 'package:hankammeleducation/model/about.dart';
import 'package:shimmer/shimmer.dart';


class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  bool isConnected = false;
  @override
  void initState() {
    checkInternetConnection();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 40.h),
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: FutureBuilder<DataResponseAbout>(
                future: ApiController().getAbout(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Padding(
                        padding:  EdgeInsets.symmetric(vertical: 8.0.h),
                        child: Container(
                          height: 800.h,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(8.0.r),
                          ),
                          child: Row(
                            children: [
                              // أيقونة القفل
                              Padding(
                                padding:  EdgeInsets.all(16.0.r),
                                child: Icon(Icons.lock,
                                    color: Colors.grey[400], size: 30.w),
                              ),
                              // النصوص (العنوان والتفاصيل)
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 150.w,
                                    height: 16.h,
                                    color: Colors.grey[300],
                                  ),
                                  SizedBox(height: 8.h),
                                  Container(
                                    width: 100.w,
                                    height: 12.h,
                                    color: Colors.grey[300],
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  } else if (isConnected && snapshot.hasData) {
                    return HtmlWidget(
                      snapshot.data!.aboutapp
                      // onErrorBuilder: (context, element, error) =>
                      //     Text('$element error: $error'),
                      ,
                      onLoadingBuilder: (context, element, loadingProgress) =>
                          Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Padding(
                              padding:  EdgeInsets.symmetric(vertical: 8.0.h),
                              child: Container(
                                height: 800.h,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(8.0.r),
                                ),
                                child: Row(
                                  children: [
                                    // أيقونة القفل
                                    Padding(
                                      padding:  EdgeInsets.all(16.0.r),
                                      child: Icon(Icons.lock,
                                          color: Colors.grey[400], size: 300.w),
                                    ),
                                    // النصوص (العنوان والتفاصيل)
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 150.w,
                                          height: 16.h,
                                          color: Colors.grey[300],
                                        ),
                                        SizedBox(height: 8.h),
                                        Container(
                                          width: 100.w,
                                          height: 12.h,
                                          color: Colors.grey[300],
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                      renderMode: RenderMode.column,
                    );
                  } else {
                    return Center(
                      child: Text(
                       "لا يوجد بيانات",
                        style: GoogleFonts.cairo(
                            fontSize: 14.sp, fontWeight: FontWeight.bold),
                      ),
                    );
                  }
                }),
          ),
        ),
      ),
    );
  }
  Future<void> checkInternetConnection() async {
    final result = await InternetAddress.lookup('example.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      setState(() {
        isConnected = true;
      });
    } else {
      setState(() {
        isConnected = false;
      });
    }
  }
}
