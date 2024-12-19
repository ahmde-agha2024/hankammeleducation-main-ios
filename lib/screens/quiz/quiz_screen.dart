import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hankammeleducation/api/controllers/api_controller.dart';
import 'package:hankammeleducation/model/quiz.dart';
import 'package:hankammeleducation/utils/helpers.dart';
import 'package:shimmer/shimmer.dart';

class QuizScreen extends StatefulWidget {
  QuizScreen({required this.docId, required this.id, super.key});
  String docId;
  int id;

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> with Helpers {
  int _currentQuestionIndex = 0;
  List<String> _selectedOptions = []; // حفظ الاختيارات المتعددة
  List<String> _selectedOptionsUUID = []; // حفظ الاختيارات المتعددة
  bool _showAnswers = false;
  late Future<List<QuizRoot>> _future;
  bool isConnected = false;
  @override
  void initState() {
    checkInternetConnection();
    super.initState();
    _future = ApiController().getAllQuizzes(docId: widget.docId);
  }

  void _nextQuestion(List<Question> questions) {
    if (_currentQuestionIndex < questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _selectedOptions = [];
        _selectedOptionsUUID = [];
        _showAnswers = false;
      });
    } else {
      showSnackBar(context, message: 'انتهت الأسئلة!');
      Future.delayed(
        const Duration(seconds: 2),
        () {
          Navigator.pop(context);
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(
          'إختبر معلوماتك',
          style: GoogleFonts.cairo(
              color: Colors.black,
              fontSize: 10.sp,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: FutureBuilder<List<QuizRoot>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: _buildShimmer());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No questions available.'));
          } else if (isConnected && snapshot.hasData) {

            final questionType = snapshot.data![widget.id]
                .questions[_currentQuestionIndex].questionTitle;

            // final currentQuestion = snapshot.data![_currentQuestionIndex];
            // تحديد النوع

            return Padding(
              padding: EdgeInsets.all(16.0.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'السؤال ${_currentQuestionIndex + 1}/${snapshot.data![widget.id].questions.length}',
                    style: GoogleFonts.cairo(
                        fontWeight: FontWeight.bold, fontSize: 10.sp),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    snapshot.data![widget.id].questions[_currentQuestionIndex]
                        .questionTitle,
                    style: GoogleFonts.cairo(
                        fontWeight: FontWeight.bold, fontSize: 14.sp),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20.h),
                  Column(
                    children: questionType == 'select one'
                        ? _buildRadioOptions(snapshot
                            .data![widget.id].questions[_currentQuestionIndex])
                        : _buildCheckboxOptions(snapshot
                            .data![widget.id].questions[_currentQuestionIndex]),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () async {
                      if (_selectedOptions.isNotEmpty && _showAnswers) {
                        _nextQuestion(snapshot.data![widget.id].questions);
                      } else if (_selectedOptions.isEmpty) {
                        showSnackBar(context,
                            message: 'إختر إجابة لنرى إن كنت على صواب!ً');
                      } else {
                        for (int i = 0; i < _selectedOptions.length; i++) {
                          await ApiController().submitAnswerQuiz(
                              quizConnect: snapshot.data![widget.id].documentId,
                              questionConnect: snapshot.data![widget.id]
                                  .questions[_currentQuestionIndex].documentId,
                              answerId: _selectedOptionsUUID[i],
                              answer: _selectedOptions[i]);
                        }

                        setState(() {
                          _showAnswers = true;
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        minimumSize:  Size(double.infinity.w, 40.h),
                        elevation: 0,
                        textStyle: GoogleFonts.cairo(),
                        backgroundColor: const Color(0xff073b4c)),
                    child: Text(
                      _showAnswers ? "التالي" : "إكتشف الإجابة",
                      style: GoogleFonts.cairo(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 10.sp),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const Text("");
          }
        },
      ),
    );
  }

  List<Widget> _buildRadioOptions(Question currentQuestion) {
    return currentQuestion.answers.map((option) {
      Color optionColor = Colors.white;
      if (_showAnswers) {
        if (option.correctAnswer) {
          optionColor = Colors.green;
        } else if (_selectedOptions.contains(option.title)) {
          optionColor = Colors.red;
        }
      }

      return Card(
        color: optionColor,
        child: RadioListTile<String>(
          contentPadding: EdgeInsets.zero,
          title: Text(
            option.title,
            style: GoogleFonts.cairo(fontSize: 11.sp, fontWeight: FontWeight.w600),
          ),
          value: option.title,
          groupValue:
              _selectedOptions.isNotEmpty ? _selectedOptions.first : null,
          onChanged: (value) {
            if (!_showAnswers) {
              setState(() {
                _selectedOptions = [value!];
                _selectedOptionsUUID = [option.uuid];
                //_showAnswers = true;
              });
            }
          },
        ),
      );
    }).toList();
  }

  List<Widget> _buildCheckboxOptions(Question currentQuestion) {
    return currentQuestion.answers.map((option) {
      Color optionColor = Colors.white;
      if (_showAnswers) {
        if (option.correctAnswer) {
          optionColor = Colors.green;
        } else if (_selectedOptions.contains(option.title)) {
          optionColor = Colors.red;
        }
      }

      return Card(
        color: optionColor,
        child: CheckboxListTile(
          controlAffinity: ListTileControlAffinity.leading,
          title: Text(
            option.title,
            style:
                GoogleFonts.cairo(fontSize: 11.sp, fontWeight: FontWeight.w600),
          ),
          value: _selectedOptions.contains(option.title),
          onChanged: (value) {
            if (!_showAnswers) {
              setState(() {
                if (value == true) {
                  _selectedOptions.add(option.title);
                  _selectedOptionsUUID.add(option.uuid);
                } else {
                  _selectedOptions.remove(option.title);
                  _selectedOptionsUUID.remove(option.uuid);
                }
              });
            }
          },
        ),
      );
    }).toList();
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

Widget _buildShimmer() {
  return Padding(
    padding: EdgeInsets.all(16.0.r),
    child: Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          width: double.infinity.w,
          height: 20.0.h,
          color: Colors.white,
        ),
        SizedBox(height: 10.h),
        Container(
          width: double.infinity.w,
          height: 20.0.h,
          color: Colors.white,
        ),
        SizedBox(height: 20.h),
        Container(
          width: 50.w,
          height: 20.0.h,
          color: Colors.white,
        ),
        SizedBox(height: 10.h),
        Container(
          width: 50.w,
          height: 20.0.h,
          color: Colors.white,
        ),
        SizedBox(height: 10.h),
        Container(
          width: 50.w,
          height: 20.0.h,
          color: Colors.white,
        ),
        const Spacer(),
        Container(
          width: double.infinity.w,
          height: 40.0.h,
          color: Colors.white,
        ),
      ]),
    ),
  );
}
