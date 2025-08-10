// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:b_barna_app/textSize/text_view_bold.dart';
import 'package:b_barna_app/textSize/text_view_normal.dart';

class CourseSubCard extends StatelessWidget {
  String? courseImage;
  String? courseText;
  bool? isUpperStackCardVisible;
  String? upperText;

  CourseSubCard(
      {super.key,
      required this.courseImage,
      required this.courseText,
      required this.isUpperStackCardVisible,
      this.upperText = "Free"});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 10.0,
        right: 5.0,
      ),
      child: Stack(
        children: [
          Container(
            height: 180,
            width: 150,
            margin: const EdgeInsets.only(
              top: 10,
              bottom: 10,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: const Color(0xFF09636E).withOpacity(0.1),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  offset: const Offset(
                    3.0,
                    3.0,
                  ),
                  blurRadius: 4.0,
                  spreadRadius: 2.0,
                ), //BoxShadow
                const BoxShadow(
                  color: Colors.white,
                  offset: Offset(0.0, 0.0),
                  blurRadius: 0.0,
                  spreadRadius: 0.0,
                ), //BoxShadow
              ],
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 10.0,
                    bottom: 10.0,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      courseImage!,
                      height: 130,
                      width: 130,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  child: TextViewBold(
                    textContent: courseText,
                    textSizeNumber: 15,
                    textColor: Colors.black,
                  ),
                )
              ],
            ),
          ),
          Visibility(
            visible: isUpperStackCardVisible!,
            child: Container(
              height: 25,
              width: 60,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
                color: Color(0xFF09636E),
              ),
              child: TextViewNormal(
                textContent: upperText,
                textSizeNumber: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
