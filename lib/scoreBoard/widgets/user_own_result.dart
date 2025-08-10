import 'package:flutter/material.dart';
import 'package:b_barna_app/core/constants/value_constants.dart';
import 'package:b_barna_app/scoreBoard/viewmodel/score_viewmodel.dart';
import 'package:b_barna_app/textSize/text_view_bold.dart';
import 'package:b_barna_app/textSize/text_view_normal.dart';
import 'package:b_barna_app/utils/sp_keys.dart';
import 'package:provider/provider.dart';

class UserOwnResult extends StatefulWidget {
  const UserOwnResult({super.key});

  @override
  State<UserOwnResult> createState() => _UserOwnResultState();
}

class _UserOwnResultState extends State<UserOwnResult> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 340,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: const Color(0xFF09636E).withOpacity(0.3),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextViewBold(
                    textContent: "${sp?.getStringFromPref(SPKeys.name)}",
                    textSizeNumber: 15,
                    textColor: Colors.black,
                  ),
                  TextViewNormal(
                    textContent:
                        "+91 ${sp?.getStringFromPref(SPKeys.phoneNumber)}",
                    textSizeNumber: 13,
                    textColor: Colors.black,
                  ),
                ],
              ),
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white),
                child: Image.asset(
                  "assets/images/png/user.png",
                  fit: BoxFit.fill,
                ),
              )
            ],
          ),
          Container(
            height: 1.5,
            color: Colors.black.withOpacity(0.5),
            margin: const EdgeInsets.only(
              top: 10,
              bottom: 10,
            ),
          ),
          Consumer<ScoreViewModel>(
            builder: (context, scoreDataProvider, child) {
              return scoreDataProvider.quizModel == null
                  ? const Center(child: CircularProgressIndicator())
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                TextViewBold(
                                  textContent:
                                      "Topic: ${scoreDataProvider.quizModel!.quizName}",
                                  textSizeNumber: 17,
                                  textColor: Colors.black,
                                ),
                              ],
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Icon(
                                  Icons.file_download_done_outlined,
                                  color: Colors.green.shade800,
                                  size: 30,
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextViewBold(
                                    textContent: "Scored",
                                    textSizeNumber: 14,
                                    textColor: Colors.black,
                                  ),
                                  TextViewNormal(
                                    textContent: getPoint(
                                        scoreDataProvider
                                            .quizModel!.correctAnswered,
                                        scoreDataProvider
                                            .quizModel!.questionList.length),
                                    textSizeNumber: 13,
                                    textColor: Colors.black,
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        Container(
                          height: 1.5,
                          color: Colors.black.withOpacity(0.5),
                          margin: const EdgeInsets.only(
                            top: 10,
                            bottom: 10,
                          ),
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Icon(
                                Icons.alarm_on_rounded,
                                color: Colors.amber.shade800,
                                size: 30,
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextViewBold(
                                  textContent: "Time Taken",
                                  textSizeNumber: 14,
                                  textColor: Colors.black,
                                ),
                                TextViewNormal(
                                  textContent: timeTaken(
                                      scoreDataProvider.quizModel!.timeTaken,
                                      scoreDataProvider.quizModel!.actualTime),
                                  textSizeNumber: 13,
                                  textColor: Colors.black,
                                ),
                              ],
                            )
                          ],
                        ),
                        Container(
                          height: 1.5,
                          color: Colors.black.withOpacity(0.5),
                          margin: const EdgeInsets.only(
                            top: 10,
                            bottom: 10,
                          ),
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.speaker_notes_sharp,
                              size: 30,
                              color: Colors.red.shade600,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: TextViewBold(
                                textContent:
                                    scoreDataProvider.quizModel!.quizName,
                                textSizeNumber: 15,
                                textColor: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  TextViewBold(
                                    textContent:
                                        "${scoreDataProvider.quizModel!.correctAnswered}",
                                    textSizeNumber: 11,
                                    textColor: Colors.black,
                                  ),
                                  TextViewBold(
                                    textContent: "Correct",
                                    textSizeNumber: 11,
                                    textColor: Colors.black,
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  TextViewBold(
                                    textContent:
                                        "${scoreDataProvider.quizModel!.wrongAnswered}",
                                    textSizeNumber: 11,
                                    textColor: Colors.black,
                                  ),
                                  TextViewBold(
                                    textContent: "Wrong",
                                    textSizeNumber: 11,
                                    textColor: Colors.black,
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  TextViewBold(
                                    textContent:
                                        "${scoreDataProvider.quizModel!.unAnswered}",
                                    textSizeNumber: 11,
                                    textColor: Colors.black,
                                  ),
                                  TextViewBold(
                                    textContent: "Unanswered",
                                    textSizeNumber: 11,
                                    textColor: Colors.black,
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  TextViewBold(
                                    textContent:
                                        "${scoreDataProvider.quizModel!.questionList.length}",
                                    textSizeNumber: 11,
                                    textColor: Colors.black,
                                  ),
                                  TextViewBold(
                                    textContent: "Total",
                                    textSizeNumber: 11,
                                    textColor: Colors.black,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    );
            },
          )
        ],
      ),
    );
  }

  String getPoint(int correctAnswer, int totalQuestion) {
    String point = "";
    point =
        "$correctAnswer / $totalQuestion - Point : ${(correctAnswer * 2)} - ${(correctAnswer / totalQuestion) * 100}%";
    return point;
  }

  String timeTaken(int timeTaken, int actualTime) {
    String time = "";
    int actualHour = 0;
    int actualMinute = 0;
    int actualSec = 0;
    int takenHour = 0;
    int takenMinute = 0;
    int takenSec = 0;
    if (actualTime >= 3600) {
      actualHour = actualTime ~/ 3600;
    } else if (actualTime >= 60) {
      actualMinute = actualTime ~/ 60;
    } else {
      actualSec = actualTime;
    }
    if (timeTaken >= 3600) {
      takenHour = timeTaken ~/ 3600;
    } else if (timeTaken >= 60) {
      takenMinute = timeTaken ~/ 60;
    } else {
      takenSec = timeTaken;
    }
    time =
        "${takenHour.toString().padLeft(2, "0")}:${takenMinute.toString().padLeft(2, "0")}:${takenSec.toString().padLeft(2, "0")} / ${actualHour.toString().padLeft(2, "0")}:${actualMinute.toString().padLeft(2, "0")}:${actualSec.toString().padLeft(2, "0")}";
    return time;
  }
}
