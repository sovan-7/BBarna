import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html_table/flutter_html_table.dart';
import 'package:b_barna_app/core/constants/value_constants.dart';
import 'package:b_barna_app/core/widgets/submit_quiz_dialog.dart';
import 'package:b_barna_app/quiz/model/quiz_model.dart';
import 'package:b_barna_app/quiz/viewModel/quiz_viewmodel.dart';
import 'package:b_barna_app/quiz/widgets/display_board.dart';
import 'package:b_barna_app/quiz/widgets/question_paper_app_header.dart';
import 'package:b_barna_app/textSize/text_view_bold.dart';
import 'package:b_barna_app/textSize/text_view_normal.dart';
import 'package:b_barna_app/utils/size_config.dart';
import 'package:provider/provider.dart';
import 'package:html/parser.dart' as html_parser;

// ignore: must_be_immutable
class QuestionPaperScreen extends StatefulWidget {
  QuizModel? quizModel;

  QuestionPaperScreen({required this.quizModel, super.key});

  @override
  State<QuestionPaperScreen> createState() => _QuestionPaperScreenState();
}

class _QuestionPaperScreenState extends State<QuestionPaperScreen> {
  @override
  void initState() {
    QuizViewModel quizViewModel =
        Provider.of<QuizViewModel>(context, listen: false);
    quizViewModel.clearQuizQuestion();
    quizViewModel.storeQuizDetails(
        widget.quizModel!.code, widget.quizModel!.name);
    quizViewModel
        .fetchQuizQuestionList(widget.quizModel?.questionCodeList ?? []);
    quizViewModel.setQuizTime(widget.quizModel!.totalTime);
    quizViewModel.startTimer();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Container(
        color: const Color(0xFF09636E).withOpacity(0.3),
        //const Color.fromARGB(255, 199, 233, 248),
        child: Consumer<QuizViewModel>(
          builder: (context, quizDataProvider, child) {
            return Column(
              children: [
                QuestionPaperAppHeader(quizModel: widget.quizModel),
                Expanded(
                  child: Stack(
                    children: [
                      ListView.builder(
                        scrollDirection: Axis.horizontal,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: quizDataProvider.quizQuestionList.length,
                        itemBuilder: (context, index) {
                          return Container(
                            width: (MediaQuery.of(context).size.width) - 40,
                            margin: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                            ),
                            child: Column(
                              children: [
                                Container(
                                  width:
                                      (MediaQuery.of(context).size.width) - 30,
                                  padding: const EdgeInsets.only(
                                      left: 10, right: 10, top: 8, bottom: 8),
                                  alignment: Alignment.centerLeft,
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(10)),
                                    color: const Color(0xFF09636E)
                                        .withOpacity(0.5),
                                  ),
                                  child: TextViewBold(
                                    textContent:
                                        "${quizDataProvider.selectedQuestionIndex + 1}.  ${parseHtmlString(
                                      getHTMLContent(quizDataProvider
                                          .quizQuestionList[quizDataProvider
                                              .selectedQuestionIndex]
                                          .question),
                                    )}",
                                    textSizeNumber: 17,
                                    textColor: Colors.black,
                                  ),
                                ),
                                Expanded(
                                  child: SingleChildScrollView(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        if (((quizDataProvider
                                                    .quizQuestionList[
                                                        quizDataProvider
                                                            .selectedQuestionIndex]
                                                    .questionBody !=
                                                stringDefault) &&
                                            quizDataProvider
                                                .quizQuestionList[
                                                    quizDataProvider
                                                        .selectedQuestionIndex]
                                                .questionBody
                                                .trim()
                                                .isNotEmpty))
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 8),
                                            child: Html(
                                              data: quizDataProvider
                                                  .quizQuestionList[
                                                      quizDataProvider
                                                          .selectedQuestionIndex]
                                                  .questionBody,
                                              style: {
                                                "table": Style(
                                                  border: Border.all(
                                                      color: Colors.grey),
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  padding: HtmlPaddings.all(8),
                                                ),
                                                "td": Style(
                                                  border: Border.all(
                                                      color: Colors.white),
                                                  padding: HtmlPaddings.all(6),
                                                  fontSize: FontSize(14.0),
                                                  fontFamily: 'Kalpurush',
                                                  color: Colors.white,
                                                ),
                                                "th": Style(
                                                  padding: HtmlPaddings.all(6),
                                                  backgroundColor:
                                                      Colors.grey.shade700,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                "p": Style(
                                                  fontSize: FontSize(14.0),
                                                  color: Colors.white,
                                                ),
                                              },
                                              extensions: const [
                                                TableHtmlExtension(), // IMPORTANT to render tables
                                              ],
                                            ),
                                            //   TextViewBold(
                                            //       textContent: parseHtmlString(
                                            //           getHTMLContent(quizDataProvider
                                            //               .quizQuestionList[
                                            //                   quizDataProvider
                                            //                       .selectedQuestionIndex]
                                            //               .questionBody)),
                                            //       textColor: Colors.black,
                                            //       textSizeNumber: 14),
                                          ),
                                        Visibility(
                                          visible: (quizDataProvider
                                                  .quizQuestionList[
                                                      quizDataProvider
                                                          .selectedQuestionIndex]
                                                  .option1 !=
                                              stringDefault),
                                          child: InkWell(
                                            onTap: () {
                                              quizDataProvider
                                                  .setAnswerByUser(1);
                                            },
                                            child: Container(
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10),
                                              decoration: const BoxDecoration(
                                                  border: Border(
                                                      bottom: BorderSide(
                                                color: Colors.black,
                                                width: 1,
                                              ))),
                                              child: Row(
                                                children: [
                                                  Radio(
                                                      activeColor: const Color(
                                                          0xFF09636E),
                                                      value: 1,
                                                      groupValue: quizDataProvider
                                                          .quizQuestionList[
                                                              quizDataProvider
                                                                  .selectedQuestionIndex]
                                                          .selectedAnswer,
                                                      onChanged: (value) {
                                                        quizDataProvider
                                                            .setAnswerByUser(1);
                                                      }),
                                                  Expanded(
                                                    child: TextViewNormal(
                                                      textContent: parseHtmlString(
                                                          getHTMLContent(quizDataProvider
                                                              .quizQuestionList[
                                                                  quizDataProvider
                                                                      .selectedQuestionIndex]
                                                              .option1)),
                                                      textSizeNumber: 15,
                                                      textAlign:
                                                          TextAlign.start,
                                                      textColor: Colors.black,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Visibility(
                                          visible: (quizDataProvider
                                                  .quizQuestionList[
                                                      quizDataProvider
                                                          .selectedQuestionIndex]
                                                  .option2 !=
                                              stringDefault),
                                          child: InkWell(
                                            onTap: () {
                                              quizDataProvider
                                                  .setAnswerByUser(2);
                                            },
                                            child: Container(
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10),
                                              decoration: const BoxDecoration(
                                                  border: Border(
                                                      bottom: BorderSide(
                                                color: Colors.black,
                                                width: 1,
                                              ))),
                                              child: Row(
                                                children: [
                                                  Radio(
                                                      activeColor: const Color(
                                                          0xFF09636E),
                                                      value: 2,
                                                      groupValue: quizDataProvider
                                                          .quizQuestionList[
                                                              quizDataProvider
                                                                  .selectedQuestionIndex]
                                                          .selectedAnswer,
                                                      onChanged: (value) {
                                                        quizDataProvider
                                                            .setAnswerByUser(2);
                                                      }),
                                                  Expanded(
                                                    child: TextViewNormal(
                                                      textContent: parseHtmlString(
                                                          getHTMLContent(quizDataProvider
                                                              .quizQuestionList[
                                                                  quizDataProvider
                                                                      .selectedQuestionIndex]
                                                              .option2)),
                                                      textSizeNumber: 15,
                                                      textAlign:
                                                          TextAlign.start,
                                                      textColor: Colors.black,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Visibility(
                                          visible: (quizDataProvider
                                                  .quizQuestionList[
                                                      quizDataProvider
                                                          .selectedQuestionIndex]
                                                  .option3 !=
                                              stringDefault),
                                          child: InkWell(
                                            onTap: () {
                                              quizDataProvider
                                                  .setAnswerByUser(3);
                                            },
                                            child: Container(
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10),
                                              decoration: const BoxDecoration(
                                                  border: Border(
                                                      bottom: BorderSide(
                                                color: Colors.black,
                                                width: 1,
                                              ))),
                                              child: Row(
                                                children: [
                                                  Radio(
                                                      activeColor: const Color(
                                                          0xFF09636E),
                                                      value: 3,
                                                      groupValue: quizDataProvider
                                                          .quizQuestionList[
                                                              quizDataProvider
                                                                  .selectedQuestionIndex]
                                                          .selectedAnswer,
                                                      onChanged: (value) {
                                                        quizDataProvider
                                                            .setAnswerByUser(3);
                                                      }),
                                                  Expanded(
                                                    child: TextViewNormal(
                                                      textContent: parseHtmlString(
                                                          getHTMLContent(quizDataProvider
                                                              .quizQuestionList[
                                                                  quizDataProvider
                                                                      .selectedQuestionIndex]
                                                              .option3)),
                                                      textSizeNumber: 15,
                                                      textColor: Colors.black,
                                                      textAlign:
                                                          TextAlign.start,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Visibility(
                                          visible: (quizDataProvider
                                                  .quizQuestionList[
                                                      quizDataProvider
                                                          .selectedQuestionIndex]
                                                  .option4 !=
                                              stringDefault),
                                          child: InkWell(
                                            onTap: () {
                                              quizDataProvider
                                                  .setAnswerByUser(4);
                                            },
                                            child: Container(
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10),
                                              decoration: const BoxDecoration(
                                                  border: Border(
                                                      bottom: BorderSide(
                                                color: Colors.black,
                                                width: 1,
                                              ))),
                                              child: Row(
                                                children: [
                                                  Radio(
                                                      activeColor: const Color(
                                                          0xFF09636E),
                                                      value: 4,
                                                      groupValue: quizDataProvider
                                                          .quizQuestionList[
                                                              quizDataProvider
                                                                  .selectedQuestionIndex]
                                                          .selectedAnswer,
                                                      onChanged: (value) {
                                                        quizDataProvider
                                                            .setAnswerByUser(4);
                                                      }),
                                                  Expanded(
                                                    child: TextViewNormal(
                                                      textContent: parseHtmlString(
                                                          getHTMLContent(quizDataProvider
                                                              .quizQuestionList[
                                                                  quizDataProvider
                                                                      .selectedQuestionIndex]
                                                              .option4)),
                                                      textSizeNumber: 15,
                                                      textAlign:
                                                          TextAlign.start,
                                                      textColor: Colors.black,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      Visibility(
                        visible: quizDataProvider.isSubmitted,
                        child: Positioned(
                            top: ((SizeConfig.safeBlockVertical! * 100) / 2) -
                                150,
                            left: (SizeConfig.screenWidth! / 2) - 30,
                            child: const CircularProgressIndicator()),
                      )
                    ],
                  ),
                ),
                // const Spacer(),
                Container(
                  height: 60,
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    // borderRadius: BorderRadius.circular(
                    //   5,
                    // ),
                    color: const Color(0xFF09636E).withOpacity(0.7),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: (SizeConfig.screenWidth! - 30) / 3,
                        child: Visibility(
                          visible: (quizDataProvider.selectedQuestionIndex > 0),
                          child: InkWell(
                            onTap: () {
                              quizDataProvider.setQuestionIndex(
                                  index:
                                      (quizDataProvider.selectedQuestionIndex -
                                          1));
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Icon(
                                  Icons.arrow_left,
                                  size: 25,
                                  color: Colors.black,
                                ),
                                TextViewBold(
                                  textContent: "Previous",
                                  textSizeNumber: 15,
                                  textColor: Colors.black,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: (SizeConfig.screenWidth! - 30) / 3,
                        alignment: Alignment.center,
                        child: Center(
                          child: InkWell(
                            onTap: () {
                              showModalBottomSheet(
                                barrierColor: Colors.transparent,
                                context: context,
                                builder: (context) {
                                  return const DisplayBoard();
                                },
                              );
                            },
                            child: Container(
                              height: 35,
                              width: 100,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: const Color(0xFF09636E),
                              ),
                              child: TextViewBold(
                                  textContent: "REVIEW", textSizeNumber: 16),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: (SizeConfig.screenWidth! - 30) / 3,
                        child: InkWell(
                          onTap: () {
                            if (quizDataProvider.selectedQuestionIndex + 1 ==
                                quizDataProvider.quizQuestionList.length) {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return SubmitQuizDialog(
                                    onSubmit: () {
                                      //submit quiz
                                      quizDataProvider.getAnswerCount();
                                    },
                                  );
                                },
                              );
                            } else {
                              quizDataProvider.setQuestionIndex(
                                  index:
                                      (quizDataProvider.selectedQuestionIndex +
                                          1));
                            }
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextViewBold(
                                textContent: getTittle(),
                                textSizeNumber: 15,
                                textColor: Colors.black,
                              ),
                              const Icon(
                                Icons.arrow_right,
                                size: 25,
                                color: Colors.black,
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            );
          },
        ),
      ),
    ));
  }

  String getTittle() {
    String tittle = "";
    QuizViewModel quizViewModel =
        Provider.of<QuizViewModel>(context, listen: false);
    if (quizViewModel.selectedQuestionIndex + 1 ==
        quizViewModel.quizQuestionList.length) {
      tittle = "Submit";
    } else {
      tittle = "Next";
    }
    return tittle;
  }

  String getHTMLContent(String content) {
    return '''
    <!DOCTYPE html>
    <html>
    <head>
      <meta charset="UTF-8">
      <style>
        @font-face {
          font-family: 'Kalpurush';
          src: url('https://cdn.jsdelivr.net/gh/sovon/kalpurush/kalpurush.ttf') format('truetype');
        }
        body {
          background-color: #000000;
          color: #ffffff;
          font-family: Kalpurush, sans-serif;
        }
      </style>
    </head>
    <body>
      $content
    </body>
    </html>
  ''';
  }

  String parseHtmlString(String htmlString) {
    final document = html_parser.parse(htmlString);
    final String parsedString = document.body?.text ?? '';
    return parsedString;
  }
}
