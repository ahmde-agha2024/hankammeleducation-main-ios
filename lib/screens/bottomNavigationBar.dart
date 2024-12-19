import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hankammeleducation/mydownloadcourses.dart';
import 'package:hankammeleducation/screens/home_screen.dart';
import 'package:hankammeleducation/screens/muCoursrs.dart';
import 'package:hankammeleducation/widget/btn_screen.dart';
import 'profile_screen.dart';

class BottomNavigationScreen extends StatefulWidget {
  BottomNavigationScreen({Key? key}) : super(key: key);

  @override
  State<BottomNavigationScreen> createState() => _BottomNavigationScreenState();
}

class _BottomNavigationScreenState extends State<BottomNavigationScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  late final List<BtnScreen> _btnScreen = <BtnScreen>[
    const BtnScreen(widget: HomeScreen(), title: 'Home'),
    BtnScreen(widget: MyCourses(), title: 'My Course'),
    BtnScreen(widget: MyDownloads(), title: 'Downloads'),
    BtnScreen(widget: ProfileScreen(), title: 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        body: _btnScreen[_currentIndex].widget,
        bottomNavigationBar: ClipRRect(
          borderRadius: BorderRadiusDirectional.only(
              topStart: Radius.circular(24.r), topEnd: Radius.circular(24.r)),
          child: BottomNavigationBar(
            onTap: (int currentIndex) {
              setState(() => _currentIndex = currentIndex);
            },
            currentIndex: _currentIndex,
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            selectedItemColor: const Color(0xffef476f),
            selectedIconTheme: const IconThemeData(
              color: Color(0xffef476f),
            ),
            unselectedItemColor: const Color(0xffC2C2C2),
            unselectedIconTheme: const IconThemeData(
              color: Color(0xffC2C2C2),
            ),
            selectedLabelStyle:
                GoogleFonts.cairo(fontWeight: FontWeight.w600, height: 2.h),
            unselectedLabelStyle:
                GoogleFonts.cairo(fontWeight: FontWeight.w400, height: 2.h),
            selectedFontSize: 10.sp,
            unselectedFontSize: 10.sp,
            items: [
              BottomNavigationBarItem(
                activeIcon: ImageIcon(
                  const AssetImage('images/home.png'),
                  size: 20.w,
                ),
                icon: ImageIcon(
                  const AssetImage('images/home.png'),
                  size: 18.w,
                ),
                label: "الرئيسية",
              ),
              BottomNavigationBarItem(
                activeIcon: ImageIcon(const AssetImage('images/mycourse.png'),
                    size: 20.w),
                icon: ImageIcon(
                  const AssetImage('images/mycourse.png'),
                  size: 18.w,
                ),
                label: "موادي",
              ),
              BottomNavigationBarItem(
                activeIcon: ImageIcon(const AssetImage('images/download.png'),
                    size: 20.w),
                icon: ImageIcon(
                  const AssetImage('images/download.png'),
                  size: 18.w,
                ),
                label: "التحميلات",
              ),
              BottomNavigationBarItem(
                activeIcon:
                    ImageIcon(const AssetImage('images/ProfileIcon.png'), size: 20.w),
                icon: ImageIcon(
                 const  AssetImage('images/ProfileIcon.png'),
                  size: 18.w,
                ),
                label: "الملف الشخصي",
              ),
            ],
          ),
        ));
  }
}
