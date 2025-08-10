// ignore_for_file: must_be_immutable

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:b_barna_app/core/constants/value_constants.dart';
import 'package:b_barna_app/core/route/route_name.dart';
import 'package:b_barna_app/core/widgets/payment_success.dart';
import 'package:b_barna_app/courseSection/model/subject_model.dart';
import 'package:b_barna_app/courseSection/viewModel/subject_viewmodel.dart';
import 'package:b_barna_app/courseSection/widgets/course_card.dart';
import 'package:b_barna_app/enrolledCourses/enrolledCourseViewmodel/enrolled_viewmodel.dart';
import 'package:b_barna_app/enrolledCourses/screens/enrolled_unit_list.dart';
import 'package:b_barna_app/homeScreen/viewModel/home_viewmodel.dart';
import 'package:b_barna_app/textSize/text_view_bold.dart';
import 'package:b_barna_app/utils/helper.dart';
import 'package:b_barna_app/utils/sp_keys.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
//import 'package:razorpay_flutter/razorpay_flutter.dart';

class SubjectList extends StatefulWidget {
  String? appHeaderName;
  String? courseCode;
  SubjectList(
      {super.key, required this.appHeaderName, required this.courseCode});

  @override
  State<SubjectList> createState() => _SubjectListState();
}

class _SubjectListState extends State<SubjectList> {
  SubjectViewModel subjectViewModel = SubjectViewModel();
  late Razorpay razorpay = Razorpay();
  SubjectModel? subjectModel;
  late EnrolledCourseViewModel enrolledCourseViewModel;
  List<String> unitList = [];
  bool isEnrolled = false;
  @override
  void initState() {
    // Initialize Razorpay instance
    razorpay = Razorpay();
    // Set up event handlers
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, errorHandler);
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, successHandler);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, externalWalletHandler);
    subjectViewModel = Provider.of<SubjectViewModel>(context, listen: false);
    enrolledCourseViewModel =
        Provider.of<EnrolledCourseViewModel>(context, listen: false);
    subjectViewModel.getSubjectList(widget.courseCode ?? stringDefault);
    enrolledCourseViewModel.getEnrolledCourseList();
    super.initState();
  }

  @override
  void dispose() {
    razorpay.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: PopScope(
        onPopInvoked: (didPop) {
          sp?.setBoolToPref(SPKeys.canTopicAccess, false);
        },
        canPop: true,
        child: Container(
            color: Colors.white,
            child: Consumer2<SubjectViewModel, EnrolledCourseViewModel>(builder:
                (context, subjectDataProvider, enrolledDataProvider, child) {
              return Column(
                children: [
                  Container(
                    color: const Color(0xFF09636E),
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    //Colors.blue,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Icon(
                            Icons.arrow_back_ios_new_outlined,
                            size: 25,
                            color: Colors.white,
                          ),
                        ),
                        TextViewBold(
                          textContent: widget.appHeaderName!.toUpperCase(),
                          textSizeNumber: 20,
                        ),
                        Opacity(
                          opacity: 0.0,
                          // duration: Duration.zero,

                          child: Container(
                            height: 50,
                            width: 30,
                            color: const Color(0xFF09636E),
                            child: const Icon(
                              Icons.arrow_back_ios_new_outlined,
                              size: 30,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        await subjectDataProvider
                            .getSubjectList(widget.courseCode ?? stringDefault);
                      },
                      child: ListView.builder(
                        itemCount: subjectDataProvider.subjectMapList.length,
                        padding: const EdgeInsets.only(bottom: 60),
                        physics: const ClampingScrollPhysics(),
                        itemBuilder: (context, typeIndex) {
                          return Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(
                                      top: 10,
                                      bottom: 10,
                                    ),
                                    alignment: Alignment.center,
                                    child: TextViewBold(
                                      textContent: subjectViewModel
                                          .fetchTypeList[typeIndex]
                                          .toUpperCase(),
                                      textSizeNumber: 17,
                                      textColor: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: (255 *
                                    ((subjectDataProvider
                                                .subjectMapList[subjectViewModel
                                                    .fetchTypeList[typeIndex]]!
                                                .length) /
                                            2)
                                        .roundToDouble()),
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: GridView.builder(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: subjectDataProvider
                                          .subjectMapList[subjectViewModel
                                              .fetchTypeList[typeIndex]]!
                                          .length,
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        mainAxisExtent: 255,
                                      ),
                                      itemBuilder: (context, index) {
                                        return InkWell(
                                          onTap: () {
                                            setState(() {
                                              isEnrolled = false;
                                            });
                                            if (sp?.getStringFromPref(
                                                        SPKeys.phoneNumber) ==
                                                    "7001739646" ||
                                                sp?.getStringFromPref(
                                                        SPKeys.phoneNumber) ==
                                                    "7031786668" ||
                                                sp?.getStringFromPref(
                                                        SPKeys.phoneNumber) ==
                                                    "9733815585" ||
                                                sp?.getStringFromPref(
                                                        SPKeys.phoneNumber) ==
                                                    "8210703249") {
                                              isEnrolled = false;
                                              Navigator.pushNamed(
                                                  context, RouteName.unitList,
                                                  arguments: {
                                                    "subjectCode":
                                                        subjectDataProvider
                                                            .subjectMapList[
                                                                subjectViewModel
                                                                        .fetchTypeList[
                                                                    typeIndex]]![
                                                                index]
                                                            .code,
                                                    "subjectName":
                                                        subjectDataProvider
                                                            .subjectMapList[
                                                                subjectViewModel
                                                                        .fetchTypeList[
                                                                    typeIndex]]![
                                                                index]
                                                            .name
                                                  }).whenComplete(() {
                                                isEnrolled = false;
                                              });
                                            } else {
                                              if (enrolledDataProvider
                                                      .enrolledCourseBaseModel !=
                                                  null) {
                                                for (int i = 0;
                                                    i <
                                                        enrolledDataProvider
                                                            .enrolledCourseBaseModel!
                                                            .enrolledCourseList
                                                            .length;
                                                    i++) {
                                                  if ((enrolledDataProvider
                                                              .enrolledCourseBaseModel!
                                                              .enrolledCourseList[
                                                                  i]
                                                              .subjectCode ==
                                                          subjectDataProvider
                                                              .subjectMapList[
                                                                  subjectViewModel
                                                                          .fetchTypeList[
                                                                      typeIndex]]![
                                                                  index]
                                                              .code) &&
                                                      enrolledDataProvider
                                                          .enrolledCourseBaseModel!
                                                          .enrolledCourseList[i]
                                                          .unitCodeList
                                                          .isNotEmpty) {
                                                    setState(() {
                                                      unitList.clear();

                                                      unitList.addAll(
                                                          enrolledDataProvider
                                                              .enrolledCourseBaseModel!
                                                              .enrolledCourseList[
                                                                  i]
                                                              .unitCodeList);
                                                      isEnrolled = true;
                                                    });
                                                    break;
                                                  }
                                                }
                                              }
                                              if (isEnrolled) {
                                                sp?.setBoolToPref(
                                                    SPKeys.canTopicAccess,
                                                    true);
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) => EnrolledUnitList(
                                                          unitCodeList:
                                                              unitList,
                                                          subjectName: subjectDataProvider
                                                              .subjectMapList[
                                                                  subjectViewModel
                                                                          .fetchTypeList[
                                                                      typeIndex]]![
                                                                  index]
                                                              .name),
                                                    ));
                                              } else {
                                                if (subjectDataProvider
                                                        .subjectMapList[
                                                            subjectViewModel
                                                                    .fetchTypeList[
                                                                typeIndex]]![
                                                            index]
                                                        .price ==
                                                    0) {
                                                  sp?.setBoolToPref(
                                                      SPKeys.canTopicAccess,
                                                      true);
                                                } else {
                                                  sp?.setBoolToPref(
                                                      SPKeys.canTopicAccess,
                                                      false);
                                                }
                                                Navigator.pushNamed(
                                                    context, RouteName.unitList,
                                                    arguments: {
                                                      "subjectCode": subjectDataProvider
                                                          .subjectMapList[
                                                              subjectViewModel
                                                                      .fetchTypeList[
                                                                  typeIndex]]![
                                                              index]
                                                          .code,
                                                      "subjectName": subjectDataProvider
                                                          .subjectMapList[
                                                              subjectViewModel
                                                                      .fetchTypeList[
                                                                  typeIndex]]![
                                                              index]
                                                          .name
                                                    });
                                              }
                                            }
                                          },
                                          child: CourseCard(
                                            courseImage: subjectDataProvider
                                                .subjectMapList[subjectViewModel
                                                        .fetchTypeList[
                                                    typeIndex]]![index]
                                                .image,
                                            courseText: subjectDataProvider
                                                .subjectMapList[subjectViewModel
                                                        .fetchTypeList[
                                                    typeIndex]]![index]
                                                .name,
                                            isUpperStackCardVisible: true,
                                            coursePrice: subjectDataProvider
                                                .subjectMapList[subjectViewModel
                                                        .fetchTypeList[
                                                    typeIndex]]![index]
                                                .price,
                                            sellingPrice: subjectDataProvider
                                                        .subjectMapList[
                                                            subjectViewModel
                                                                    .fetchTypeList[
                                                                typeIndex]]![
                                                            index]
                                                        .courseType ==
                                                    "Free"
                                                ? 0
                                                : subjectDataProvider
                                                    .subjectMapList[
                                                        subjectViewModel
                                                                .fetchTypeList[
                                                            typeIndex]]![index]
                                                    .sellingPrice,
                                            onTapBuy: () {
                                              setState(() {
                                                subjectModel =
                                                    subjectDataProvider
                                                            .subjectMapList[
                                                        subjectViewModel
                                                                .fetchTypeList[
                                                            typeIndex]]![index];
                                              });
                                              openCheckout(
                                                  subjectDataProvider
                                                              .subjectMapList[
                                                                  subjectViewModel
                                                                          .fetchTypeList[
                                                                      typeIndex]]![
                                                                  index]
                                                              .courseType ==
                                                          "Free"
                                                      ? 0
                                                      : subjectDataProvider
                                                          .subjectMapList[
                                                              subjectViewModel
                                                                      .fetchTypeList[
                                                                  typeIndex]]![
                                                              index]
                                                          .sellingPrice,
                                                  subjectDataProvider
                                                      .subjectMapList[
                                                          subjectViewModel
                                                                  .fetchTypeList[
                                                              typeIndex]]![
                                                          index]
                                                      .price);
                                            },
                                          ),
                                        );
                                      }),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  )
                ],
              );
            })),
      ),
    ));
  }

  void openCheckout(double sellingPrice, double coursePrice) {
    double price = (sellingPrice == doubleDefault) ? coursePrice : sellingPrice;
    var options = {
      "key": "rzp_live_ALbX7RKvJAGMtR",
      "amount": price * 100,
      "name": "B_Barna",
      "description": "Course Enrolment",
      "image":
          "https://firebasestorage.googleapis.com/v0/b/bbarna-6a725.appspot.com/o/logo.png?alt=media&token=dc710702-18cd-4b42-9b9d-4b9ccb79a01e",
      "currency": "INR",
      'send_sms_hash': true,
      'retry': {'enabled': true, 'max_count': 1},
      "prefill": {
        "contact": sp!.getStringFromPref(SPKeys.phoneNumber),
        "email": sp!.getStringFromPref(SPKeys.emailId),
      },
      "external": {
        'wallets': ['paytm']
      }
    };

    razorpay.open(options);
  }

  void errorHandler(PaymentFailureResponse response) {
    log(response.message.toString());
    Helper.showSnackBarMessage(msg: response.message!, isSuccess: false);
  }

  void successHandler(PaymentSuccessResponse response) {
    enrolledCourse().then((value) {
      // Display a green-colored SnackBar with the payment ID
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return PaymentSuccess(
              courseName: subjectModel!.name,
              accessType: subjectModel!.price != 0 ? "PAID" : "FREE",
            );
          });
    });
  }

  void externalWalletHandler(ExternalWalletResponse response) {
    Helper.showSnackBarMessage(msg: response.walletName!, isSuccess: false);
  }

  Future enrolledCourse() async {
    EnrolledCourseViewModel enrolledCourseViewModel =
        Provider.of<EnrolledCourseViewModel>(context, listen: false);
    DateTime endOfYear = DateTime(DateTime.now().year, 12, 31, 23, 59, 59, 999);
    int milliseconds = endOfYear.millisecondsSinceEpoch;
    if (enrolledCourseViewModel.enrolledCourseBaseModel != null) {
      Map<String, dynamic> data = {
        "access_till": milliseconds,
        "access_type": subjectModel?.price != 0 ? "PAID" : "FREE",
        "subject_code": subjectModel?.code,
        "subject_image": subjectModel?.image,
        "subject_name": subjectModel?.name,
        "unit_code_list": []
      };
      enrolledCourseViewModel.enrolledCourse(data);
    } else {
      Map<String, dynamic> data = {
        "course_list": [
          {
            "access_till": milliseconds,
            "access_type": subjectModel?.price != 0 ? "PAID" : "FREE",
            "subject_code": subjectModel?.code,
            "subject_image": subjectModel?.image,
            "subject_name": subjectModel?.name,
            "unit_code_list": []
          },
        ],
        "student_id": sp!.getStringFromPref(SPKeys.studentId),
        "student_name": sp!.getStringFromPref(SPKeys.name),
      };
      enrolledCourseViewModel.enrolledCourse(data);
    }
    Provider.of<HomeViewModel>(context, listen: false).getSubjectList();
  }
}
