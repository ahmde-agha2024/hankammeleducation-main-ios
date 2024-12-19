import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class SupportItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final void Function() onTap;

  const SupportItem(
      {required this.onTap,
      required this.icon,
      required this.title,
      super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 10.w),
      leading: Icon(
        icon,
        color: const Color(0xff073b4c),
      ),
      title: Text(
        title,
        style: GoogleFonts.cairo(fontSize: 8.sp, fontWeight: FontWeight.bold),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        color: const Color(0xff073b4c),
        size: 12.w,
      ),
      onTap: onTap,
    );
  }
}
