import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hankammeleducation/api/controllers/api_controller.dart';
import 'package:hankammeleducation/notification/fb_notifications.dart';
import 'package:hankammeleducation/pref/shared_pref_controller.dart';
import 'package:hankammeleducation/screens/auth_screens/login_screen.dart';
import 'package:hankammeleducation/screens/bottomNavigationBar.dart';
import 'package:device_info_plus/device_info_plus.dart';

class LaunchScreen extends StatefulWidget {
  const LaunchScreen({Key? key}) : super(key: key);

  @override
  State<LaunchScreen> createState() => _LaunchScreenState();
}

class _LaunchScreenState extends State<LaunchScreen> with FbNotifications {

  String tokenDevice = '';
  String deviceType = '';
  String deviceName = '';
  String osVersion = '';

  @override
  void initState() {
    super.initState();
    requestNotificationPermissions();
    initializeForegroundNotificationForAndroid();
    var saveInfoForNotification = SharedPrefController().deviceInfo;
    if (!saveInfoForNotification && SharedPrefController().loggedIn) {
      fetchDeviceInfo();
    }
    Future.delayed(const Duration(seconds: 3), () async {
      var route = SharedPrefController().loggedIn
          ? BottomNavigationScreen()
          : LoginScreen();
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => route));
    });
  }

  Future<void> fetchDeviceInfo() async {
    try {
      // 1. الحصول على Firebase Token
      String? token = await FirebaseMessaging.instance.getToken();
      setState(() {
        tokenDevice = token ?? 'No Token Available';
      });

      // 2. الحصول على معلومات الجهاز
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      if (Theme
          .of(context)
          .platform == TargetPlatform.android) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        setState(() {
          deviceType = 'android';
          deviceName = androidInfo.model ?? 'Unknown';
          osVersion = androidInfo.version.release ?? 'Unknown';
        });
      } else if (Theme
          .of(context)
          .platform == TargetPlatform.iOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        setState(() {
          deviceType = 'iOS';
          deviceName = iosInfo.utsname.machine ?? 'Unknown';
          osVersion = iosInfo.systemVersion ?? 'Unknown';
        });
      }
    } catch (error) {
      print('Error fetching device info: $error');
    }
    await SharedPrefController().notificationSaveInfo();
    print("sfnvbjfn ");
    await ApiController().addDeviceNotification(
        tokenDevice: tokenDevice,
        deviceType: deviceType,
        deviceName: deviceName,
        osVersion: osVersion
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body:  Container(
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Container(
                    height: 180.h,
                    width: 180.w,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                          'images/thumbnail_Logo.png',
                        ),
                      ),
                    ),
                  ),
                ),
                Text(
                  'حنكمـــل تعليـــم',
                  style: GoogleFonts.cairo(color: const Color(0xff118ab2),
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold),
                ),

              ],
            ),
          )),
    );
  }
}
