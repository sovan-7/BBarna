import 'dart:developer';

import 'package:b_barna_app/enrolledCourses/screens/enrolled_course_list.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:b_barna_app/core/constants/value_constants.dart';
import 'package:b_barna_app/core/route/route_name.dart';
import 'package:b_barna_app/core/widgets/payment_success.dart';
import 'package:b_barna_app/courseSection/model/subject_model.dart';
import 'package:b_barna_app/enrolledCourses/enrolledCourseViewmodel/enrolled_viewmodel.dart';
import 'package:b_barna_app/enrolledCourses/model/enrolled_course_model.dart';
import 'package:b_barna_app/enrolledCourses/screens/enrolled_unit_list.dart';
import 'package:b_barna_app/homeScreen/viewModel/home_viewmodel.dart';
import 'package:b_barna_app/textSize/text_view_bold.dart';
import 'package:b_barna_app/utils/helper.dart';
import 'package:b_barna_app/utils/sp_keys.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final allSvgImages = [
    "assets/images/svg/books.svg",
    "assets/images/svg/course.svg",
    "assets/images/svg/exam1.svg",
    "assets/images/svg/globe.svg",
    "assets/images/svg/test2.svg",
    "assets/images/svg/test1.svg",
  ];
  List<String> subIconHeading = [
    "Paid Course",
    "Enrolled Course",
    "Free Video",
    "Free Note",
    "Free Quiz",
    "Current Affairs"
  ];
  late Razorpay razorpay = Razorpay();
  SubjectModel? subjectModel;

  @override
  void initState() {
    // Initialize Razorpay instance
    razorpay = Razorpay();
    // Set up event handlers
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, errorHandler);
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, successHandler);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, externalWalletHandler);

    super.initState();
  }

  @override
  void dispose() {
    //razorpay.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50.0),
        child: AppBar(
          backgroundColor: const Color(0xFF09636E),
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    height: 30,
                    width: 30,
                    margin: const EdgeInsets.only(right: 5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.white,
                        image: const DecorationImage(
                            image: AssetImage("assets/images/png/user.png"),
                            fit: BoxFit.fill)),
                  ),
                  TextViewBold(
                      textContent: sp!.getStringFromPref(SPKeys.name),
                      //studentVM.student?.studentName,
                      textSizeNumber: 15.0),
                ],
              ),
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      Helper.showSnackBarMessage(
                          msg: "Coming soon", isSuccess: false);
                    },
                    child: Icon(
                      Icons.language,
                      size: 25,
                      color: Colors.white,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 15.0),
                    child: InkWell(
                      onTap: () {
                        Helper.showSnackBarMessage(
                            msg: "Coming soon", isSuccess: false);
                      },
                      child: Icon(
                        Icons.notifications,
                        size: 25,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: Container(
            color: Colors.white,
            child: Consumer2<HomeViewModel, EnrolledCourseViewModel>(builder:
                (context, homeDataProvider, enrolledDataProvider, child) {
              return Column(
                children: [
                  // Full-width carousel with aspect ratio
                  if (homeDataProvider.bannerList.isNotEmpty)
                    CarouselSlider.builder(
                      itemCount: homeDataProvider.bannerList.length,
                      itemBuilder: (context, index, realIndex) {
                        return Container(
                          padding: const EdgeInsets.only(
                              top: 20.0, bottom: 10.0, left: 5, right: 5.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: Image.network(
                              homeDataProvider.bannerList[index].image,
                              fit: BoxFit
                                  .fill, // Ensures the image covers the entire area
                              width: MediaQuery.of(context)
                                  .size
                                  .width, // Full width
                            ),
                          ),
                        );
                      },
                      options: CarouselOptions(
                        aspectRatio: 16 / 9, // Widescreen aspect ratio
                        autoPlay: true,
                        viewportFraction:
                            1.0, // Ensures each image takes full width
                      ),
                    )
                  else
                    const SizedBox(
                      height: 200,
                    ),
                  Container(
                    color: Colors.white,
                    height: 280, // Fixed height for grid
                    child: GridView.count(
                      crossAxisCount: 3,
                      physics: const NeverScrollableScrollPhysics(),
                      children: List.generate(6, (index) {
                        return InkWell(
                          onTap: () {
                            switch (index) {
                              case 0:
                                Navigator.pushNamed(
                                    context, RouteName.courseList);
                                break;
                              case 1:
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return const Dialog(
                                          insetPadding: EdgeInsets.all(0),
                                          backgroundColor: Colors.transparent,
                                          child: EnrolledCourseList());
                                    });
                                break;
                              case 2:
                                Navigator.pushNamed(
                                    context, RouteName.freeVideoScreenRoute);
                                break;
                              case 3:
                                Navigator.pushNamed(
                                    context, RouteName.freePdfScreenRoute);
                                break;
                              case 4:
                                Navigator.pushNamed(
                                    context, RouteName.freeQuizScreenRoute);
                                break;
                              case 5:
                                Helper.showSnackBarMessage(
                                    msg: "Coming soon", isSuccess: false);
                                break;
                            }
                          },
                          child: Container(
                            margin: const EdgeInsets.all(8),
                            padding: const EdgeInsets.all(5),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.3),
                                  offset: const Offset(5.0, 5.0),
                                  blurRadius: 5.0,
                                  spreadRadius: 1.0,
                                ),
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  offset: const Offset(0.0, 0.0),
                                  blurRadius: 0.0,
                                  spreadRadius: 0.0,
                                ),
                              ],
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.white,
                            ),
                            child: Column(
                              children: [
                                Expanded(
                                  child: Container(
                                    margin: const EdgeInsets.all(2),
                                    child: SvgPicture.asset(
                                      allSvgImages[index],
                                      height: 60,
                                      width: 60,
                                    ),
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  margin: const EdgeInsets.only(bottom: 5),
                                  child: Text(
                                    subIconHeading[index],
                                    maxLines: 2,
                                    style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                      left: 10,
                      right: 10,
                      // top: 10,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      // color: Colors.lightBlue.withOpacity(0.1),
                    ),
                    child: Column(
                      children: [
                        if (homeDataProvider.subjectList.isNotEmpty)
                          CarouselSlider.builder(
                            itemCount: homeDataProvider.subjectList.length,
                            itemBuilder: (context, index, realIndex) {
                              return InkWell(
                                onTap: () {
                                  if (isEnrolled(
                                      enrolledDataProvider,
                                      homeDataProvider
                                          .subjectList[index].code)) {
                                    sp?.setBoolToPref(
                                        SPKeys.canTopicAccess, true);
                                    EnrolledCourseModel? enrolledCourse =
                                        enrolledDataProvider
                                            .enrolledCourseBaseModel
                                            ?.enrolledCourseList
                                            .where((element) =>
                                                element.subjectCode ==
                                                homeDataProvider
                                                    .subjectList[index].code)
                                            .first;
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              EnrolledUnitList(
                                                  unitCodeList: enrolledCourse!
                                                      .unitCodeList,
                                                  subjectName: homeDataProvider
                                                      .subjectList[index].name),
                                        ));
                                  } else {
                                    Navigator.pushNamed(
                                        context, RouteName.unitList,
                                        arguments: {
                                          "subjectCode": homeDataProvider
                                              .subjectList[index].code,
                                          "subjectName": homeDataProvider
                                              .subjectList[index].name
                                        });
                                  }
                                },
                                child: Stack(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(
                                        left: 12,
                                        right: 12,
                                      ),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          color: const Color(0xFF09636E)
                                              .withOpacity(0.1)),
                                      child: Column(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.only(
                                                top: 10.0,
                                                bottom: 10.0,
                                                left: 10,
                                                right: 10.0),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: Image.network(
                                                homeDataProvider
                                                    .subjectList[index].image,
                                                fit: BoxFit.fill,
                                                height: 170,
                                                width: 300,
                                              ),
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.center,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8, right: 8, top: 5),
                                              child: Text(
                                                homeDataProvider
                                                    .subjectList[index].name,
                                                maxLines: 2,
                                                style: const TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              if (!isEnrolled(
                                                  enrolledDataProvider,
                                                  homeDataProvider
                                                      .subjectList[index]
                                                      .code)) {
                                                openCheckout(
                                                    homeDataProvider
                                                                .subjectList[
                                                                    index]
                                                                .courseType ==
                                                            "Free"
                                                        ? 0
                                                        : homeDataProvider
                                                            .subjectList[index]
                                                            .sellingPrice,
                                                    homeDataProvider
                                                        .subjectList[index]
                                                        .price);
                                              }
                                            },
                                            child: Container(
                                              height: 40,
                                              // width: MediaQuery.of(context).size.width - 20,
                                              alignment: Alignment.center,
                                              margin: const EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                color: isEnrolled(
                                                        enrolledDataProvider,
                                                        homeDataProvider
                                                            .subjectList[index]
                                                            .code)
                                                    ? const Color(0xFF09636E)
                                                    : Colors.red,
                                              ),
                                              child: Text(
                                                isEnrolled(
                                                        enrolledDataProvider,
                                                        homeDataProvider
                                                            .subjectList[index]
                                                            .code)
                                                    ? "Enrolled"
                                                    : "Pay (₹ ${getPrice(homeDataProvider.subjectList[index].sellingPrice, homeDataProvider.subjectList[index].price)}) /-",
                                                style: const TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                          //(sellingPrice != 0 && sellingPrice != -1)
                                        ],
                                      ),
                                    ),
                                    if (homeDataProvider
                                                .subjectList[index].price !=
                                            0 &&
                                        homeDataProvider.subjectList[index]
                                                .sellingPrice !=
                                            0)
                                      Positioned(
                                        top: 0,
                                        right: 20,
                                        child: Container(
                                          height: 25,
                                          width: 70,
                                          alignment: Alignment.center,
                                          decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(10),
                                              bottomLeft: Radius.circular(10),
                                            ),
                                            color: Colors.red,
                                          ),
                                          child: TextViewBold(
                                            textContent:
                                                "${getDiscountPercent(homeDataProvider.subjectList[index].price, homeDataProvider.subjectList[index].sellingPrice)}% OFF",
                                            textSizeNumber: 12,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              );
                            },
                            options: CarouselOptions(
                                height: 280,
                                autoPlay: false,
                                viewportFraction: 0.9,
                                scrollPhysics: const ClampingScrollPhysics()),
                          ),
                      ],
                    ),
                  ),
                  Container(
                    height: 200,
                    width: (MediaQuery.of(context).size.width) - 20,
                    margin:
                        const EdgeInsets.only(bottom: 10, left: 10, right: 10),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      // color: Colors.yellow,
                    ),
                    child: Column(
                      children: [
                        Container(
                          height: 50,
                          width: MediaQuery.of(context).size.width - 20,
                          // color: Colors.blue,
                          alignment: Alignment.bottomLeft,
                          child: const Text(
                            "Our Experts",
                            maxLines: 2,
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: homeDataProvider.teacherList.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return Container(
                                height: 150,
                                width: 120,
                                margin: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: const Color(0xFF09636E)
                                        .withOpacity(0.1),
                                    border: Border.all(
                                        width: 0.5,
                                        color: const Color(0xFF09636E)
                                            .withOpacity(0.5))),
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        margin: const EdgeInsets.all(2),
                                        child: Image.network(
                                          homeDataProvider
                                              .teacherList[index].image,
                                          height: 50,
                                          width: 60,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 8),
                                      child: Text(
                                        homeDataProvider
                                            .teacherList[index].name,
                                        maxLines: 2,
                                        style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }

  double getPrice(double sellingPrice, double actualPrice) {
    double price = 0.0;
    if (sellingPrice != 0 && sellingPrice != -1) {
      price = sellingPrice;
    } else {
      price = actualPrice;
    }
    return price;
  }

  bool isEnrolled(
      EnrolledCourseViewModel enrolledDataProvider, String subjectCode) {
    bool isEnrolledCourse = false;
    if (enrolledDataProvider.enrolledCourseBaseModel != null &&
        enrolledDataProvider
            .enrolledCourseBaseModel!.enrolledCourseList.isNotEmpty) {
      for (int i = 0;
          i <
              enrolledDataProvider
                  .enrolledCourseBaseModel!.enrolledCourseList.length;
          i++) {
        if (enrolledDataProvider
                .enrolledCourseBaseModel!.enrolledCourseList[i].subjectCode ==
            subjectCode) {
          isEnrolledCourse = true;
          break;
        }
      }
    }
    return isEnrolledCourse;
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

  int getDiscountPercent(double coursePrice, double sellingPrice) {
    int discount = 0;
    discount = (coursePrice - sellingPrice).toInt();
    return ((discount / coursePrice) * 100).toInt();
  }
}
