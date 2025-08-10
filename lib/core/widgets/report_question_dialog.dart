// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:b_barna_app/core/constants/value_constants.dart';
import 'package:b_barna_app/textSize/text_view_bold.dart';
import 'package:b_barna_app/textSize/text_view_normal.dart';
import 'package:url_launcher/url_launcher.dart';

class ReportQuestionDialog extends StatelessWidget {
  String quizName = stringDefault;
  String questionName = stringDefault;
  ReportQuestionDialog(
      {required this.quizName, required this.questionName, super.key});

  @override
  Widget build(BuildContext context) {
    const dialogExtraWidthToMinus = 80;
    return Dialog(
      insetPadding: const EdgeInsets.all(0),
      backgroundColor: Colors.transparent,
      child: Container(
        height: 280,
        width: MediaQuery.of(context).size.width - dialogExtraWidthToMinus,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 0, bottom: 0),
          child: Column(
            children: [
              Lottie.asset("assets/json/report.json", height: 100, width: 100),
              const SizedBox(
                height: 8,
              ),
              TextViewBold(
                textContent: "Report this Question ? ",
                textSizeNumber: 16,
                textColor: Colors.black,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15.0, left: 12, right: 12),
                child: TextViewNormal(
                  textContent:
                      "If you have any doubt or want to rectify this question, Please feel free to report.",
                  textSizeNumber: 14,
                  textColor: Colors.black,
                ),
              ),
              const Spacer(),
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 50,
                      width: (MediaQuery.of(context).size.width -
                              dialogExtraWidthToMinus -
                              2) /
                          2,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                          border: Border(
                              top: BorderSide(width: 1, color: Colors.grey))),
                      child: TextViewBold(
                        textContent: "Close",
                        textSizeNumber: 14,
                        textColor: Colors.black,
                      ),
                    ),
                  ),
                  Container(
                    height: 50,
                    width: 1,
                    color: Colors.grey,
                  ),
                  InkWell(
                    onTap: () async {
                      Navigator.pop(context);
                      shareToWhatsAppNumber(
                          "Hi, I have a doubt regarding, Quiz Name: $quizName\n Question Name: $questionName");
                    },
                    child: Container(
                      height: 50,
                      width: (MediaQuery.of(context).size.width -
                              dialogExtraWidthToMinus -
                              2) /
                          2,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                          border: Border(
                              top: BorderSide(width: 1, color: Colors.grey))),
                      child: TextViewBold(
                        textContent: "Report Now !",
                        textSizeNumber: 14,
                        textColor: Colors.black,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> shareToWhatsAppNumber(String message) async {
    final url = Uri.parse(
        "https://wa.me/918509378398?text=${Uri.encodeComponent(message)}");

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }
}
