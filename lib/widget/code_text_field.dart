import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class CodeTextField extends StatelessWidget {
   const CodeTextField({
    required this.controllerText,
    required this.focusNode,
    required this.onChanged,
    required this.onSubmitted,
    super.key,
  });
  final TextEditingController controllerText;
  final FocusNode focusNode;
  final Function(String value) onChanged;
  final Function(String value) onSubmitted;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextField(
        controller: controllerText,
        focusNode: focusNode,
        autofocus: true,
        keyboardType: TextInputType.number,
        maxLength: 1,
        style: GoogleFonts.cairo(fontSize: 8.sp),
        textInputAction: TextInputAction.done,
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
            counterText: '',
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide:
                BorderSide(width: 1.w, color: Colors.black54)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(80.r),
                borderSide:
                BorderSide(width: 1.w, color: const Color(0xffef476f))
           )),
      ),
    );
  }
}
