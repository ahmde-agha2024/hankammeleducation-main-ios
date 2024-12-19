import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hankammeleducation/notification/fb_notifications.dart';
import 'package:hankammeleducation/screens/launchscreen.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hankammeleducation/screens/connectionstate.dart';
import 'pref/shared_pref_controller.dart';
import 'service/firebase_notification_service.dart';

bool isConnected = false;

void main() async {
  await checkInternetConnection();
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefController().initPreferences();
  Platform.isIOS?await Firebase.initializeApp(options: const FirebaseOptions(apiKey: 'AIzaSyCZTLFVjzNxsRHt4U-wUY_olx2j4AA_i3Y', appId: '1:1084624060866:ios:a2937d062f36327150565b', messagingSenderId: '1084624060866', projectId: 'hankamel-talem')):  await Firebase.initializeApp(options: const FirebaseOptions(apiKey: 'AIzaSyCMZKRhwUS-MpxO4L9Ao7Lv9tR_BJENZ2E', appId: '1:1084624060866:android:46453d926d85784a50565b', messagingSenderId: '1084624060866', projectId: 'hankamel-talem'));

  await FirebaseMessaging.instance.requestPermission();
  await FbNotifications.initNotifications();
  await Hive.initFlutter(); // تهيئة Hive
  await Hive.openBox('downloads'); // فتح صندوق التحميلات
  await Hive.openBox('notifications');
  //WebViewPlatform.instance = WebWebViewPlatform();
  setupFirebaseMessaging();
  runApp(MyApp());
}

void setupFirebaseMessaging() {
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Foreground notification received: ${message.notification?.title}');
    FirebaseNotificationService.storeNotificationToHive(message);
  });
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print('Notification clicked: ${message.notification?.title}');
    FirebaseNotificationService.storeNotificationToHive(message);
  });
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Hive.initFlutter();
  await Hive.openBox('notifications');
  FirebaseNotificationService.storeNotificationToHive(message);
}

Future<void> checkInternetConnection() async {
  try {
    final result = await InternetAddress.lookup('example.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) ;
    isConnected = true;
  } on SocketException catch (_) {
    isConnected = false;
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 780), // db
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
            debugShowCheckedModeBanner: false,
            localizationsDelegates: const [
              //AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate
            ],
            supportedLocales: const [Locale('ar'), Locale('en')],
            locale: const Locale('ar'),
            title: '',
            theme: ThemeData(
              useMaterial3: true,
              primarySwatch: Colors.blue,
            ),
            home: isConnected
                ? const LaunchScreen()
                : const ConnectionStateScreen());
      },
    );
  }
}
