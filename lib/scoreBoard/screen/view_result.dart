import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:b_barna_app/core/constants/value_constants.dart';
import 'package:b_barna_app/core/widgets/report_question_dialog.dart';
import 'package:b_barna_app/quiz/model/result_model.dart';
import 'package:b_barna_app/scoreBoard/viewmodel/score_viewmodel.dart';
import 'package:b_barna_app/scoreBoard/widgets/solution_appheader.dart';
import 'package:b_barna_app/textSize/text_view_bold.dart';
import 'package:b_barna_app/textSize/text_view_normal.dart';
import 'package:b_barna_app/utils/size_config.dart';
import 'package:provider/provider.dart';
import 'package:html/parser.dart' as html_parser;

// ignore: must_be_immutable
class ViewResult extends StatefulWidget {
  ResultModel? resultModel;

  ViewResult({required this.resultModel, super.key});

  @override
  State<ViewResult> createState() => _QuestionPaperScreenState();
}

class _QuestionPaperScreenState extends State<ViewResult> {
  @override
  void initState() {
    Provider.of<ScoreViewModel>(context, listen: false)
        .clearData(widget.resultModel?.questionList ?? []);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Container(
          color: const Color.fromARGB(255, 199, 233, 248),
          child: Consumer<ScoreViewModel>(
            builder: (context, scoreDataProvider, child) {
              return Column(
                children: [
                  SolutionAppHeader(resultModel: widget.resultModel),
                  Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: scoreDataProvider.questionList.length,
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
                                width: (MediaQuery.of(context).size.width) - 30,
                                padding: const EdgeInsets.only(
                                    left: 10, right: 10, top: 8, bottom: 8),
                                alignment: Alignment.centerLeft,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10)),
                                  color:
                                      const Color(0xFF09636E).withOpacity(0.5),
                                ),
                                child: TextViewBold(
                                  textContent:
                                      "${scoreDataProvider.selectedQuestionIndex + 1}.  ${parseHtmlString(
                                    getHTMLContent(widget
                                            .resultModel
                                            ?.questionList[scoreDataProvider
                                                .selectedQuestionIndex]
                                            .question ??
                                        ""),
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
                                      if (((widget
                                                  .resultModel
                                                  ?.questionList[
                                                      scoreDataProvider
                                                          .selectedQuestionIndex]
                                                  .questionBody !=
                                              stringDefault) &&
                                          widget
                                              .resultModel!
                                              .questionList[scoreDataProvider
                                                  .selectedQuestionIndex]
                                              .questionBody
                                              .trim()
                                              .isNotEmpty))
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 8),
                                          child: Html(
                                            data: widget
                                                .resultModel!
                                                .questionList[scoreDataProvider
                                                    .selectedQuestionIndex]
                                                .questionBody,
                                            style: {
                                              "p": Style(
                                                fontSize: FontSize(14.0),
                                                fontFamily: 'Kalpurush',
                                                lineHeight:
                                                    const LineHeight(1.5),
                                              ),
                                              "span": Style(
                                                fontSize: FontSize(14.0),
                                                fontFamily: 'Kalpurush',
                                              ),
                                            },
                                          ),
                                        ),
                                      Visibility(
                                        visible: (widget
                                                .resultModel!
                                                .questionList[scoreDataProvider
                                                    .selectedQuestionIndex]
                                                .option1 !=
                                            stringDefault),
                                        child: Container(
                                          margin: const EdgeInsets.symmetric(
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
                                                value: 1,
                                                groupValue: scoreDataProvider
                                                    .answerIndex,
                                                activeColor: Colors.green[800],
                                                onChanged: (value) {},
                                              ),
                                              Expanded(
                                                child: TextViewNormal(
                                                  textContent: parseHtmlString(
                                                      getHTMLContent(widget
                                                          .resultModel!
                                                          .questionList[
                                                              scoreDataProvider
                                                                  .selectedQuestionIndex]
                                                          .option1)),
                                                  textSizeNumber: 15,
                                                  textAlign: TextAlign.left,
                                                  textColor: Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Visibility(
                                        visible: (widget
                                                .resultModel!
                                                .questionList[scoreDataProvider
                                                    .selectedQuestionIndex]
                                                .option2 !=
                                            stringDefault),
                                        child: Container(
                                          margin: const EdgeInsets.symmetric(
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
                                                  value: 2,
                                                  groupValue: scoreDataProvider
                                                      .answerIndex,
                                                  activeColor:
                                                      Colors.green[800],
                                                  onChanged: (value) {}),
                                              Expanded(
                                                child: TextViewNormal(
                                                  textContent: parseHtmlString(
                                                      getHTMLContent(widget
                                                          .resultModel!
                                                          .questionList[
                                                              scoreDataProvider
                                                                  .selectedQuestionIndex]
                                                          .option2)),
                                                  textSizeNumber: 15,
                                                  textAlign: TextAlign.left,
                                                  textColor: Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Visibility(
                                        visible: (widget
                                                .resultModel!
                                                .questionList[scoreDataProvider
                                                    .selectedQuestionIndex]
                                                .option3 !=
                                            stringDefault),
                                        child: InkWell(
                                          onTap: () {},
                                          child: Container(
                                            margin: const EdgeInsets.symmetric(
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
                                                    value: 3,
                                                    groupValue:
                                                        scoreDataProvider
                                                            .answerIndex,
                                                    activeColor:
                                                        Colors.green[800],
                                                    onChanged: (value) {}),
                                                Expanded(
                                                  child: TextViewNormal(
                                                    textContent: parseHtmlString(
                                                        getHTMLContent(widget
                                                            .resultModel!
                                                            .questionList[
                                                                scoreDataProvider
                                                                    .selectedQuestionIndex]
                                                            .option3)),
                                                    textSizeNumber: 15,
                                                    textAlign: TextAlign.left,
                                                    textColor: Colors.black,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Visibility(
                                        visible: (widget
                                                .resultModel!
                                                .questionList[scoreDataProvider
                                                    .selectedQuestionIndex]
                                                .option4 !=
                                            stringDefault),
                                        child: InkWell(
                                          onTap: () {},
                                          child: Container(
                                            margin: const EdgeInsets.symmetric(
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
                                                    value: 4,
                                                    groupValue:
                                                        scoreDataProvider
                                                            .answerIndex,
                                                    activeColor:
                                                        Colors.green[800],
                                                    onChanged: (value) {}),
                                                Expanded(
                                                  child: TextViewNormal(
                                                    textContent: parseHtmlString(
                                                        getHTMLContent(widget
                                                            .resultModel!
                                                            .questionList[
                                                                scoreDataProvider
                                                                    .selectedQuestionIndex]
                                                            .option4)),
                                                    textSizeNumber: 15,
                                                    textAlign: TextAlign.left,
                                                    textColor: Colors.black,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        decoration: BoxDecoration(
                                            border: const Border(
                                              bottom: BorderSide(
                                                color: Colors.black,
                                                width: 1,
                                              ),
                                            ),
                                            color: (scoreDataProvider
                                                            .selectedAnswer ==
                                                        intDefault) ||
                                                    (scoreDataProvider
                                                            .selectedAnswer !=
                                                        scoreDataProvider
                                                            .answerIndex)
                                                ? Colors.red.shade100
                                                : Colors.green.shade100),
                                        child: SizedBox(
                                          height: 40,
                                          child: scoreDataProvider
                                                      .selectedAnswer ==
                                                  intDefault
                                              ? Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    const Icon(
                                                      Icons.close,
                                                      size: 20,
                                                      color: Colors.red,
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 8),
                                                      child: TextViewBold(
                                                        textContent:
                                                            "No option selected",
                                                        textSizeNumber: 14,
                                                        textColor: Colors.red,
                                                      ),
                                                    )
                                                  ],
                                                )
                                              : Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    TextViewBold(
                                                      textContent:
                                                          "You have selected option ${scoreDataProvider.selectedAnswer}",
                                                      textSizeNumber: 14,
                                                      textColor: Colors.black,
                                                    ),
                                                    Row(
                                                      children: [
                                                        Icon(
                                                          scoreDataProvider
                                                                      .selectedAnswer ==
                                                                  scoreDataProvider
                                                                      .answerIndex
                                                              ? Icons.check
                                                              : Icons.close,
                                                          size: 20,
                                                          color: scoreDataProvider
                                                                      .selectedAnswer ==
                                                                  scoreDataProvider
                                                                      .answerIndex
                                                              ? Colors.green
                                                              : Colors.red,
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 8),
                                                          child: TextViewBold(
                                                            textContent: scoreDataProvider
                                                                        .selectedAnswer ==
                                                                    scoreDataProvider
                                                                        .answerIndex
                                                                ? "Correct"
                                                                : "Wrong",
                                                            textSizeNumber: 14,
                                                            textColor: scoreDataProvider
                                                                        .selectedAnswer ==
                                                                    scoreDataProvider
                                                                        .answerIndex
                                                                ? Colors.green
                                                                : Colors.red,
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          reportQuestion(
                                              widget.resultModel!.quizName,
                                              parseHtmlString(getHTMLContent(
                                                  scoreDataProvider
                                                      .questionList[
                                                          scoreDataProvider
                                                              .selectedQuestionIndex]
                                                      .question)));
                                        },
                                        child: Container(
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          decoration: BoxDecoration(
                                              border: const Border(
                                                bottom: BorderSide(
                                                  color: Colors.black,
                                                  width: 1,
                                                ),
                                              ),
                                              color: Colors.red.shade100),
                                          child: SizedBox(
                                            height: 40,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                const Icon(
                                                  Icons.report,
                                                  size: 20,
                                                  color: Colors.red,
                                                ),
                                                const SizedBox(
                                                  width: 20,
                                                ),
                                                TextViewBold(
                                                  textContent:
                                                      "Report this question",
                                                  textSizeNumber: 14,
                                                  textColor: Colors.red,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      if (((scoreDataProvider
                                                  .questionList[scoreDataProvider
                                                      .selectedQuestionIndex]
                                                  .solution !=
                                              stringDefault) &&
                                          scoreDataProvider
                                              .questionList[scoreDataProvider
                                                  .selectedQuestionIndex]
                                              .solution
                                              .trim()
                                              .isNotEmpty))
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 8),
                                          child: Html(
                                            data:
                                                "Solution:${scoreDataProvider.questionList[scoreDataProvider.selectedQuestionIndex].solution.trim()}"
                                                    .trim(),
                                            style: {
                                              "p": Style(
                                                fontSize: FontSize(14.0),
                                                fontFamily: 'Kalpurush',
                                                lineHeight:
                                                    const LineHeight(1.5),
                                              ),
                                              "span": Style(
                                                fontSize: FontSize(14.0),
                                                fontFamily: 'Kalpurush',
                                              ),
                                            },
                                          ),
                                        )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                    height: 60,
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color(0xFF09636E).withOpacity(0.7),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: (SizeConfig.screenWidth! - 30) / 3,
                          child: Visibility(
                            visible:
                                (scoreDataProvider.selectedQuestionIndex > 0),
                            child: InkWell(
                              onTap: () {
                                scoreDataProvider.setQuestionIndex(
                                    index: (scoreDataProvider
                                            .selectedQuestionIndex -
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
                        Visibility(
                          visible:
                              (scoreDataProvider.selectedQuestionIndex + 1 <
                                  scoreDataProvider.questionList.length),
                          child: SizedBox(
                            width: (SizeConfig.screenWidth! - 30) / 3,
                            child: InkWell(
                              onTap: () {
                                scoreDataProvider.setQuestionIndex(
                                    index: (scoreDataProvider
                                            .selectedQuestionIndex +
                                        1));
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextViewBold(
                                    textContent: "Next",
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
                        ),
                      ],
                    ),
                  )
                ],
              );
            },
          )),
    ));
  }

  String getHTMLContent(String content) {
    var start =
        "<body style=\"background: #000000; color:#ffffff; height:auto\">";
    String end = "</body>";
    var htmlString = start + content + end;
    return htmlString;
  }

  String parseHtmlString(String htmlString) {
    final document = html_parser.parse(htmlString);
    final String parsedString = document.body?.text ?? '';
    return parsedString;
  }

  reportQuestion(String quizName, String questionName) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return ReportQuestionDialog(
              quizName: quizName, questionName: questionName);
        });
  }
}
