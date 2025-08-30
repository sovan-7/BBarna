// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:b_barna_app/textSize/text_view_bold.dart';

class DeleteAccount extends StatelessWidget {
  Function? onSubmit;
  DeleteAccount({required this.onSubmit, super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      alignment: Alignment.center,
      backgroundColor:Colors.white,
      //const Color(0xFF09636E),
      //Colors.lightBlue,
      actionsAlignment: MainAxisAlignment.end,
      title: TextViewBold(
        textContent: "DELETE ACCOUNT",
        textSizeNumber: 15,
        textAlign: TextAlign.center,
        textColor: Colors.red,
      ),
      titlePadding: const EdgeInsets.symmetric(vertical: 12),
      contentPadding: const EdgeInsets.only(bottom: 40, top: 10),
      content: TextViewBold(
        textContent: "Are you sure, want to delete your account ?",
        textSizeNumber: 15,
        textAlign: TextAlign.center,
        maxLines: 2,
        textColor: Colors.black,
      ),
      actionsPadding: const EdgeInsets.only(bottom: 20, right: 15),
      actions: [
        InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            height: 28,
            width: 70,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3), color: Colors.red[800]),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 3),
              child: TextViewBold(
                textContent: "Cancel",
                textSizeNumber: 15,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
        const SizedBox(
          width: 3,
        ),
        InkWell(
          onTap: () {
            onSubmit!();
          },
          child: Container(
            height: 28,
            width: 70,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                color: Colors.green[800]),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 3),
              child: TextViewBold(
                textContent: "Yes",
                textSizeNumber: 15,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
