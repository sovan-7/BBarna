import 'package:flutter/material.dart';
import 'package:b_barna_app/core/route/route_name.dart';
import 'package:b_barna_app/scoreBoard/viewmodel/score_viewmodel.dart';
import 'package:b_barna_app/textSize/text_view_bold.dart';
import 'package:provider/provider.dart';

class ScoreBoardAppHeader extends StatelessWidget {
  const ScoreBoardAppHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 50,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.only(left: 10, right: 10),
        color: const Color(0xFF09636E),
        child: Consumer<ScoreViewModel>(
          builder: (context, scoreDataProvider, child) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(
                    Icons.arrow_back_ios_new,
                    size: 25,
                    color: Colors.white,
                  ),
                ),
                const Spacer(),
                TextViewBold(
                    textContent: "Score Board".toUpperCase(),
                    textSizeNumber: 17),
                Visibility(
                  visible: scoreDataProvider.quizModel != null,
                  child: InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, RouteName.viewResult,
                          arguments: {
                            "resultModel": scoreDataProvider.quizModel
                          });
                    },
                    child: Container(
                      height: 30,
                      width: 100,
                      margin: const EdgeInsets.only(left: 30),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.greenAccent,
                      ),
                      child: TextViewBold(
                        textContent: "SOLUTION",
                        textSizeNumber: 13,
                        textColor: Colors.black,
                      ),
                    ),
                  ),
                )
              ],
            );
          },
        ));
  }
}
