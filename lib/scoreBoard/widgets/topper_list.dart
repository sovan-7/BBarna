import 'package:flutter/material.dart';
import 'package:b_barna_app/scoreBoard/viewmodel/score_viewmodel.dart';
import 'package:b_barna_app/textSize/text_view_bold.dart';
import 'package:b_barna_app/textSize/text_view_normal.dart';
import 'package:b_barna_app/utils/size_config.dart';
import 'package:provider/provider.dart';

class ToppersList extends StatelessWidget {
  const ToppersList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ScoreViewModel>(
      builder: (context, scoreDataProvider, child) {
        return Expanded(
            child: Container(
          margin: const EdgeInsets.only(
            top: 10,
          ),
          padding: const EdgeInsets.only(left: 10.0, right: 10.0),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
          child: Column(
            children: [
              Container(
                height: 50,
                width: SizeConfig.screenWidth,
                // padding: const EdgeInsets.only(left: 10.0),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8)),
                  color: const Color(0xFF09636E).withOpacity(0.7),
                ),
                child: TextViewBold(
                  textContent: "Toppers List",
                  textSizeNumber: 17,
                  textColor: Colors.black,
                ),
              ),
              Expanded(
                child: Container(
                  color: const Color(0xFF09636E).withOpacity(0.3),
                  child: ListView.builder(
                      itemCount: scoreDataProvider.topperList.length,
                      itemBuilder: ((context, index) {
                        return Container(
                          margin: const EdgeInsets.only(
                            left: 10,
                            right: 10,
                          ),
                          padding: const EdgeInsets.only(top: 8, bottom: 8),
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      color: Colors.black.withOpacity(0.5),
                                      width: 1.5))),
                          child: Row(
                            children: [
                              Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  color: Colors.white,
                                ),
                                child: Image.asset(
                                  "assets/images/png/user.png",
                                  height: 40,
                                  width: 40,
                                  fit: BoxFit.fill,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextViewBold(
                                      textContent: scoreDataProvider
                                          .topperList[index].studentName,
                                      textSizeNumber: 13,
                                      textColor: Colors.black,
                                    ),
                                    TextViewNormal(
                                      textContent:
                                          "Correct: ${scoreDataProvider.topperList[index].correctAnswered} / ${scoreDataProvider.topperList[index].questionList.length}",
                                      textSizeNumber: 11,
                                      textColor: Colors.black,
                                    ),
                                    TextViewNormal(
                                      textContent:
                                          "Time: ${timeTaken(scoreDataProvider.topperList[index].timeTaken, scoreDataProvider.topperList[index].actualTime)}",
                                      textSizeNumber: 11,
                                      textColor: Colors.black,
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        );
                      })),
                ),
              )
            ],
          ),
        ));
      },
    );
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
