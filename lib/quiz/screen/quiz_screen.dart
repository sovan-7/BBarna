import 'package:flutter/material.dart';
import 'package:b_barna_app/core/route/route_name.dart';
import 'package:b_barna_app/core/widgets/app_header.dart';
import 'package:b_barna_app/quiz/viewModel/quiz_viewmodel.dart';
import 'package:b_barna_app/textSize/text_view_bold.dart';
import 'package:b_barna_app/utils/helper.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class QuizScreen extends StatefulWidget {
  List<String> quizCodeList;
  QuizScreen({required this.quizCodeList, super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  @override
  void initState() {
    QuizViewModel quizViewModel =
        Provider.of<QuizViewModel>(context, listen: false);
    quizViewModel.clearQuizList();
    quizViewModel.fetchQuizList(widget.quizCodeList);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Column(
        children: [
          AppHeader(
            shouldLanguageIconVisible: false,
            isBackVisible: true,
          ),
          Expanded(
            child: Consumer<QuizViewModel>(
              builder: (context, quizDataProvider, child) {
                return ListView.builder(
                  itemCount: quizDataProvider.quizList.length,
                  itemBuilder: (context, index) {
                    return Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey)),
                      margin: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 15),
                      padding: const EdgeInsets.only(top: 10, bottom: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          TextViewBold(
                            textContent: quizDataProvider.quizList[index].name,
                            textSizeNumber: 22,
                            textColor: Colors.black,
                            textAlign: TextAlign.center,
                          ),
                          TextViewBold(
                            textContent:
                                "Total Duration : ${getQuizTime(quizDataProvider.quizList[index].totalTime)}",
                            textSizeNumber: 22,
                            textColor: Colors.black,
                          ),
                          TextViewBold(
                            textContent:
                                "Total Question : ${quizDataProvider.quizList[index].totalQuestion}",
                            textSizeNumber: 22,
                            textColor: Colors.black,
                          ),
                          const SizedBox(height: 30),
                          // const Spacer(),
                          InkWell(
                            onTap: () {
                              if (quizDataProvider
                                      .quizList[index].totalQuestion !=
                                  0) {
                                Navigator.pushNamed(
                                    context, RouteName.questionPaperScreenRoute,
                                    arguments: {
                                      "quizModel":
                                          quizDataProvider.quizList[index]
                                    });
                              } else {
                                Helper.showSnackBarMessage(
                                    msg:
                                        "Question is not uploaded, please contact with your teacher.",
                                    isSuccess: false);
                              }
                            },
                            child: Container(
                              height: 50,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: const Color(0xFF09636E).withOpacity(0.8),
                              ),
                              margin: const EdgeInsets.only(
                                left: 15,
                                right: 15,
                              ),
                              child: TextViewBold(
                                textContent: "Start Quiz",
                                textSizeNumber: 17,
                                textColor: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
    ));
  }

  String getQuizTime(int quizTime) {
    String time = "";
    if (quizTime >= 60) {
      int hour = quizTime ~/ 60;
      int minute = (quizTime - (hour * 60));
      if (minute > 0) {
        time = "$hour Hour $minute Minutes";
      } else {
        time = "$hour Hour";
      }
    } else {
      time = "$quizTime Minute";
    }
    return time;
  }
}
