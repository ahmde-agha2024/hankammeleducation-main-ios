import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hankammeleducation/api/controllers/api_controller.dart';
import 'package:hankammeleducation/pref/shared_pref_controller.dart';
import 'package:hankammeleducation/screens/aboutscreen.dart';
import 'package:hankammeleducation/screens/auth_screens/login_screen.dart';
import 'package:hankammeleducation/screens/faqs.dart';
import 'package:hankammeleducation/screens/privacy_screen.dart';
import 'package:hankammeleducation/screens/termsandconditions.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hankammeleducation/widget/supportItem.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Align(
          alignment: Alignment.topRight,
          child: Text(
            "الصفحة الشخصية",
            style: GoogleFonts.cairo(
                fontWeight: FontWeight.bold, fontSize: 10.sp, color: Colors.teal),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(0.r),
          color: Colors.white,
        ),
        child: Column(
          children: [
            Padding(
              padding:  EdgeInsets.only(left: 10.w, right: 10.w),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: Colors.grey, width: 0.3.w),
                ),
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    SupportItem(
                      icon: Icons.info_outline,
                      title: 'حول التطبيق',
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const AboutScreen()));
                      },
                    ),
                    SupportItem(
                      icon: Icons.help_outline,
                      title: 'الأسئلة الأكثر شيوعاً',
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FaqsScreen()));
                      },
                    ),
                    SupportItem(
                      icon: Icons.format_list_numbered_rtl_rounded,
                      title: 'سياسة الخصوصية',
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const PrivacyScreen()));
                      },
                    ),
                    SupportItem(
                      icon: Icons.support,
                      title: 'الشروط والأحكام',
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const TermsAndConditions()));
                      },
                    ),
                    SharedPrefController()
                                .getByKey(key: PrefKeys.isLoggedIn.name) ==
                            null
                        ? SizedBox()
                        : SupportItem(
                            icon: Icons.person_remove,
                            title: 'إغلاق الحساب',
                            onTap: () {
                              _showConfirmationDialog(context);
                            },
                          ),
                  ],
                ),
              ),
            ),
            SharedPrefController().getByKey(key: PrefKeys.isLoggedIn.name) ==
                    null
                ? const SizedBox()
                : TextButton(
                    onPressed: () async {
                      await SharedPrefController().logout();
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                        (route) => false,
                      );
                    },
                    child: Text(
                      'تسجيل الخروج',
                      style: GoogleFonts.cairo(
                        color: Colors.teal,
                        fontSize: 9.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

void _showConfirmationDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          textAlign: TextAlign.center,
          'إغلاق الحساب',
          style: GoogleFonts.cairo(fontSize: 11.sp, fontWeight: FontWeight.bold,color: Colors.grey[700],),
        ),
        content: Text(
          textAlign: TextAlign.center,
          'هل أنت متأكد أنك تريد إغلاق الحساب نهائياً ؟',
          style: GoogleFonts.cairo(fontSize: 10.sp, fontWeight: FontWeight.w700),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(); // close Dialog
            },
            child: Text(
              'لا',
              style: GoogleFonts.cairo(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.black),
            ),
          ),
          TextButton(
            onPressed: () async {
              await _deleteAccount(context);
            },
            child: Text(
              'نعم',
              style: GoogleFonts.cairo(
                  fontSize: 10.sp, fontWeight: FontWeight.w700, color: Colors.red),
            ),
          ),
        ],
      );
    },
  );
}

Future<void> _deleteAccount(BuildContext context) async {
  var id = SharedPrefController().getByKey(key: PrefKeys.id.name);
  var statusOfDeleted = await ApiController().deleteAccount(id: id);
  if (statusOfDeleted) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
      (route) => false,
    );
  }
}
