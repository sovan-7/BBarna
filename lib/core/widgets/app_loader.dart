import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class AppLoader {
  static bool isLoaderVisible = false;
  static void showLoader(BuildContext context) {
    Future.delayed(Duration.zero, () async {
      if (!AppLoader.isLoaderVisible) {
        AppLoader.isLoaderVisible = true;
        log("Loader Visible======");
        try {
          showGeneralDialog(
              context: context,
              barrierDismissible: false,
              barrierLabel: "",
              transitionDuration: const Duration(milliseconds: 200),
              pageBuilder: (BuildContext buildContext, Animation animation,
                  Animation secondaryAnimation) {
                return PopScope(
                  canPop: false,
                  child: Container(
                    color: Colors.black.withOpacity(0.4),
                    alignment: Alignment.center,
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: Lottie.asset('assets/json/loader.json',
                        height: 100, fit: BoxFit.fitWidth),
                  ),
                );
              }).whenComplete(() {
            isLoaderVisible = false;
          });
        } catch (e) {
          log(e.toString());
        }
      }
    });
  }

  static void hideLoader(BuildContext context) {
    if (AppLoader.isLoaderVisible) {
      log("Hide Loader====");
      Navigator.pop(context);
      AppLoader.isLoaderVisible = false;
    }
  }
}
