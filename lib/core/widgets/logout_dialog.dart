import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:b_barna_app/core/constants/value_constants.dart';
import 'package:b_barna_app/core/route/route_name.dart';
import 'package:b_barna_app/textSize/text_view_bold.dart';
import 'package:b_barna_app/textSize/text_view_normal.dart';
import 'package:b_barna_app/utils/sp_keys.dart';

class LogoutDialog extends StatelessWidget {
  const LogoutDialog({super.key});

  @override
  Widget build(BuildContext context) {
    const dialogExtraWidthToMinus = 80;
    return Dialog(
      insetPadding: const EdgeInsets.all(0),
      backgroundColor: Colors.transparent,
      child: Container(
        height: 300,
        width: MediaQuery.of(context).size.width - dialogExtraWidthToMinus,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 0),
          child: Column(
            children: [
              Lottie.asset("assets/json/logout.json", height: 100, width: 100),
              TextViewBold(
                textContent: "Logging out ! ",
                textSizeNumber: 16,
                textColor: Colors.black,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 16, right: 16),
                child: Column(
                  children: [
                    TextViewNormal(
                      textContent:
                          "Are you sure that you want to logout from your current account?",
                      textSizeNumber: 14,
                      textColor: Colors.black,
                    ),
                  ],
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
                    width: 2,
                    color: Colors.grey,
                  ),
                  InkWell(
                    onTap: () async {
                      final FirebaseFirestore fireStore =
                          FirebaseFirestore.instance;

                      await fireStore
                          .collection(student)
                          .doc(sp?.getStringFromPref(SPKeys.studentId))
                          .update({"device_count": 0}).then((value) {
                        sp?.clearPreference();

                        Navigator.pushReplacementNamed(
                            context, RouteName.loginScreenRoute);
                      });
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
                        textContent: "Logout",
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
}
