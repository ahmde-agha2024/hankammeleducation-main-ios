import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hankammeleducation/api/controllers/api_controller.dart';
import 'package:hankammeleducation/model/home.dart';
import 'package:hankammeleducation/pref/shared_pref_controller.dart';
import 'package:hankammeleducation/service/firebase_notification_service.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:hankammeleducation/search/search.dart';

import 'primary_stages.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final controller_page = PageController(viewportFraction: 1.2, keepPage: true);
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _gradeController = TextEditingController();
  bool _isLoading = false;
  bool _statusSearch = false;
  bool isConnected = false;
  late Future<List<HomeModel>> _future;
  int notificationCount = 0;
  bool isPopupOpened = false; // حالة التحقق من فتح الـ popup

  void _performSearch() async {
    final grade = _gradeController.text.trim();
    final searchText = _searchController.text.trim();

    setState(() {
      _isLoading = true;
    });

    try {
      final results = await ApiController().searchCourses(grade, searchText);
      setState(() {
        _isLoading = false;
        _statusSearch = false;
      });
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultsPage(results: results),
        ),
      );
    } catch (error) {
      setState(() {
        _isLoading = false;
        _statusSearch = false;
      });

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            "خطأ",
            style: GoogleFonts.cairo(fontSize: 10.sp),
          ),
          content: Text(
            "خطأ في جلب البيانات $error",
            style: GoogleFonts.cairo(fontSize: 10.sp),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "حسناً",
                style: GoogleFonts.cairo(fontSize: 10.sp),
              ),
            ),
          ],
        ),
      );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    checkInternetConnection();
    super.initState();
    updateNotificationCount();
    _future = ApiController().getHome();
    _loadNotificationCount();
  }

  Future<void> _loadNotificationCount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      notificationCount = prefs.getInt('notificationCount') ?? 0;
    });
  }

  Future<void> _saveNotificationCount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('notificationCount', notificationCount);
  }

  void updateNotificationCount() {
    setState(() {
      notificationCount = FirebaseNotificationService.getNotificationCount();
    });
  }

  void refreshNotifications() {
    setState(() {
      notificationCount = FirebaseNotificationService.getNotificationCount();
    });
  }

  Future<void> showNotificationsPopup(BuildContext context) async {
    final box = await Hive.openBox('notifications');
    final notifications = box.values.toList();
    // تأكد من إخفاء العلامة فقط عند عرض الـ popup
    if (!isPopupOpened && notificationCount > 0) {
      setState(() {
        isPopupOpened = true; // تغيير الحالة إلى مفتوحة
        notificationCount = 0; // إخفاء العلامة مؤقتيًا
      });
      await _saveNotificationCount();
    }
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14.r), // تحكم في الزوايا
          ),
          child: SizedBox(
            height: 500.h, // تحديد الارتفاع المناسب للـ popup
            child: notifications.isEmpty
                ? Center(
                    child: Text(
                      'لا توجد إشعارات',
                      style: GoogleFonts.cairo(fontSize: 10.sp),
                    ),
                  )
                : Column(
                    children: [
                      SizedBox(
                        height: 10.h,
                      ),
                      Text(
                        'الإشعارات',
                        style: GoogleFonts.cairo(fontSize: 10.sp),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: notifications.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.all(8.0.r),
                              child: Card(
                                color: Colors.white,
                                child: ListTile(
                                  title: Text(
                                    notifications.elementAt(index)['title'] ??
                                        '',
                                    style: GoogleFonts.cairo(fontSize: 10.sp),
                                  ),
                                  subtitle: Text(
                                    notifications.elementAt(index)['body'] ??
                                        '',
                                    style: GoogleFonts.cairo(fontSize: 9.sp),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                    ],
                  ),
          ),
        );
      },
    ).then((_) {
      // بعد إغلاق الـ popup
      setState(() {
        isPopupOpened = false; // إعادة الحالة عند إغلاق الـ popup
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          color: Colors.white,
          height: 40.h,
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 14.w),
          color: Colors.white,
          child: Row(
            children: [
              IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () => showNotificationsPopup(context),
                  icon: Image.asset(
                    width: 35.w,
                    height: 35.h,
                    notificationCount > 0
                        ? 'images/notificationcomplete 1.png'
                        : 'images/notificationcomplete.png',
                  )),
              IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    setState(() {
                      _statusSearch = !_statusSearch;
                    });
                  },
                  icon: Image.asset(
                    width: 35.w,
                    height: 35.h,
                    'images/searchComplete.png',
                  )),
              const Spacer(),
              SharedPrefController().getByKey(key: PrefKeys.isLoggedIn.name) ==
                      null
                  ? const SizedBox()
                  : Align(
                      alignment: Alignment.topRight,
                      child: Text(
                        " أهلاً وسهلاً بك : ${SharedPrefController().getByKey(key: PrefKeys.firstname.name)}",
                        style: GoogleFonts.cairo(
                            fontWeight: FontWeight.bold, fontSize: 8.sp),
                      ),
                    ),
            ],
          ),
        ),
        Visibility(visible: _statusSearch, child: SizedBox(height: 16.h)),
        Visibility(
          visible: _statusSearch,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w),
            child: SizedBox(
              width: double.infinity.w,
              height: 40.h,
              child: TextField(
                controller: _gradeController,
                onChanged: (value) {},
                keyboardType: TextInputType.number,
                style: GoogleFonts.cairo(fontSize: 8.sp),
                decoration: InputDecoration(
                    labelText: 'الصف (على سبيل المثال، 2)',
                    hintText: "أدخل الصف الدراسي",
                    hintStyle: GoogleFonts.cairo(fontSize: 8.sp),
                    labelStyle: GoogleFonts.cairo(
                        fontSize: 8.sp, color: Colors.black54),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                        borderSide:
                            BorderSide(width: 1.w, color: Color(0xffef476f))),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                        borderSide: BorderSide(
                            width: 1.w, color: const Color(0xffef476f)))),
              ),
            ),
          ),
        ),
        Visibility(visible: _statusSearch, child: SizedBox(height: 16.h)),
        Visibility(
          visible: _statusSearch,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w),
            child: SizedBox(
              width: double.infinity.w,
              height: 40.h,
              child: TextField(
                controller: _searchController,
                onChanged: (value) {},
                keyboardType: TextInputType.text,
                style: GoogleFonts.cairo(fontSize: 8.sp),
                decoration: InputDecoration(
                    labelText: 'المادة (على سبيل المثال، الرياضيات)',
                    hintText: "أدخل إسم المادة",
                    hintStyle: GoogleFonts.cairo(fontSize: 8.sp),
                    labelStyle: GoogleFonts.cairo(
                        fontSize: 8.sp, color: Colors.black54),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                        borderSide:
                            BorderSide(width: 1.w, color: Color(0xffef476f))),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                        borderSide: BorderSide(
                            width: 1.w, color: const Color(0xffef476f)))),
              ),
            ),
          ),
        ),
        Visibility(visible: _statusSearch, child: SizedBox(height: 16.h)),
        _isLoading
            ? Visibility(
                visible: _statusSearch,
                child: SizedBox(
                  width: 20.w,
                  height: 20.h,
                  child: CircularProgressIndicator(
                    strokeWidth: 1.0.w,
                    color: const Color(0xff073b4c),
                  ),
                ),
              )
            : Visibility(
                visible: _statusSearch,
                child: ElevatedButton(
                  onPressed: _performSearch,
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      minimumSize: const Size(80, 35),
                      elevation: 0,
                      textStyle: GoogleFonts.cairo(),
                      backgroundColor: const Color(0xff073b4c)),
                  child: Text(
                    'بحث',
                    style: GoogleFonts.cairo(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 10.sp),
                  ),
                ),
              ),
        SizedBox(
          height: 20.h,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.w),
          child: Container(
            clipBehavior: Clip.antiAlias,
            width: 398.w,
            height: 166.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.r),
              color: Colors.grey.shade300,
            ),
            child: PageView.builder(
              controller: controller_page,
              itemCount: 3,
              onPageChanged: (page) {},
              itemBuilder: (_, index) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Image.asset(
                    'images/thanawy.jpg',
                    width: 398.w,
                    height: 166.h,
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),
          ),
        ),
        SizedBox(
          height: 14.h,
        ),
        SmoothPageIndicator(
          controller: controller_page,
          count: 3,
          effect: ExpandingDotsEffect(
              dotColor: const Color(0xfff58da6),
              activeDotColor: const Color(0xffef476f),
              dotWidth: 8.w,
              dotHeight: 8.h),
          // your preferred effect
          onDotClicked: (index) {},
        ),
        SizedBox(
          height: 20.h,
        ),
        FutureBuilder<List<HomeModel>>(
            future: _future,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Expanded(
                  child: Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: ListView.builder(
                          itemCount: 4,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 14.w, vertical: 10.h),
                              child: Container(
                                width: double.infinity.w,
                                height: 150.0.h,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(16.0.r),
                                ),
                              ),
                            );
                          })),
                );
              } else if (isConnected &&
                  snapshot.hasData) {
                return Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 14.w),
                    //shrinkWrap: true,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: ClipRRect(
                          borderRadius: BorderRadius.circular(12.r),
                          child: Image.asset(
                            'images/primary.jpg',
                            fit: BoxFit.cover,
                          ),
                        ),
                        contentPadding: EdgeInsets.zero,
                        subtitle: Align(
                          child: Text(snapshot.data![index].title!,
                              style: GoogleFonts.cairo(
                                fontWeight: FontWeight.bold,
                                fontSize: 12.sp,
                                color: const Color(0xff073b4c),
                              )),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PrimaryStages(
                                      id: snapshot.data![index].id.toString(),
                                      title: snapshot.data![index].title!,
                                    )),
                          );
                        },
                      );
                    },
                  ),
                );
              } else {
                return Center(
                  child: Text(
                    'لا يوجد بيانات',
                    style: GoogleFonts.cairo(
                        fontSize: 14.sp, fontWeight: FontWeight.bold),
                  ),
                );
              }
            }),
      ],
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
