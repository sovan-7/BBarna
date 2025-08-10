import 'package:flutter/material.dart';
import 'package:linear_timer/linear_timer.dart';
import 'package:b_barna_app/quiz/model/quiz_model.dart';
import 'package:b_barna_app/quiz/viewModel/quiz_viewmodel.dart';
import 'package:b_barna_app/quiz/widgets/display_board.dart';
import 'package:b_barna_app/textSize/text_view_bold.dart';
import 'package:b_barna_app/textSize/text_view_normal.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class QuestionPaperAppHeader extends StatefulWidget {
  QuizModel? quizModel;
  QuestionPaperAppHeader({required this.quizModel, super.key});

  @override
  State<QuestionPaperAppHeader> createState() => _QuestionPaperAppHeaderState();
}

class _QuestionPaperAppHeaderState extends State<QuestionPaperAppHeader>
    with TickerProviderStateMixin {
  late LinearTimerController timerController = LinearTimerController(this);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 170,
      width: (MediaQuery.of(context).size.width),
      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
      color: const Color(0xFF09636E),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const SizedBox(
                  width: 30,
                  child: Icon(
                    Icons.arrow_back_ios_new,
                    size: 30,
                    color: Colors.white,
                  ),
                ),
              ),
              Container(
                width: (MediaQuery.of(context).size.width) - 20 - 60 - 20,
                margin: const EdgeInsets.only(
                  left: 10,
                  right: 10,
                ),
                alignment: Alignment.center,
                child: TextViewBold(
                    textContent: "Topic : ${widget.quizModel?.name}",
                    textSizeNumber: 18),
              ),
              InkWell(
                onTap: () {
                  showModalBottomSheet(
                    barrierColor: Colors.transparent,
                    context: context,
                    builder: (context) {
                      return const DisplayBoard();
                    },
                  );
                },
                child: const SizedBox(
                  width: 30,
                  child: Icon(
                    Icons.filter_list,
                    size: 30,
                    color: Colors.black,
                  ),
                ),
              )
            ],
          ),
          Container(
            height: 70,
            padding: const EdgeInsets.only(
              left: 10,
              right: 10,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: const Alignment(0.8, 1),
                colors: <Color>[
                  Colors.white,
                  const Color(0xFF09636E).withOpacity(0.5),
                ],
                tileMode: TileMode.mirror,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Consumer<QuizViewModel>(
                        builder: (context, quizModel, child) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextViewNormal(
                            textContent: "Remaining Time",
                            textSizeNumber: 15,
                            textColor: Colors.black,
                          ),
                          TextViewBold(
                            textContent: quizModel.convertToHour(),
                            textSizeNumber: 15,
                            textColor: Colors.black,
                          ),
                        ],
                      );
                    }),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        TextViewNormal(
                          textContent: "Total Duration",
                          textSizeNumber: 15,
                          textColor: Colors.black,
                        ),
                        TextViewBold(
                          textContent: "${widget.quizModel?.totalTime} Minutes",
                          textSizeNumber: 15,
                          textColor: Colors.black,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
