// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:b_barna_app/core/constants/value_constants.dart';
import 'package:b_barna_app/textSize/text_view_bold.dart';

class CourseCard extends StatelessWidget {
  String? courseImage;
  String? courseText;
  bool? isUpperStackCardVisible;
  double? sellingPrice;
  double? coursePrice;
  Function? onTapBuy;

  CourseCard(
      {super.key,
      required this.courseImage,
      required this.courseText,
      required this.isUpperStackCardVisible,
      this.sellingPrice = 0.0,
      this.coursePrice = 0.0,
      this.onTapBuy});

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
            // height: 260,
            //width: 180,
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
                  blurRadius: 2.0,
                  spreadRadius: 1.0,
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
                    child: Image.network(
                      courseImage!,
                      height: 160,
                      width: 160,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                willTextOverFlow(title: courseText ?? stringDefault)
                    ? SizedBox(
                        width: 180,
                        height: 20,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                          child: Marquee(
                            text: courseText ?? stringDefault,
                            velocity: 20,
                            blankSpace: 50,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Colors.black,
                              overflow: TextOverflow.ellipsis,
                              letterSpacing: 0.6,
                              fontFamily: 'Lato-Bold',
                            ),
                          ),
                        ))
                    : Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                        child: TextViewBold(
                          textContent: courseText,
                          textSizeNumber: 15,
                          textColor: Colors.black,
                        ),
                      ),
                if (isUpperStackCardVisible!)
                  InkWell(
                    onTap: () {
                      onTapBuy!();
                    },
                    child: Container(
                      height: 25,
                      width: 180,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 3),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(3)),
                      child: TextViewBold(
                        textContent: (sellingPrice != 0 && sellingPrice != -1)
                            ? "Pay (₹ $sellingPrice/-)"
                            : "Pay (₹ $coursePrice/-)",
                        textSizeNumber: 16,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          // Visibility(
          //   visible: isUpperStackCardVisible!,
          //   child: Container(
          //     height: 25,
          //     width: 60,
          //     alignment: Alignment.center,
          //     decoration: const BoxDecoration(
          //       borderRadius: BorderRadius.only(
          //         topLeft: Radius.circular(10),
          //         bottomRight: Radius.circular(10),
          //       ),
          //       color: Color(0xFF09636E),
          //     ),
          //     child: TextViewNormal(
          //       textContent: sellingPrice.toString(),
          //       textSizeNumber: 13,
          //     ),
          //   ),
          // ),
          if (isUpperStackCardVisible! &&
              sellingPrice != 0 &&
              sellingPrice != -1)
            Positioned(
              right: 0,
              top: 0,
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
                  textContent: "${getDiscountPercent()}% OFF",
                  textSizeNumber: 12,
                ),
              ),
            ),
        ],
      ),
    );
  }

  bool willTextOverFlow({required String title}) {
    final TextPainter textPainter = TextPainter(
        text: TextSpan(
            text: title,
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 17,
                color: Colors.black,
                overflow: TextOverflow.ellipsis,
                letterSpacing: 0.6,
                fontFamily: 'Lato-Bold')),
        maxLines: 1,
        textDirection: TextDirection.ltr)
      ..layout(maxWidth: 160, minWidth: 0);
    return textPainter.didExceedMaxLines;
  }

  int getDiscountPercent() {
    int discount = 0;
    discount = (coursePrice! - sellingPrice!).toInt();
    return ((discount / coursePrice!) * 100).toInt();
  }
}
