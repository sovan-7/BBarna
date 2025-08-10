// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:b_barna_app/core/constants/value_constants.dart';
import 'package:b_barna_app/textSize/text_view_bold.dart';
import 'package:b_barna_app/textSize/text_view_normal.dart';
import 'package:b_barna_app/utils/sp_keys.dart';

class PaymentSuccess extends StatelessWidget {
  String courseName = stringDefault;
  String accessType = stringDefault;
  PaymentSuccess(
      {required this.courseName, required this.accessType, super.key});

  @override
  Widget build(BuildContext context) {
    const dialogExtraWidthToMinus = 80;
    return Dialog(
      insetPadding: const EdgeInsets.all(0),
      backgroundColor: Colors.transparent,
      child: Container(
        height: 250,
        width: MediaQuery.of(context).size.width - dialogExtraWidthToMinus,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
          child: Column(
            children: [
              Lottie.asset("assets/json/success.json",
                  height: 65, width: 65, fit: BoxFit.fill),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: TextViewBold(
                  textContent: "Welcome ${sp!.getStringFromPref(SPKeys.name)}",
                  textSizeNumber: 18,
                  textColor: Colors.black,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: TextViewNormal(
                  textContent:
                      "You are now Enrolled  $courseName ($accessType)",
                  textSizeNumber: 16,
                  textColor: Colors.black,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  height: 40,
                  width: MediaQuery.of(context).size.width -
                      dialogExtraWidthToMinus,
                  margin: const EdgeInsets.only(
                    left: 10,
                    right: 10,
                    top: 20,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color(0xFF09636E),
                  ),
                  alignment: Alignment.center,
                  child: TextViewBold(
                    textContent: "CONTINUE",
                    textSizeNumber: 17,
                    textColor: Colors.black,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
