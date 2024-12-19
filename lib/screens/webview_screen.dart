import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webviewx_plus/webviewx_plus.dart';

class WebViewXPlusScreen extends StatelessWidget {
  WebViewXPlusScreen({required this.title, required this.url, super.key});

  String title;
  String url;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Color(0xff262E4A)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          title,
          style: GoogleFonts.cairo(
              fontSize: 10.sp,
              fontWeight: FontWeight.w500,
              color: const Color(0xff262E4A)),
        ),
      ),
      body: WebViewX(
        initialContent: url,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        onWebViewCreated: (controller) {},
        onPageStarted: (url) {},
        onPageFinished: (url) {},
      ),
    );
  }
}
