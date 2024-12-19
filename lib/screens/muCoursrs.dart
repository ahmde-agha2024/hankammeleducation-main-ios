import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hankammeleducation/api/controllers/api_controller.dart';
import 'package:hankammeleducation/model/book_list.dart';
import 'package:hankammeleducation/pref/shared_pref_controller.dart';
import 'package:hankammeleducation/screens/mycourse2.dart';
import 'package:shimmer/shimmer.dart';

class MyCourses extends StatefulWidget {
  MyCourses();

  @override
  _MyCoursesState createState() => _MyCoursesState();
}

class _MyCoursesState extends State<MyCourses> {
  bool isConnected = false;
  int? userId;

  @override
  void initState() {
    // TODO: implement initState
    checkInternetConnection();
    userId = SharedPrefController().getByKey(key: PrefKeys.id.name) ?? 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'موادي',
          style:
              GoogleFonts.cairo(fontSize: 11.sp, fontWeight: FontWeight.bold),
        ),
      ),
      body: FutureBuilder<List<BookListModel>>(
          future: ApiController().getEnrolledCourses(userId: userId!),
          builder: (context, snapshot) {
            if (isConnected &&
                snapshot.connectionState == ConnectionState.waiting) {
              return Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 40.h),
                  child: GridView.builder(
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 5.0.w,
                      mainAxisSpacing: 5.0.h,
                    ),
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(16.0.r),
                        ),
                      );
                    },
                  ),
                ),
              );
            } else if (isConnected &&
                snapshot.hasData) {
              return GridView.builder(
                padding: EdgeInsets.all(8.0.r),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: Platform.isIOS? 11.h / 12.h : 6.h/7.h,
                  crossAxisSpacing: 10.w,
                  mainAxisSpacing: 10.h,
                ),
                itemCount: snapshot.data!.length,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  double progress =
                      snapshot.data![index].courseCompletion!.toDouble();
                  progress = progress / 100;
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MyCourseScreenTwo(
                                  documentId: snapshot.data![index].documentId!,
                                  title: snapshot.data![index].title!,
                                  grade:
                                      snapshot.data![index].subCategory!.title!,
                                  description:
                                      snapshot.data![index].description!,
                                  enrolled: snapshot.data![index].enrolled,
                                )),
                      );
                    },
                    child: Card(
                      color: Colors.white,
                      elevation: 0,
                      clipBehavior: Clip.antiAlias,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                            width: 0.5.w, color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: ListView(
                        children: [
                          SizedBox(
                            height: 5.h,
                          ),
                          snapshot.data![index].courseImage == null
                              ? Image.network(
                                  'https://tadamon.s3.eu-west-2.amazonaws.com/medium_news_blog_banner_1200x675_feb457f8e1.png',
                             // height:Platform.isIOS? 190.h : 140.h,
                                  fit: BoxFit.contain)
                              : Image.network(
                                  snapshot.data![index].courseImage!.formats!
                                      .medium!.url!,
                               //   height:Platform.isIOS? 180.h : 140.h,
                                  fit: BoxFit.contain),
                          Padding(
                            padding: EdgeInsets.all(4.0.r),
                            child: Row(
                              children: [
                                Text(
                                  "المادة : ",
                                  style: GoogleFonts.cairo(
                                      fontSize: 9.sp,
                                      fontWeight: FontWeight.bold),
                                ),
                                Expanded(
                                  child: Text(
                                    snapshot.data![index].title!,
                                    style: GoogleFonts.cairo(
                                      fontSize: 9.sp,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 4.0.w),
                            child: Row(
                              children: [
                                // Text("التقييم :",
                                //     style: GoogleFonts.cairo(
                                //         //decoration: TextDecoration.lineThrough,
                                //         fontSize: 12,
                                //         fontWeight: FontWeight.bold)),
                                Expanded(
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 4.w),
                                    child: LinearProgressIndicator(
                                      borderRadius:
                                          BorderRadius.circular(12.r),
                                      value: progress / 10,
                                      // نسبة التقدم
                                      minHeight: 5.h,
                                      color: Colors.blue,
                                      backgroundColor: Colors.grey[300],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 4.w),
                                  child: Text(
                                    '${(progress).toStringAsFixed(1)}%',
                                    style: GoogleFonts.cairo(
                                        fontSize: 7.sp,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ),
                         const Divider(
                            thickness: 0.5,
                          ),
                          Padding(
                            padding:  EdgeInsets.only(right: 6.w),
                            child: Row(
                              textDirection: TextDirection.ltr,
                              children: [
                               const  Spacer(),
                                Align(
                                    alignment: Alignment.bottomRight,
                                    child: Padding(
                                      padding:  EdgeInsets.only(left: 5.w),
                                      child: Text(
                                        'عدد الفصول: ${snapshot.data![index].curriculum.length}',
                                        style: GoogleFonts.cairo(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 8.sp,
                                            color: Colors.grey),
                                      ),
                                    )),
                                SizedBox(
                                  width: 5.w,
                                ),
                                Icon(
                                  Icons.play_circle_outline_outlined,
                                  color: Colors.black26,
                                  size: 14.w,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
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
