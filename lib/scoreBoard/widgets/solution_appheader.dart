import 'package:flutter/material.dart';
import 'package:linear_timer/linear_timer.dart';
import 'package:b_barna_app/quiz/model/result_model.dart';
import 'package:b_barna_app/scoreBoard/widgets/result_display_board.dart';
import 'package:b_barna_app/textSize/text_view_bold.dart';

// ignore: must_be_immutable
class SolutionAppHeader extends StatefulWidget {
  ResultModel? resultModel;
  SolutionAppHeader({required this.resultModel, super.key});

  @override
  State<SolutionAppHeader> createState() => _QuestionPaperAppHeaderState();
}

class _QuestionPaperAppHeaderState extends State<SolutionAppHeader>
    with TickerProviderStateMixin {
  late LinearTimerController timerController = LinearTimerController(this);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: (MediaQuery.of(context).size.width),
      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
      color: const Color(0xFF09636E),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
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
                    textContent: "Topic : ${widget.resultModel?.quizName}",
                    textSizeNumber: 18),
              ),
              InkWell(
                onTap: () {
                  showModalBottomSheet(
                    barrierColor: Colors.transparent,
                    context: context,
                    builder: (context) {
                      return const ResultDisplayBoard();
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
          // Container(
          //   height: 70,
          //   padding: const EdgeInsets.only(
          //     left: 10,
          //     right: 10,
          //   ),
          //   decoration: BoxDecoration(
          //     borderRadius: BorderRadius.circular(10),
          //     gradient: const LinearGradient(
          //       begin: Alignment.topLeft,
          //       end: Alignment(0.8, 1),
          //       colors: <Color>[
          //         Colors.white,
          //         Colors.lightBlue,
          //       ],
          //       tileMode: TileMode.mirror,
          //     ),
          //   ),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.start,
          //     children: [
          //       TextViewNormal(
          //         textContent: "Total Duration: ",
          //         textSizeNumber: 15,
          //         textColor: Colors.black,
          //       ),
          //       TextViewBold(
          //         textContent:
          //             getQuizTime(widget.resultModel!.actualTime ~/ 60),
          //         textSizeNumber: 15,
          //         textColor: Colors.black,
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }

  // String getQuizTime(int quizTime) {
  //   String time = "";
  //   if (quizTime >= 60) {
  //     int hour = quizTime ~/ 60;
  //     int minute = (quizTime - (hour * 60));
  //     if (minute > 0) {
  //       time = "$hour Hour $minute Minutes";
  //     } else {
  //       time = "$hour Hour";
  //     }
  //   } else {
  //     time = "$quizTime Minute";
  //   }
  //   return time;
  // }
}
