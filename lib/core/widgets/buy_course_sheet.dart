// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:b_barna_app/core/constants/value_constants.dart';
import 'package:b_barna_app/textSize/text_view_bold.dart';
import 'package:b_barna_app/utils/size_config.dart';

class BuyCourseSheet extends StatelessWidget {
  late Function buyCourse;
  String buttonTitle = stringDefault;
  BuyCourseSheet(
      {required this.buyCourse, required this.buttonTitle, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      //250
      height: 80,
      width: SizeConfig.screenWidth,
      padding: const EdgeInsets.only(
        top: 15,
        bottom: 15,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color(0xFF09636E).withOpacity(0.05),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //   children: [
          //     SizedBox(
          //       height: 80,
          //       width: ((MediaQuery.of(context).size.width) - 40) / 2,
          //       child: Column(
          //         mainAxisAlignment: MainAxisAlignment.center,
          //         crossAxisAlignment: CrossAxisAlignment.start,
          //         children: [
          //           TextViewBold(
          //             textContent: "Change Plan",
          //             textSizeNumber: 14,
          //             textColor: Colors.black,
          //           ),
          //           TextViewBold(
          //             textContent: "1 Year 16000/-",
          //             textSizeNumber: 14,
          //             textColor: Colors.black,
          //           ),
          //         ],
          //       ),
          //     ),
          //     Container(
          //       height: 80,
          //       width: ((MediaQuery.of(context).size.width) - 40) / 2,
          //       alignment: Alignment.center,
          //       decoration: BoxDecoration(
          //         borderRadius: BorderRadius.circular(10),
          //         color: Colors.greenAccent,
          //       ),
          //       child: Padding(
          //         padding: const EdgeInsets.only(left: 8.0),
          //         child: Column(
          //           mainAxisAlignment: MainAxisAlignment.center,
          //           crossAxisAlignment: CrossAxisAlignment.start,
          //           children: [
          //             Row(
          //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //               children: [
          //                 TextViewBold(
          //                   textContent: "Code: BAI05000",
          //                   textSizeNumber: 14,
          //                   textColor: Colors.black,
          //                 ),
          //                 const Padding(
          //                   padding: EdgeInsets.only(right: 8.0),
          //                   child: Icon(
          //                     Icons.edit,
          //                     size: 18,
          //                   ),
          //                 )
          //               ],
          //             ),
          //             TextViewBold(
          //               textContent: "Discounted RS: 5000/-",
          //               textSizeNumber: 14,
          //               textColor: Colors.black,
          //             ),
          //           ],
          //         ),
          //       ),
          //     ),
          //   ],
          // ),
          // Container(
          //   height: 40,
          //   width: (MediaQuery.of(context).size.width) - 40,
          //   alignment: Alignment.center,
          //   decoration: BoxDecoration(
          //     borderRadius: BorderRadius.circular(10),
          //     color: Colors.greenAccent,
          //   ),
          //   child: TextViewBold(
          //     textContent: "Discounted Price: 11999/-",
          //     textSizeNumber: 16,
          //     textColor: Colors.black,
          //   ),
          // ),
          InkWell(
            onTap: () {
              buyCourse();
            },
            child: Container(
              height: 50,
              width: (MediaQuery.of(context).size.width) - 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color(0xFF09636E)),
              child: TextViewBold(
                textContent: buttonTitle,
                textSizeNumber: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
