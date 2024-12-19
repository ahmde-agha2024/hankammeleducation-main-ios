import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hankammeleducation/api/controllers/api_controller.dart';
import 'package:hankammeleducation/model/subcategory.dart';
import 'package:hankammeleducation/screens/book_list.dart';
import 'package:shimmer/shimmer.dart';

class PrimaryStages extends StatefulWidget {
  PrimaryStages({required this.id, required this.title, super.key});

  String id;
  String title;

  @override
  State<PrimaryStages> createState() => _PrimaryStagesState();
}

class _PrimaryStagesState extends State<PrimaryStages> {
  bool isConnected = false;

  @override
  void initState() {
    // TODO: implement initState
    checkInternetConnection();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.title,
            style: GoogleFonts.cairo(
                color: const Color(0xff073b4c),
                fontSize: 12.sp,
                fontWeight: FontWeight.bold)),
      ),
      body: Padding(
          padding:  EdgeInsets.symmetric(horizontal: 16.w, vertical: 40.h),
          child: FutureBuilder<List<SubCategoryModel>>(
              future: ApiController()
                  .getSubCategory(categoryEqual: widget.id, populate: '*'),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Padding(
                      padding:  EdgeInsets.symmetric(
                          horizontal: 16.w, vertical: 10.h),
                      child: GridView(
                        gridDelegate:
                             SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 5.0.w,
                          mainAxisSpacing: 5.0.h,
                        ),
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(16.0.r),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(16.0.r),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(16.0.r),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(16.0.r),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(16.0.r),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(16.0.r),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                } else if (isConnected &&
                    snapshot.hasData) {
                  return GridView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return Card(
                        color: const Color(0xff073b4c),
                        child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Align(
                            child: Text(snapshot.data![index].title,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.cairo(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 10.sp)),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BookList(
                                  title: snapshot.data![index].title.toString(),
                                  id: snapshot.data![index].id.toString(),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                    gridDelegate:
                         SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 1.0.w,
                      mainAxisSpacing: 2.0.h,
                    ),
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
              })),
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
