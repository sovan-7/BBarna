import 'package:flutter/material.dart';
import 'package:b_barna_app/core/constants/value_constants.dart';
import 'package:b_barna_app/core/route/route_name.dart';
import 'package:b_barna_app/core/widgets/app_header.dart';
import 'package:b_barna_app/editProfile/widgets/list_card.dart';
import 'package:b_barna_app/student/viewModel/student_vm.dart';
import 'package:b_barna_app/textSize/text_view_bold.dart';
import 'package:b_barna_app/textSize/text_view_normal.dart';
import 'package:b_barna_app/utils/sp_keys.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> listItemsName = [
      "Enrolled Course",
      "Terms & Condition",
      "Privacy Policy",
      "About Us",
      "Share",
      "Logout"
    ];
    List<IconData> iconList = [
      Icons.done_all_outlined,
      Icons.rule_folder_sharp,
      Icons.privacy_tip_sharp,
      Icons.event_available_outlined,
      Icons.share,
      Icons.logout,
    ];
    return SafeArea(
        child: Scaffold(
      body: Container(
        color: Colors.white,
        child: Consumer<StudentViewModel>(builder: (context, studentVM, child) {
          return Column(
            children: [
              AppHeader(),
              Container(
                height: 200,
                padding: const EdgeInsets.only(
                  left: 10,
                  right: 10,
                ),
                width: MediaQuery.of(context).size.width,
                color: Colors.white,
                child: Row(
                  children: [
                    Container(
                      height: 130,
                      width: 130,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(70),
                          border: Border.all(width: 1, color: Colors.black),
                          image: DecorationImage(
                              image: getUserImageProvider(studentVM),
                              fit: BoxFit.fill),
                          color: Colors.white),
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              TextViewBold(
                                textContent: sp!.getStringFromPref(SPKeys.name),
                                textSizeNumber: 20,
                                textColor: Colors.black,
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.pushNamed(context,
                                      RouteName.userProfileScreenRoute);
                                },
                                child: const Padding(
                                  padding: EdgeInsets.only(left: 20.0),
                                  child: Icon(
                                    Icons.edit,
                                    color: Colors.black,
                                    size: 25,
                                  ),
                                ),
                              )
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Icon(
                                  Icons.mobile_friendly,
                                  color: Colors.black,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: TextViewNormal(
                                    textContent:
                                        "+91 ${sp!.getStringFromPref(SPKeys.phoneNumber)}",
                                    textSizeNumber: 12,
                                    textColor: Colors.black,
                                  ),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Icon(
                                  Icons.mail_outline,
                                  color: Colors.black,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: TextViewNormal(
                                    textContent:
                                        studentVM.student!.studentEmail != ""
                                            ? studentVM.student!.studentEmail
                                            : stringDefault,
                                    textSizeNumber: 12,
                                    textColor: Colors.black,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0, bottom: 5.0),
                      child: TextViewBold(
                        textContent:
                            "${(getProfilePercent(studentVM) * 100).toStringAsFixed(0)}% Profile Complete",
                        textSizeNumber: 15,
                        textColor: Colors.black,
                      ),
                    ),
                    LinearPercentIndicator(
                      animation: true,
                      lineHeight: 10.0,
                      animationDuration: 2000,
                      percent: getProfilePercent(studentVM),
                      progressColor: getColor(studentVM),
                      barRadius: const Radius.circular(10),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(
                    left: 10,
                    right: 10,
                  ),
                  decoration: const BoxDecoration(
                      border: Border(
                          top: BorderSide(color: Colors.black, width: 1))),
                  child: ListView.builder(
                      itemCount: listItemsName.length,
                      itemBuilder: (context, index) {
                        return ListCard(
                          index: index,
                          listItemsName: listItemsName[index],
                          iconData: iconList[index],
                        );
                      }),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: TextViewBold(
                  textContent: "Version:1.0.0",
                  textSizeNumber: 14,
                  textColor: Colors.grey[800],
                ),
              )
              //Image.asset("assets/images/png/"),
            ],
          );
        }),
      ),
    ));
  }

  ImageProvider getUserImageProvider(StudentViewModel studentVM) {
    if ((studentVM.student?.studentProfileImage?.isNotEmpty ?? false) &&
        studentVM.student?.studentProfileImage != stringDefault) {
      return NetworkImage((studentVM.student?.studentProfileImage)!);
    } else {
      return const AssetImage("assets/images/png/user.png");
    }
  }

  double getProfilePercent(StudentViewModel studentVM) {
    double profileValue = .1;
    if ((studentVM.student?.studentProfileImage?.isNotEmpty ?? false) &&
        studentVM.student?.studentProfileImage != stringDefault) {
      profileValue += .3;
    }
    if ((studentVM.student?.studentEmail != stringDefault &&
            studentVM.student?.studentEmail != "") &&
        (studentVM.student?.studentWhatsappNumber != stringDefault &&
            studentVM.student?.studentWhatsappNumber != "")) {
      profileValue += .15;
    }
    if ((studentVM.student?.address?.city != stringDefault &&
            studentVM.student?.address?.city != "") &&
        (studentVM.student?.address?.line1 != stringDefault &&
            studentVM.student?.address?.line1 != "")) {
      profileValue += .15;
    }
    if ((studentVM.student?.address?.locality != stringDefault &&
            studentVM.student?.address?.locality != "") &&
        (studentVM.student?.address?.pinCode != stringDefault &&
            studentVM.student?.address?.pinCode != "")) {
      profileValue += .15;
    }
    if (studentVM.student?.collegeName != stringDefault &&
        studentVM.student?.collegeName != "") {
      profileValue += .1;
    }
    if (studentVM.student?.birthDay != stringDefault &&
        studentVM.student?.birthDay != "") {
      profileValue += .05;
    }
    return profileValue;
  }

  Color getColor(StudentViewModel studentVM) {
    Color color = Colors.red;
    if (getProfilePercent(studentVM) >= 0.5 &&
        getProfilePercent(studentVM) < 0.75) {
      color = Colors.amber;
    } else if (getProfilePercent(studentVM) >= 0.75) {
      color = Colors.green;
    }
    return color;
  }
}
