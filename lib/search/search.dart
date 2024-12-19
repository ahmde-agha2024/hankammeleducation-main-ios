import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hankammeleducation/model/book_list.dart';

// صفحة النتائج
class ResultsPage extends StatelessWidget {
  final List<BookListModel> results;

  ResultsPage({required this.results});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(
          'نتيجة البحث',
          style: GoogleFonts.cairo(
              color: Colors.black, fontSize: 10, fontWeight: FontWeight.bold),
        ),
      ),
      body: results.isEmpty
          ? Center(
              child: Text(
              "عذرًا، لم نجد ما تبحث عنه!",
              style:
                  GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 10),
            ))
          : ListView.builder(
              itemCount: results.length,
              itemBuilder: (context, index) {
                final course = results[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    color: Colors.white,
                    child: ListTile(
                      onTap: () {
                      },
                      title: Text(
                        course.title!,
                        style: GoogleFonts.cairo(
                            fontSize: 9, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        course.subTitle!,
                        style: GoogleFonts.cairo(
                            fontSize: 9, fontWeight: FontWeight.bold),
                      ),
                      trailing: Text(
                        course.courseFlag!,
                        style: GoogleFonts.cairo(
                            fontSize: 9, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
