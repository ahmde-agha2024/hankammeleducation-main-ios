import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hankammeleducation/utils/helpers.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfView extends StatefulWidget {
  PdfView({required this.title, required this.url, super.key});

  String title;
  String url;

  @override
  State<PdfView> createState() => _PdfViewState();
}

class _PdfViewState extends State<PdfView> with Helpers {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF2F4FA),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Color(0xff262E4A)),
        backgroundColor: const Color(0xffF2F4FA),
        elevation: 0,
        centerTitle: true,
        title: Text(
          widget.title,
          style: GoogleFonts.cairo(
              fontSize: 10.sp,
              fontWeight: FontWeight.w500,
              color: const Color(0xff262E4A)),
        ),
      ),
      body: SfPdfViewer.network(widget.url),
    );
  }
}
