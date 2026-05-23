import 'package:b_barna_app/core/widgets/app_update_dialog.dart';
import 'package:b_barna_app/utils/app_update_service.dart';
import 'package:flutter/material.dart';
import 'package:b_barna_app/core/constants/value_constants.dart';
import 'package:b_barna_app/core/route/route_name.dart';
import 'package:b_barna_app/student/viewModel/student_vm.dart';
import 'package:b_barna_app/utils/size_config.dart';
import 'package:b_barna_app/utils/sp_keys.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    sp?.setBoolToPref(SPKeys.canTopicAccess, false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        getUpdateStatus(context);
      }
    });
  }

  Future<void> getUpdateStatus(BuildContext context) async {
    final updateService = AppUpdateService();
    final result = await updateService.checkForUpdate();

    if (!context.mounted) return;

    if (!result.hasUpdate) {
      await Future.delayed(const Duration(milliseconds: 100));

      if (!context.mounted) return;

      await _navigateAfterCheck(context);
    } else {
      int count = sp?.getIntFromPref("skipCount") ?? 0;
      final bool skipLimitReached =
          result.skipCount > 0 && count >= result.skipCount;

      final bool showAsForce = result.forceUpdate || skipLimitReached;

      showGeneralDialog(
          context: context,
          barrierColor: Colors.black54,
          useRootNavigator: true,
          barrierLabel: 'Update Dialog',
          barrierDismissible: !showAsForce,
          transitionDuration: const Duration(milliseconds: 2000),
          pageBuilder: (_, __, ___) {
            return AppUpdateDialog(
              isForceUpdate: showAsForce,
              onUpdate: () {
                Navigator.pop(context);
                _launchStore();
              },
              onSkip: showAsForce
                  ? null
                  : () async {
                Navigator.of(context, rootNavigator: true).pop();

                      sp?.setIntToPref("skipCount", count + 1);

                      if (!context.mounted) return;

                      await _navigateAfterCheck(context);
                    },
            );
          });
    }
  }

  Future<void> _navigateAfterCheck(BuildContext context) async {
    final isLoggedIn = sp?.getBoolFromPref(SPKeys.isLoggedIn) ?? false;

    if (isLoggedIn) {
      await Provider.of<StudentViewModel>(context, listen: false)
          .setCurrentStudentData();

      if (!context.mounted) return;

      Navigator.pushNamedAndRemoveUntil(
        context,
        RouteName.bottomNavBarScreenRoute,
        (route) => false,
      );
    } else {
      Navigator.pushNamedAndRemoveUntil(
        context,
        RouteName.loginScreenRoute,
        (route) => false,
      );
    }
  }

  Future<void> _launchStore() async {
    const storeUrl =
        'https://play.google.com/store/apps/details?id=com.bbarna.b_barna_app';
    final uri = Uri.parse(storeUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SizedBox(
          // color: Colors.white,
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
      ),
    );
  }
}
