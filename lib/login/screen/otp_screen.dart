// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:b_barna_app/core/constants/value_constants.dart';
import 'package:b_barna_app/core/route/route_name.dart';
import 'package:b_barna_app/core/widgets/app_loader.dart';
import 'package:b_barna_app/student/viewModel/student_vm.dart';
import 'package:b_barna_app/textSize/text_view_bold.dart';
import 'package:b_barna_app/textSize/text_view_normal.dart';
import 'package:b_barna_app/utils/sp_keys.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

class OTPScreen extends StatefulWidget {
  const OTPScreen(
      {required this.verificationId, required this.phoneNumber, super.key});

  final String verificationId;
  final String phoneNumber;

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(
                  height: 28,
                ),
                Image.asset(
                  "assets/images/png/logo.png",
                  height: 140,
                  width: 140,
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    TextViewBold(
                      textContent: "Enter OTP",
                      textSizeNumber: 28,
                      textColor: Colors.black,
                    )
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextViewNormal(
                        textContent:
                            "Enter 6 digit OTP sent to (+91${widget.phoneNumber})",
                        textSizeNumber: 16,
                        textColor: Colors.black,
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                PinCodeTextField(
                  keyboardType: TextInputType.number,
                  length: 6,
                  obscureText: false,
                  animationType: AnimationType.fade,
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    inactiveColor: Colors.grey,
                    inactiveFillColor: Colors.transparent,
                    borderRadius: BorderRadius.circular(5),
                    fieldHeight: 50,
                    fieldWidth: 40,
                    activeFillColor: Colors.white,
                  ),
                  animationDuration: const Duration(milliseconds: 300),
                  enableActiveFill: false,
                  // errorAnimationController: errorController,
                  // controller: textEditingController,
                  onCompleted: (v) async {
                    AppLoader.showLoader(context);
                    try {
                      final cred = PhoneAuthProvider.credential(
                          verificationId: widget.verificationId, smsCode: v);
                      await FirebaseAuth.instance
                          .signInWithCredential(cred)
                          .then((value) async {
                        await sp?.setStringToPref(
                            SPKeys.phoneNumber, widget.phoneNumber);

                        await Provider.of<StudentViewModel>(context,
                                listen: false)
                            .isStudentExist()
                            .then((value) async {
                          if (value) {
                            await Provider.of<StudentViewModel>(context,
                                    listen: false)
                                .setCurrentStudentData()
                                .then((value) {
                              AppLoader.hideLoader(context);
                              //  sp?.setBoolToPref(SPKeys.isLoggedIn, true);
                              Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  RouteName.bottomNavBarScreenRoute,
                                  (r) => false);
                            });
                          } else {
                            AppLoader.hideLoader(context);
                            Navigator.pushNamed(
                                context, RouteName.registrationScreenRoute);
                          }
                        });
                      });
                    } catch (e) {
                      log(e.toString());
                    }
                  },
                  onChanged: (value) {},
                  beforeTextPaste: (text) {
                    //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                    //but you can show anything you want here, like your pop up saying wrong paste format or etc
                    return true;
                  },
                  appContext: context,
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: InkWell(
                    onTap: () {
                      //Navigator.pushNamed(context, RouteName.bottomNavBarScreenRoute);
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 52,
                      decoration: BoxDecoration(
                          color: const Color(0xFF09636E),
                          borderRadius: BorderRadius.circular(8)),
                      child: Center(
                          child: TextViewBold(
                        textContent: 'Verify OTP',
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
    );
  }
}
