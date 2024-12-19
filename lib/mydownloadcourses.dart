import 'dart:io';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hankammeleducation/course/viemo.dart';
import 'package:hankammeleducation/pref/shared_pref_controller.dart';
import 'package:hankammeleducation/utils/helpers.dart';

class MyDownloads extends StatefulWidget {
  MyDownloads({super.key});

  @override
  _MyDownloadsState createState() => _MyDownloadsState();
}

class _MyDownloadsState extends State<MyDownloads> with Helpers {
  final Box _downloadsBox = Hive.box('downloads'); // الوصول إلى صندوق التحميلات
  String _selectedCategory = "الكل"; // التصنيف الحالي
  bool status = false;
  bool isConnected = false;

  void deleteDownload(int index) {
    _downloadsBox.deleteAt(index); // حذف عنصر من Hive
    setState(() {}); // تحديث الواجهة
    showSnackBar(context, message: "تم حذف التنزيل!", error: false);
  }

  void deleteAllDownloads() {
    _downloadsBox.clear(); // حذف كل العناصر
    setState(() {}); // تحديث الواجهة

    showSnackBar(context, message: "تم حذف جميع التنزيلات!", error: false);
  }

  @override
  void initState() {
    // TODO: implement initState
    checkInternetConnection();
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    status = SharedPrefController().getByKey(key: PrefKeys.listCategory.name) ==
        null;
    final downloads = _selectedCategory == "الكل"
        ? _downloadsBox.values.toList()
        : _downloadsBox.values
        .where((download) => download['category'] == _selectedCategory)
        .toList();

    return status
        ? isConnected
        ? Center(
      child: Container(
        height: 220.h,
        width: 220.w,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'images/nodata.jpg',
            ),
          ),
        ),
      ),
    )
        : Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          height: 220.h,
          width: 220.w,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                'images/nodata.jpg',
              ),
            ),
          ),
        ),
      ),
    )
        : Column(
      children: [
        Padding(
          padding:
          EdgeInsets.symmetric(horizontal: 20.w, vertical: 40.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Text(
                "إختر المادة : ",
                style: GoogleFonts.cairo(
                    fontWeight: FontWeight.bold, fontSize: 9.sp),
              ),
              SizedBox(
                width: 20.w,
              ),
              DropdownButton<String>(
                value: _selectedCategory,
                items: SharedPrefController()
                    .listAllCategot
                    .map((category) =>
                    DropdownMenuItem(
                      value: category,
                      child: Text(
                        category,
                        style: GoogleFonts.cairo(fontSize: 10.sp),
                      ),
                    ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value!;
                  });
                },
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(
                  Icons.delete_forever,
                  color: Colors.red,
                ),
                onPressed: () {
                  setState(() {
                    deleteAllDownloads();
                  });
                },
              ),
            ],
          ),
        ),

        // عرض قائمة التحميلات
        Expanded(
          child: downloads.isEmpty
              ? Center(
              child: Text(
                "لا تتوفر أي تنزيلات",
                style: GoogleFonts.cairo(
                    fontSize: 10.sp, fontWeight: FontWeight.bold),
              ))
              : ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            itemCount: downloads.length,
            itemBuilder: (context, index) {
              final download = downloads[index];
              return Card(
                color: Colors.white,
                child: ListTile(
                  //leading: Icon(Icons.video_file),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                VideoPlayerScreen(
                                  url: download['filePath'],
                                )));
                  },
                  title: Text(
                    "${download['sectionname']} - ${download['filePath']
                        .split('/')
                        .last} ",
                    // عرض اسم الملف فقط
                    style: GoogleFonts.cairo(
                        fontWeight: FontWeight.bold, fontSize: 8.sp),
                  ),
                  subtitle: Text(
                    "${download['category']}",
                    style: GoogleFonts.cairo(
                        fontSize: 8.sp, fontWeight: FontWeight.bold),
                  ),
                  trailing: IconButton(
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      deleteDownload(index); // حذف عنصر معين
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
