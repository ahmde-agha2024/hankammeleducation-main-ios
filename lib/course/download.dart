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

class VideoDownloader extends StatefulWidget {
  VideoDownloader(
      {required this.titleCourse,
      required this.allCourses,
      required this.titleVideo,
      required this.semesterNumber,
      required this.link,
      required this.phoneNumber,
      super.key});

  String titleCourse;
  String titleVideo;
  String semesterNumber;
  List<String> allCourses;
  String link;
  String phoneNumber;

  @override
  _VideoDownloaderState createState() => _VideoDownloaderState();
}

class _VideoDownloaderState extends State<VideoDownloader> with Helpers {
  bool _isDownloading = false;
  String _progress = "0%";
  final Box _downloadsBox = Hive.box('downloads'); // الوصول إلى صندوق التحميلات
  String _selectedCategory = "الكل"; // التصنيف الحالي
  List<String> listAll = ['الكل'];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    listAll.addAll(widget.allCourses);
  }

  Future<String> _getFilePath(String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    return "${directory.path}/$fileName";
  }

  bool _isVideoDownloaded(String url) {
    return _downloadsBox.values
        .any((download) => download['url'] == url); // التحقق من وجود الفيديو
  }

  Future<void> downloadVideo(
      String url, String fileName, String category) async {
    setState(() {
      _isDownloading = true;
    });

    try {
      // الحصول على مسار التخزين
      final filePath = await _getFilePath(fileName);

      // تنزيل الفيديو
      Dio dio = Dio();
      await dio.download(
        url,
        filePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            setState(() {
              _progress = "${(received / total * 100).toStringAsFixed(0)}%";
            });
          }
        },
      );

      // إضافة الفيديو إلى قائمة التحميلات
      _downloadsBox.add({
        'url': url, // تخزين رابط الفيديو
        'filePath': filePath,
        'category': category,
        'sectionname': widget.semesterNumber,
        'titlevideo': widget.titleVideo,
        'phonenumber': widget.phoneNumber,
        'timestamp': DateTime.now().toString(),
      });

      setState(() {
        _isDownloading = false;
        // _progress = "إكتمل التنزيل!";
      });

      showSnackBar(context,
          message: "تم تنزيل الفيديو إلى : $filePath", error: false);

      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text("تم تنزيل الفيديو إلى : $filePath",style: GoogleFonts.cairo(
      //     fontSize: 10,
      //     fontWeight: FontWeight.bold
      //   ),)),
      // );
    } catch (e) {
      setState(() {
        _isDownloading = false;
        _progress = "فشل التنزيل.";
      });

      showSnackBar(context, message: "خطأ في عملية التنزيل", error: true);
    }
  }

  Future<void> handleDownload(
      String url, String fileName, String category) async {
    if (_isVideoDownloaded(url)) {
      showSnackBar(context,
          message: "لقد تم تنزيل هذا الفيديو بالفعل!", error: true);
    } else {
      await downloadVideo(url, fileName, category);
    }
  }

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
  Widget build(BuildContext context) {
    final downloads = _selectedCategory == "الكل"
        ? _downloadsBox.values.toList()
        : _downloadsBox.values
            .where((download) => download['category'] == _selectedCategory)
            .toList();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "تحميل المحتوى المرئي",
          style: GoogleFonts.cairo(fontSize: 9.sp, fontWeight: FontWeight.bold),
        ),
        actions: [
          Tooltip(
            message: 'حذف الكل',
            textStyle: GoogleFonts.cairo(fontSize: 8.sp, color: Colors.white),
            child: IconButton(
              icon: const Icon(
                Icons.delete_forever,
                color: Colors.red,
              ),
              //tooltip: 'حذف الكل',

              onPressed: deleteAllDownloads, // حذف جميع العناصر
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // واجهة التنزيل
          _isDownloading
              ? Padding(
                  padding: EdgeInsets.all(16.0.r),
                  child: Column(
                    children: [
                      Text(
                        " جاري التنزيل... $_progress",
                        style: GoogleFonts.cairo(
                            fontSize: 10.sp, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10.h),
                      SpinKitWave(
                        color: const Color(0xff118ab2),
                        size: 20.0.w,
                      ),
                    ],
                  ),
                )
              : ElevatedButton(
                  onPressed: () async {
                    handleDownload(
                      widget.link,
                      "${widget.titleVideo}.mp4",
                      widget.titleCourse, // التصنيف الحالي
                    );
                    await SharedPrefController().listCategory(listAll: listAll);
                  },
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      minimumSize: const Size(80, 40),
                      elevation: 0,
                      textStyle: GoogleFonts.cairo(),
                      backgroundColor: Color(0xff118ab2)),
                  child: Text(
                    "تنزيل الفيديو",
                    style: GoogleFonts.cairo(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 9.sp),
                  ),
                ),
          const Divider(),
          downloads.isEmpty
              ? const SizedBox()
              : Padding(
                  padding:  EdgeInsets.symmetric(horizontal: 20.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
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
                        items: listAll
                            .map((category) => DropdownMenuItem(
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
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => VideoPlayerScreen(
                                          url: download['filePath'],
                                        )));
                          },
                          //leading: Icon(Icons.video_file),
                          title: Text(
                            "${download['sectionname']} - ${download['filePath'].split('/').last} ",
                            // عرض اسم الملف فقط
                            style: GoogleFonts.cairo(
                                fontWeight: FontWeight.bold, fontSize: 8.sp),
                          ),
                          subtitle: Text(
                            "${download['category']}",
                            style: GoogleFonts.cairo(
                                fontSize: 8.sp, fontWeight: FontWeight.bold),
                          ),
                          // subtitle: Text(
                          //   "${download['category']} - تاريخ التنزيل : ${download['timestamp']}",
                          //   style: GoogleFonts.cairo(fontSize: 8),
                          // ),
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
      ),
    );
  }
}
