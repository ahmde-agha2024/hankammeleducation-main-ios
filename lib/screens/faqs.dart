import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hankammeleducation/api/controllers/api_controller.dart';
import 'package:hankammeleducation/model/faqs.dart';
import 'package:shimmer/shimmer.dart';

class FaqsScreen extends StatefulWidget {

  FaqsScreen({super.key});

  @override
  State<FaqsScreen> createState() => _FaqsScreenState();
}

class _FaqsScreenState extends State<FaqsScreen> {
  bool isConnected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "الأسئلة الشائعة (FAQS)",
          style: GoogleFonts.cairo(fontSize: 11.sp),
        ),
        backgroundColor: Colors.white,
      ),
      body: FutureBuilder<List<FAQ>>(
        future: ApiController().getFaqs(),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            return Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView.builder(
                  itemCount: 5, // عدد الكروت
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Container(
                            height: 60, // ارتفاع الكارد
                            padding: const EdgeInsets.all(16.0),
                          ),
                        ),
                      ),
                    );
                  },
                ));
          } else if (isConnected && snapshot.hasData){
            return Padding(
              padding:  EdgeInsets.all(16.0.r),
              child: ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: Colors.white,
                    margin: EdgeInsets.only(bottom: 12.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    elevation: 1,
                    child: ExpansionTile(
                      title: Text(
                        snapshot.data![index].question,
                        style: GoogleFonts.cairo(
                          fontWeight: FontWeight.bold,
                          fontSize: 9.sp,
                        ),
                      ),
                      children: [
                        Padding(
                          padding:  EdgeInsets.all(16.0.r),
                          child: Text(
                            snapshot.data![index].answer,
                            style: GoogleFonts.cairo(
                              fontSize: 9.sp,
                              color: Colors.grey[700],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          }else {
            return Center(
              child: Text(
                "لا يوجد بيانات",
                style: GoogleFonts.cairo(
                    fontSize: 14.sp, fontWeight: FontWeight.bold),
              ),
            );
          }

        }
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
