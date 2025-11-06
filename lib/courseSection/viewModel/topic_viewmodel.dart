import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:b_barna_app/courseSection/model/topic_model.dart';
import 'package:b_barna_app/courseSection/repo/topic_repo.dart';

class TopicViewModel extends ChangeNotifier {
  final TopicRepo _topicRepo = TopicRepo();
  List<TopicModel> topicList = [];
  late List<Color> cardColorList;
  late List<Color> textColorList;
  Future<void> getTopicList(String unitCode) async {
    try {
      topicList.clear();
      topicList = await _topicRepo.getTopicList(unitCode);
      topicList.sort((a, b) => a.displayPriority.compareTo(b.displayPriority));
      generateColorList(topicList.length);
      notifyListeners();
    } catch (e) {
      // Helper.showSnackBarMessage(
      //     msg: "Error while fetching data", isSuccess: false);
    }
  }

  void generateColorList(int listLen) {
    const color1 = Color(0xffCEF1F5);
    const color2 = Color(0xffD1E6DD);
    const color3 = Color(0xffF7D7DA);
    const color4 = Color(0xffFFF3CD);
    const textColor1 = Color(0xff4d858a);
    const textColor2 = Color(0xff578f77);
    const textColor3 = Color(0xff875055);
    const textColor4 = Color(0xff877a4c);
    cardColorList = List.generate(listLen, (index) => Colors.black);
    textColorList = List.generate(listLen, (index) => Colors.black);

    if (listLen < 5 && cardColorList.isNotEmpty) {
      try {
        cardColorList[0] = color1;
        textColorList[0] = textColor1;
        cardColorList[1] = color2;
        textColorList[1] = textColor2;
        cardColorList[2] = color3;
        textColorList[2] = textColor3;
        cardColorList[3] = color4;
        textColorList[3] = textColor4;
      } catch (e) {
        log(e.toString());
      }
    } else {
      int extraLen = listLen % 4;
      int newListLen = listLen - extraLen;
      var index = 0;
      for (index = 0; index < newListLen; index += 4) {
        try {
          cardColorList[index] = color1;
          textColorList[index] = textColor1;
          cardColorList[index + 1] = color2;
          textColorList[index + 1] = textColor2;
          cardColorList[index + 2] = color3;
          textColorList[index + 2] = textColor3;
          cardColorList[index + 3] = color4;
          textColorList[index + 3] = textColor3;
        } catch (e) {
          log(e.toString());
        }
      }
      switch (extraLen) {
        case 1:
          cardColorList[index] = color1;
          textColorList[index] = textColor1;
          break;
        case 2:
          cardColorList[index] = color1;
          cardColorList[index + 1] = color2;
          textColorList[index] = textColor1;
          textColorList[index + 1] = textColor2;
          break;
        case 3:
          cardColorList[index] = color1;
          cardColorList[index + 1] = color2;
          cardColorList[index + 2] = color3;
          textColorList[index] = textColor1;
          textColorList[index + 1] = textColor2;
          textColorList[index + 2] = textColor3;
          break;
      }
    }
    notifyListeners();
  }
}
