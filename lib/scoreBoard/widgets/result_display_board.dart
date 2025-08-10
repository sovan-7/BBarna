import 'package:flutter/material.dart';
import 'package:b_barna_app/scoreBoard/viewmodel/score_viewmodel.dart';
import 'package:b_barna_app/textSize/text_view_bold.dart';
import 'package:b_barna_app/textSize/text_view_normal.dart';
import 'package:provider/provider.dart';

class ResultDisplayBoard extends StatelessWidget {
  const ResultDisplayBoard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ScoreViewModel>(
      builder: (context, scoreDataProvider, child) {
        return Container(
          height: 400,
          color: Colors.white,
          child: Column(
            children: [
              Container(
                color: const Color(0xFF09636E),
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Spacer(),
                    TextViewBold(
                      textContent: "Question Display Board",
                      textSizeNumber: 15,
                      textColor: Colors.black,
                    ),
                    const Spacer(),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(
                        Icons.close,
                        color: Colors.black,
                        size: 25,
                      ),
                    )
                  ],
                ),
              ),
              // SizedBox(
              //   height: 49,
              //   child: Padding(
              //     padding: const EdgeInsets.symmetric(horizontal: 15),
              //     child: Row(
              //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //       children: [
              //         Row(
              //           children: [
              //             Container(
              //               height: 25,
              //               width: 25,
              //               alignment: Alignment.center,
              //               decoration: BoxDecoration(
              //                   borderRadius: BorderRadius.circular(20),
              //                   border: Border.all(color: Colors.black),
              //                   color: Colors.green),
              //               child: const Icon(
              //                 Icons.check,
              //                 size: 20,
              //                 color: Colors.black,
              //               ),
              //             ),
              //             const SizedBox(
              //               width: 8,
              //             ),
              //             TextViewBold(
              //               textContent:
              //                   "Answered: ${scoreDataProvider.getAnsweredCount()}",
              //               textSizeNumber: 15,
              //               textColor: Colors.black,
              //             )
              //           ],
              //         ),
              //         Row(
              //           children: [
              //             Container(
              //               height: 25,
              //               width: 25,
              //               alignment: Alignment.center,
              //               decoration: BoxDecoration(
              //                   borderRadius: BorderRadius.circular(20),
              //                   border: Border.all(color: Colors.black),
              //                   color: Colors.orange.withOpacity(0.3)),
              //               child: const Icon(
              //                 Icons.close,
              //                 size: 20,
              //                 color: Colors.black,
              //               ),
              //             ),
              //             const SizedBox(
              //               width: 8,
              //             ),
              //             TextViewBold(
              //               textContent:
              //                   "Un Answered: ${scoreDataProvider.getUnAnsweredCount()}",
              //               textSizeNumber: 15,
              //               textColor: Colors.black,
              //             )
              //           ],
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              // Container(
              //   height: 0.6,
              //   color: Colors.black,
              // ),
              SizedBox(
                height: 350,
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 20,
                      crossAxisCount: 7),
                  scrollDirection: Axis.vertical,
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                  itemCount: scoreDataProvider.questionList.length,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () {
                        Provider.of<ScoreViewModel>(context, listen: false)
                            .setQuestionIndex(index: index);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.black),
                          color: const Color(0xFF09636E).withOpacity(0.7),
                        ),
                        child: TextViewNormal(
                          textContent: "${index + 1}",
                          textSizeNumber: 13,
                          textColor: Colors.black,
                        ),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
