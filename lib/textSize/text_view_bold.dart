// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class TextViewBold extends StatelessWidget {
  String? textContent;
  double? textSizeNumber;
  Color? textColor;
  TextAlign textAlign = TextAlign.center;
  int maxLines = 15;
  TextViewBold({
    super.key,
    required this.textContent,
    required this.textSizeNumber,
    this.textColor = Colors.white,
    this.textAlign = TextAlign.start,
    this.maxLines=15
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      "$textContent",
      maxLines: maxLines,
      textAlign: textAlign,
      overflow: TextOverflow.ellipsis,
      softWrap: true,
      style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: textSizeNumber!,
          color: textColor,
          overflow: TextOverflow.ellipsis,
          letterSpacing: 0.6,
          fontFamily: 'Lato-Bold'),
    );
  }
}
