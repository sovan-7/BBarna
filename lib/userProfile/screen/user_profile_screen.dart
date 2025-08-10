import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:b_barna_app/core/constants/value_constants.dart';
import 'package:b_barna_app/core/widgets/app_loader.dart';
import 'package:b_barna_app/student/model/student_model.dart';
import 'package:b_barna_app/student/repo/student_repo.dart';
import 'package:b_barna_app/student/viewModel/student_vm.dart';
import 'package:b_barna_app/textSize/text_view_bold.dart';
import 'package:b_barna_app/textSize/text_view_normal.dart';
import 'package:b_barna_app/utils/helper.dart';
import 'package:b_barna_app/utils/sp_keys.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController whatsAppController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController guardianNameController = TextEditingController();
  TextEditingController birthdayController = TextEditingController();
  TextEditingController collegeController = TextEditingController();
  TextEditingController pinCodeController = TextEditingController();
  TextEditingController line1Controller = TextEditingController();
  TextEditingController localityController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  StudentViewModel _studentViewModel = StudentViewModel();
  bool isMarried = false;
  String highestDegree = "";
  File? userImage;
  bool isImageSelected = false;
  bool isTmsAccepted = false;
  @override
  void initState() {
    _studentViewModel = Provider.of<StudentViewModel>(context, listen: false);
    _studentViewModel.clearData();
    _studentViewModel.setCurrentStudentData().then((value) {
      updateDataToTextFiled();
    });

    super.initState();
  }

  Future pickImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) return;

    final imageTemp = File(image.path);
    setState(() {
      isImageSelected = true;
      userImage = imageTemp;
    });
  }

  void updateDataToTextFiled() {
    setState(() {
      var studentData = _studentViewModel.student;
      nameController.text = (studentData?.studentName) ?? stringDefault;
      mobileController.text =
          (studentData?.studentPhoneNumber) ?? stringDefault;
      whatsAppController.text =
          (studentData?.studentWhatsappNumber) ?? stringDefault;
      emailController.text = (studentData?.studentEmail) ?? stringDefault;
      guardianNameController.text =
          (studentData?.guardianFullName) ?? stringDefault;
      birthdayController.text = (studentData?.birthDay) ?? stringDefault;
      collegeController.text = (studentData?.collegeName) ?? stringDefault;
      pinCodeController.text = (studentData?.address?.pinCode) ?? stringDefault;
      line1Controller.text = (studentData?.address?.line1) ?? stringDefault;
      localityController.text =
          (studentData?.address?.locality) ?? stringDefault;
      cityController.text = (studentData?.address?.city) ?? stringDefault;
      stateController.text = (studentData?.address?.state) ?? stringDefault;
      highestDegree = studentData?.highestDegree ?? stringDefault;
      isTmsAccepted = studentData?.isTmsAccepted ?? boolDefault;
      isMarried = studentData?.isMarried ?? boolDefault;
    });
  }

  ImageProvider getUserImageProvider() {
    if (isImageSelected) {
      if (userImage != null) {
        return FileImage(userImage!);
      }
    } else {
      if ((_studentViewModel.student?.studentProfileImage?.isNotEmpty ??
              false) &&
          _studentViewModel.student?.studentProfileImage != stringDefault) {
        return NetworkImage((_studentViewModel.student?.studentProfileImage)!);
      }
    }
    return const AssetImage("assets/images/png/user.png");
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      body: Consumer<StudentViewModel>(builder: (context, studentVM, child) {
        return Column(
          children: [
            Container(
              color: const Color(0xFF09636E),
              child: Row(
                children: [
                  Container(
                    height: 60,
                    width: 30,
                    padding: const EdgeInsets.only(left: 10),
                    color: const Color(0xFF09636E),
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(
                        Icons.arrow_back_ios_new_outlined,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Container(
                    height: 60,
                    width: MediaQuery.of(context).size.width - 60,
                    color: const Color(0xFF09636E),
                    alignment: Alignment.center,
                    child: TextViewBold(
                      textContent: "Edit Profile".toUpperCase(),
                      textSizeNumber: 20,
                    ),
                  ),
                  Opacity(
                    opacity: 0.0,
                    child: Container(
                      height: 60,
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
              child: Container(
                // color: Colors.blue,
                margin: const EdgeInsets.only(
                  bottom: 10,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Column(
                            children: [
                              Container(
                                height: 80,
                                width: MediaQuery.of(context).size.width,
                                color: const Color(0xFF09636E),
                              ),
                              Container(
                                height: 50,
                                width: MediaQuery.of(context).size.width,
                                color: Colors.white,
                              ),
                            ],
                          ),
                          Stack(
                            children: [
                              Container(
                                height: 120,
                                width: 120,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(60),
                                    color: Colors.white,
                                    border: Border.all(
                                        color: Colors.black, width: 2),
                                    image: DecorationImage(
                                        image: getUserImageProvider(),
                                        fit: BoxFit.fill)),
                              ),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: InkWell(
                                    onTap: () async {
                                      await pickImage();
                                    },
                                    child: const Icon(
                                      Icons.edit,
                                      size: 30,
                                      color: Colors.black,
                                    )),
                              )
                            ],
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20.0, top: 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 10.0, bottom: 5.0),
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
                      Container(
                        margin: const EdgeInsets.only(
                          left: 10,
                          right: 10,
                        ),
                        padding: const EdgeInsets.only(
                            left: 20, right: 20, top: 20, bottom: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color(0xFF09636E).withOpacity(0.4),
                        ),
                        width: (MediaQuery.of(context).size.width) - 20,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 10.0, bottom: 10.0),
                              child: TextViewBold(
                                textContent: "Personal Details",
                                textSizeNumber: 18,
                                textColor: Colors.black,
                              ),
                            ),
                            Container(
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.white,
                              ),
                              child: TextField(
                                controller: nameController,
                                obscureText: false,
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Full Name',
                                    labelStyle: TextStyle(
                                      fontSize: 14,
                                    )),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 15.0),
                              child: Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.white,
                                ),
                                child: TextField(
                                  controller: mobileController,
                                  readOnly: true,
                                  decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'Mobile Number',
                                      labelStyle: TextStyle(
                                        fontSize: 14,
                                      )),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 15.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.white,
                                ),
                                height: 50,
                                child: TextField(
                                  controller: whatsAppController,
                                  decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'Whatsapp Number (optional)',
                                      labelStyle: TextStyle(
                                        fontSize: 14,
                                      )),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 15.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.white,
                                ),
                                height: 50,
                                child: TextField(
                                  controller: emailController,
                                  decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'Email ID',
                                      labelStyle: TextStyle(
                                        fontSize: 14,
                                      )),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 15.0),
                              child: Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.white,
                                ),
                                child: TextField(
                                  controller: guardianNameController,
                                  decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText:
                                          "Guardian's Full Name (optional)",
                                      labelStyle: TextStyle(
                                        fontSize: 14,
                                      )),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 15.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.white,
                                ),
                                height: 50,
                                child: TextField(
                                  controller: birthdayController,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'Birthday (optional)',
                                      labelStyle: TextStyle(
                                        fontSize: 14,
                                      )),
                                ),
                              ),
                            ),
                            Container(
                              height: 60,
                              margin:
                                  const EdgeInsets.only(bottom: 10, top: 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextViewBold(
                                    textContent: "Married (optional)",
                                    textSizeNumber: 13,
                                    textColor: Colors.black,
                                  ),
                                  Row(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            isMarried = true;
                                          });
                                        },
                                        child: Container(
                                          height: 30,
                                          padding: const EdgeInsets.only(
                                            left: 10,
                                            right: 10,
                                          ),
                                          margin: const EdgeInsets.only(
                                            top: 10,
                                            right: 10,
                                          ),
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  width: 0.5,
                                                  color: Colors.black),
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              color: isMarried
                                                  ? const Color(0xFF09636E)
                                                  : Colors.white),
                                          alignment: Alignment.center,
                                          child: TextViewBold(
                                            textContent: "Yes",
                                            textSizeNumber: 14,
                                            textColor: Colors.black,
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            isMarried = false;
                                          });
                                        },
                                        child: Container(
                                          height: 30,
                                          padding: const EdgeInsets.only(
                                            left: 10,
                                            right: 10,
                                          ),
                                          margin: const EdgeInsets.only(
                                            top: 10,
                                            left: 10,
                                            right: 10,
                                          ),
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  width: 0.5,
                                                  color: Colors.black),
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              color: isMarried
                                                  ? Colors.white
                                                  : const Color(0xFF09636E)),
                                          alignment: Alignment.center,
                                          child: TextViewBold(
                                            textContent: "No",
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
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(
                          top: 10,
                          left: 10,
                          right: 10,
                        ),
                        padding: const EdgeInsets.only(
                            left: 20, right: 20, top: 20, bottom: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color(0xFF09636E).withOpacity(0.4),
                        ),
                        width: (MediaQuery.of(context).size.width) - 20,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 10.0, bottom: 10.0),
                              child: TextViewBold(
                                textContent: "Academic Details (Optional)",
                                textSizeNumber: 18,
                                textColor: Colors.black,
                              ),
                            ),
                            Container(
                              height: 60,
                              margin: const EdgeInsets.only(bottom: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextViewBold(
                                    textContent: "Select Highest Education",
                                    textSizeNumber: 13,
                                    textColor: Colors.black,
                                  ),
                                  Row(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            highestDegree = "Graduation";
                                          });
                                        },
                                        child: Container(
                                          height: 30,
                                          padding: const EdgeInsets.only(
                                            left: 10,
                                            right: 10,
                                          ),
                                          margin: const EdgeInsets.only(
                                            top: 10,
                                            right: 10,
                                          ),
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  width: 0.5,
                                                  color: Colors.black),
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              color:
                                                  highestDegree.toLowerCase() ==
                                                          "graduation"
                                                      ? const Color(0xFF09636E)
                                                      : Colors.white),
                                          alignment: Alignment.center,
                                          child: TextViewBold(
                                            textContent: "Graduation",
                                            textSizeNumber: 14,
                                            textColor: Colors.black,
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            highestDegree = "Masters";
                                          });
                                        },
                                        child: Container(
                                          height: 30,
                                          padding: const EdgeInsets.only(
                                            left: 10,
                                            right: 10,
                                          ),
                                          margin: const EdgeInsets.only(
                                            top: 10,
                                            left: 10,
                                            right: 10,
                                          ),
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  width: 0.5,
                                                  color: Colors.black),
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              color:
                                                  highestDegree.toLowerCase() ==
                                                          "masters"
                                                      ? const Color(0xFF09636E)
                                                      : Colors.white),
                                          alignment: Alignment.center,
                                          child: TextViewBold(
                                            textContent: "Masters",
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
                            Container(
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.white,
                              ),
                              child: TextField(
                                controller: collegeController,
                                obscureText: false,
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'College/ University Name',
                                    labelStyle: TextStyle(
                                      fontSize: 14,
                                    )),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(
                          left: 10,
                          right: 10,
                          top: 10,
                        ),
                        padding: const EdgeInsets.only(
                            left: 20, right: 20, top: 20, bottom: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color(0xFF09636E).withOpacity(0.4),
                        ),
                        width: (MediaQuery.of(context).size.width) - 20,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 10.0, bottom: 10.0),
                              child: TextViewBold(
                                textContent: "Address (Optional)",
                                textSizeNumber: 18,
                                textColor: Colors.black,
                              ),
                            ),
                            Container(
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.white,
                              ),
                              child: TextField(
                                controller: pinCodeController,
                                obscureText: false,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Pin Code',
                                  labelStyle: TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 15.0),
                              child: Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.white,
                                ),
                                child: TextField(
                                  controller: line1Controller,
                                  decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'Address Line',
                                      labelStyle: TextStyle(
                                        fontSize: 14,
                                      )),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 15.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.white,
                                ),
                                height: 50,
                                child: TextField(
                                  controller: localityController,
                                  decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'Locality',
                                      labelStyle: TextStyle(
                                        fontSize: 14,
                                      )),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 15.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.white,
                                ),
                                height: 50,
                                child: TextField(
                                  controller: cityController,
                                  decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'Town / City',
                                      labelStyle: TextStyle(
                                        fontSize: 14,
                                      )),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 15.0),
                              child: Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.white,
                                ),
                                child: TextField(
                                  controller: stateController,
                                  decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: "State",
                                      labelStyle: TextStyle(
                                        fontSize: 14,
                                      )),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 40,
                        alignment: Alignment.center,
                        margin: const EdgeInsets.only(top: 10),
                        width: MediaQuery.of(context).size.width - 20,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.grey),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Checkbox(
                                value: isTmsAccepted,
                                activeColor: Colors.green,
                                onChanged: (bool? value) {
                                  setState(() {
                                    isTmsAccepted = !isTmsAccepted;
                                  });
                                }),
                            Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: TextViewNormal(
                                textContent:
                                    "I agree to Terms & Condition and Privacy Policy",
                                textSizeNumber: 12,
                                textColor: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () async {
                if (isTmsAccepted) {
                  Student student = Student(
                      studentName: nameController.text.trim(),
                      studentProfileImage:
                          studentVM.student?.studentProfileImage ??
                              stringDefault,
                      studentPhoneNumber: mobileController.text,
                      studentWhatsappNumber: whatsAppController.text.trim(),
                      studentEmail: emailController.text.trim(),
                      birthDay: birthdayController.text.trim(),
                      isMarried: isMarried,
                      guardianFullName: guardianNameController.text.trim(),
                      highestDegree: highestDegree.trim(),
                      collegeName: collegeController.text.trim(),
                      isTmsAccepted: true,
                      address: Address(
                          pinCodeController.text.trim(),
                          line1Controller.text.trim(),
                          localityController.text.trim(),
                          cityController.text.trim(),
                          stateController.text.trim()));
                  AppLoader.showLoader(context);
                  try {
                    _studentViewModel
                        .updateStudent(student)
                        .then((value) async {
                      sp?.setStringToPref(
                          SPKeys.name, nameController.text.trim());

                      if (isImageSelected) {
                        await StudentRepo()
                            .uploadStudentImage(userImage!)
                            .then((value) {
                          log("Image uploaded successfully");
                        });
                      }

                      _studentViewModel.setCurrentStudentData();
                      AppLoader.hideLoader(context);
                      Helper.showSnackBarMessage(
                          msg: "Profile updated successfully", isSuccess: true);
                    });
                  } catch (e) {
                    AppLoader.hideLoader(context);
                    Helper.showSnackBarMessage(
                        msg: "Sorry something went wrong", isSuccess: false);
                  }
                } else {
                  Helper.showSnackBarMessage(
                      msg: "Please accept terms & condition", isSuccess: false);
                }
              },
              child: Container(
                height: 50,
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.center,
                margin: const EdgeInsets.only(
                  left: 10,
                  right: 10,
                  bottom: 10,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color(0xFF09636E),
                ),
                child: TextViewBold(
                    textContent: "Save Changes", textSizeNumber: 20),
              ),
            )
          ],
        );
      }),
    ));
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
