import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:b_barna_app/core/constants/value_constants.dart';
import 'package:b_barna_app/core/route/route_name.dart';
import 'package:b_barna_app/textSize/text_view_bold.dart';
import 'package:b_barna_app/textSize/text_view_normal.dart';
import 'package:b_barna_app/utils/helper.dart';
import 'package:b_barna_app/utils/sp_keys.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController phoneController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: PopScope(
        onPopInvoked: (isPopped) {
          SystemNavigator.pop(animated: true);
        },
        child: Scaffold(
          body: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 20, right: 20, top: 20, bottom: 20),
              child: Column(
                children: [
                  Image.asset(
                    "assets/images/png/logo.png",
                    height: 140,
                    width: 140,
                  ),
                  const SizedBox(
                    height: 28,
                  ),
                  Row(
                    children: [
                      InkWell(
                        onTap: () {},
                        child: TextViewBold(
                          textContent: "Login",
                          textSizeNumber: 28,
                          textColor: Colors.black,
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      TextViewNormal(
                        textContent: "Welcome Back!",
                        textSizeNumber: 18,
                        textColor: Colors.black,
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextField(
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      maxLength: 10,
                      decoration: InputDecoration(
                        counterText: "",
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(
                              color: Color(0xFF09636E), width: 2),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide:
                              const BorderSide(color: Colors.grey, width: 2),
                        ),
                        hintText: "Phone Number",
                      )),
                  const SizedBox(
                    height: 20,
                  ),
                  TextField(
                      controller: nameController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(
                              color: Color(0xFF09636E), width: 2),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide:
                              const BorderSide(color: Colors.grey, width: 2),
                        ),
                        hintText: "Student Name",
                      )),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 0),
                    child: InkWell(
                      onTap: () async {
                        final FirebaseFirestore fireStore =
                            FirebaseFirestore.instance;
                        if (phoneController.text.length == 10 &&
                            nameController.text.trim().isNotEmpty) {
                          try {
                            CollectionReference collectionReference =
                                fireStore.collection(student);
                            QuerySnapshot querySnapshot =
                                await collectionReference
                                    .where("mobile_number",
                                        isEqualTo: phoneController.text)
                                    .get();
                            if (querySnapshot.docs.isEmpty) {
                              await fireStore.collection(student).add({
                                "name": nameController.text.trim(),
                                "mobile_number": phoneController.text,
                                "device_count": 0,
                                "login_time":
                                    DateTime.now().millisecondsSinceEpoch
                              }).then((value) {
                                sp?.setStringToPref(SPKeys.studentId, value.id);
                                sp?.setBoolToPref(SPKeys.isLoggedIn, true);
                                sp!.setStringToPref(
                                    SPKeys.name, nameController.text);
                                sp!.setStringToPref(
                                    SPKeys.phoneNumber, phoneController.text);
                                Navigator.pushNamedAndRemoveUntil(
                                    context,
                                    RouteName.bottomNavBarScreenRoute,
                                    (route) => false);
                              });
                            } else if (querySnapshot
                                    .docs.first["device_count"] ==
                                0) {
                              await fireStore
                                  .collection('student')
                                  .doc(querySnapshot.docs.first.id)
                                  .update({
                                "name": nameController.text.trim(),
                                "mobile_number": phoneController.text,
                                "device_count": 0,
                              }).then((value) {
                                sp?.setStringToPref(SPKeys.studentId,
                                    querySnapshot.docs.first.id);
                                sp?.setBoolToPref(SPKeys.isLoggedIn, true);
                                sp!.setStringToPref(
                                    SPKeys.name, nameController.text);
                                sp!.setStringToPref(
                                    SPKeys.phoneNumber, phoneController.text);
                                Navigator.pushNamedAndRemoveUntil(
                                    context,
                                    RouteName.bottomNavBarScreenRoute,
                                    (route) => false);
                              });
                            } else {
                              Helper.showSnackBarMessage(
                                  msg: "You have logged in on other device",
                                  isSuccess: false);
                            }
                          } catch (e) {
                            log(e.toString());
                            Helper.showSnackBarMessage(
                                msg: "Sorry something went wrong",
                                isSuccess: false);
                          }
                        } else {
                          if (phoneController.text.length < 10) {
                            Helper.showSnackBarMessage(
                                msg: "Phone number must be 10 digit",
                                isSuccess: false);
                          } else if (nameController.text.trim().isEmpty) {
                            Helper.showSnackBarMessage(
                                msg: "Name is required", isSuccess: false);
                          }
                        }

                        // FirebaseAuth firebaseAuth = FirebaseAuth.instance;
                        // AppLoader.showLoader(context);
                        // await firebaseAuth.verifyPhoneNumber(
                        //   phoneNumber: "+91${phoneController.text}",
                        //   verificationCompleted:
                        //       (PhoneAuthCredential credential) async {
                        //     // Auto-retrieve verification code
                        //     await firebaseAuth.signInWithCredential(credential);
                        //   },
                        //   verificationFailed: (FirebaseAuthException e) {
                        //     log(e.toString());
                        //     // Verification failed
                        //     AppLoader.hideLoader(context);
                        //   },
                        //   codeSent:
                        //       (String verificationId, int? resendToken) async {
                        //     AppLoader.hideLoader(context);
                        //     Navigator.pushNamed(
                        //         context, RouteName.otpVerificationScreenRoute,
                        //         arguments: {
                        //           "verificationId": verificationId,
                        //           "phoneNumber": phoneController.text
                        //         });
                        //   },
                        //   codeAutoRetrievalTimeout: (String verificationId) {},
                        //   timeout: const Duration(seconds: 60),
                        // );
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 52,
                        decoration: BoxDecoration(
                            color: const Color(0xFF09636E),
                            borderRadius: BorderRadius.circular(8)),
                        child: Center(
                            child: TextViewBold(
                          textContent: "Login",
                          //'Get OTP',
                          textSizeNumber: 16,
                        )),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
