// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class TextViewNormal extends StatelessWidget {
  String? textContent;
  double? textSizeNumber;
  Color? textColor;
  TextAlign textAlign;
  TextViewNormal({
    super.key,
    required this.textContent,
    required this.textSizeNumber,
    this.textColor = Colors.white,
    this.textAlign = TextAlign.center
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      textContent!,
      maxLines: 3,
      textAlign: textAlign,
      style: TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: textSizeNumber!,
          color: textColor,
          overflow: TextOverflow.ellipsis,
          fontFamily: 'Lato-Light',
          letterSpacing: 0.8),
    );
  }
}
