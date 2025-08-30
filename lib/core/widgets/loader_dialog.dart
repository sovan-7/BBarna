import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoaderDialog {
  static void show(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // prevent closing by tapping outside
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent, // transparent background
          elevation: 0,
          child: Center(
            child: SpinKitCircle(
              itemBuilder: (BuildContext context, int index) {
                return DecoratedBox(
                  decoration: BoxDecoration(
                      color: index.isEven ? Color(0xFF09636E) : Colors.white,
                      borderRadius: BorderRadius.circular(3)),
                );
              },
            ),
          ),
        );
      },
    );
  }

  static void hide(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop(); // close dialog
  }
}
