import 'package:flutter/material.dart';
import 'package:b_barna_app/core/constants/value_constants.dart';
import 'package:b_barna_app/core/route/route_name.dart';
import 'package:b_barna_app/student/viewModel/student_vm.dart';
import 'package:b_barna_app/utils/size_config.dart';
import 'package:b_barna_app/utils/sp_keys.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    sp?.setBoolToPref(SPKeys.canTopicAccess, false);
    Future.delayed(const Duration(seconds: 2), () async {
      if ((sp?.getBoolFromPref(SPKeys.isLoggedIn))!) {
        await Provider.of<StudentViewModel>(context, listen: false)
            .setCurrentStudentData()
            .then((value) {
          Navigator.pushNamedAndRemoveUntil(
              context, RouteName.bottomNavBarScreenRoute, (route) => false);
        });
      } else {
        Navigator.pushNamedAndRemoveUntil(
            context, RouteName.loginScreenRoute, (route) => false);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Container(
        color: Colors.white,
        height: SizeConfig.screenHeight,
        width: SizeConfig.screenWidth,
        child: Center(
          child: Image.asset(
            "assets/images/png/logo.png",
            height: 200,
            width: 200,
          ),
        ),
      ),
    ));
  }
}
