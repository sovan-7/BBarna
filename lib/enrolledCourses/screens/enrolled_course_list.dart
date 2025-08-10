import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:b_barna_app/core/constants/value_constants.dart';
import 'package:b_barna_app/enrolledCourses/enrolledCourseViewmodel/enrolled_viewmodel.dart';
import 'package:b_barna_app/enrolledCourses/screens/enrolled_unit_list.dart';
import 'package:b_barna_app/textSize/text_view_bold.dart';
import 'package:b_barna_app/textSize/text_view_normal.dart';
import 'package:b_barna_app/utils/size_config.dart';
import 'package:provider/provider.dart';

class EnrolledCourseList extends StatefulWidget {
  const EnrolledCourseList({super.key});
  @override
  State<EnrolledCourseList> createState() => _EnrolledCourseListState();
}

class _EnrolledCourseListState extends State<EnrolledCourseList> {
  late EnrolledCourseViewModel enrolledCourseViewModel;
  @override
  void initState() {
    enrolledCourseViewModel =
        Provider.of<EnrolledCourseViewModel>(context, listen: false);
    enrolledCourseViewModel.clearData();
    enrolledCourseViewModel.getEnrolledCourseList();
    super.initState();
  }

  bool dateDifference = true;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 50,
            width: SizeConfig.screenWidth,
            color: const Color(0xFF09636E),
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              children: [
                const Spacer(),
                TextViewBold(
                  textContent: "Enrolled Courses",
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
                    size: 25,
                    color: Colors.black,
                  ),
                )
              ],
            ),
          ),
          Expanded(child: Consumer<EnrolledCourseViewModel>(
            builder: (context, enrolledCourseData, child) {
              return (enrolledCourseData.enrolledCourseBaseModel != null &&
                      enrolledCourseData.enrolledCourseBaseModel!
                          .enrolledCourseList.isNotEmpty)
                  ? ListView.builder(
                      itemCount: enrolledCourseData
                          .enrolledCourseBaseModel?.enrolledCourseList.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            if (checkTimeExpiry(enrolledCourseData
                                    .enrolledCourseBaseModel
                                    ?.enrolledCourseList[index]
                                    .accessTill ??
                                intDefault)) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EnrolledUnitList(
                                        unitCodeList: enrolledCourseData
                                            .enrolledCourseBaseModel
                                            ?.enrolledCourseList[index]
                                            .unitCodeList,
                                        subjectName: enrolledCourseData
                                            .enrolledCourseBaseModel
                                            ?.enrolledCourseList[index]
                                            .subjectName),
                                  ));
                            }
                          },
                          child: Container(
                            height: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(3),
                              color: const Color(0xFF09636E).withOpacity(0.1),
                            ),
                            margin: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 8),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                      3), // Adjust the radius as needed
                                  child: Image.network(
                                    "${enrolledCourseData.enrolledCourseBaseModel?.enrolledCourseList[index].subjectImage}",
                                    height: 80,
                                    width: 80,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 8),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // (${enrolledCourseData.enrolledCourseBaseModel?.enrolledCourseList[index].accessType.toUpperCase()
                                        TextViewBold(
                                          textContent:
                                              "${enrolledCourseData.enrolledCourseBaseModel?.enrolledCourseList[index].subjectName}",
                                          textSizeNumber: 16,
                                          textColor: Colors.black,
                                          maxLines: 3,
                                        ),
                                        TextViewNormal(
                                          textContent:
                                              "Subscription Type: ${enrolledCourseData.enrolledCourseBaseModel?.enrolledCourseList[index].accessType.toUpperCase()}",
                                          textSizeNumber: 13,
                                          textColor: Colors.black,
                                        ),
                                        Row(
                                          children: [
                                            TextViewNormal(
                                              textContent:
                                                  "Validity: ${getData(enrolledCourseData.enrolledCourseBaseModel?.enrolledCourseList[index].accessTill ?? intDefault)}",
                                              textSizeNumber: 13,
                                              textColor: Colors.black,
                                            ),
                                            Container(
                                              height: 12,
                                              width: 12,
                                              margin: const EdgeInsets.only(
                                                  left: 5),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  color: checkTimeExpiry(
                                                          enrolledCourseData
                                                                  .enrolledCourseBaseModel
                                                                  ?.enrolledCourseList[
                                                                      index]
                                                                  .accessTill ??
                                                              intDefault)
                                                      ? Colors.green[700]
                                                      : Colors.red[700]),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    )
                  : Center(
                      child: TextViewBold(
                        textContent: "No Data Found",
                        textSizeNumber: 16,
                        textColor: Colors.black,
                        maxLines: 3,
                      ),
                    );
            },
          )),
        ],
      ),
    );
  }

  bool checkTimeExpiry(int timeStamps) {
    bool isActive = false;
    DateTime now = DateTime.now();
    try {
      DateTime targetDate = DateTime.fromMillisecondsSinceEpoch(timeStamps);
      if (targetDate.isAfter(now) ||
          ((targetDate.day == now.day) &&
              (targetDate.month == targetDate.month) &&
              (targetDate.year == now.year))) {
        isActive = true;
      } else {
        isActive = false;
      }
      return isActive;
    } catch (e) {
      isActive = false;
      return isActive;
    }
  }

  String getData(int timestamps) {
    String accessTill = "";
    if (dateDifference) {
      accessTill = fetchDate(timestamps);
    } else {
      accessTill = calculateDaysAndMonthsLeft(timestamps);
    }
    return accessTill;
  }

  String fetchDate(int timestamps) {
    String validity = "Invalid Data";
    try {
      if (timestamps.toString().length > 10) {
        DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamps);
        validity = DateFormat("dd/MM/yyyy").format(dateTime);
      }
    } catch (e) {
      log(e.toString());
    }
    return validity;
  }

  String calculateDaysAndMonthsLeft(int timestamps) {
    String duration = "Invalid Data";
    try {
      if (timestamps.toString().length > 10) {
        DateTime targetDate = DateTime.fromMillisecondsSinceEpoch(timestamps);
        DateTime currentDate = DateTime.now();
        Duration difference = targetDate.difference(currentDate);
        int daysLeft = difference.inDays;
        int monthsLeft = (daysLeft ~/ 30);
        int yearLeft = (monthsLeft ~/ 12);
        daysLeft = (daysLeft % 30);
        if (daysLeft > 0) {
          duration = "$daysLeft Days Left";
        }
        if (monthsLeft > 0) {
          duration = "$monthsLeft Months $daysLeft Days Left";
        }
        if (yearLeft > 0) {
          duration = "$yearLeft Year $monthsLeft Months $daysLeft Days Left";
        }
      }
    } catch (e) {
      log(e.toString());
    }
    return duration;
  }
}
