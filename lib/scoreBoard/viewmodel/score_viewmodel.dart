import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:b_barna_app/core/constants/value_constants.dart';
import 'package:b_barna_app/quiz/model/question_model.dart';
import 'package:b_barna_app/quiz/model/result_model.dart';
import 'package:b_barna_app/utils/sp_keys.dart';

class ScoreViewModel extends ChangeNotifier {
  ResultModel? quizModel;
  List<ResultModel> topperList = [];
  int selectedQuestionIndex = 0;
  List<QuestionModel> questionList = [];
  int answerIndex = intDefault;
  int selectedAnswer = intDefault;
  clearQuiz() {
    quizModel = null;
  }

  Future getQuizResult(String quizCode) async {
    try {
      CollectionReference collectionReference =
          FirebaseFirestore.instance.collection(results);
      QuerySnapshot querySnapshot = await collectionReference
          .where("student_id",
              isEqualTo: sp!.getStringFromPref(SPKeys.studentId))
          .where("quiz_code", isEqualTo: quizCode)
          .get();
      Map<String, dynamic> docData =
          querySnapshot.docs.first.data() as Map<String, dynamic>;
      quizModel = ResultModel(
          sp!.getStringFromPref(SPKeys.studentId),
          sp!.getStringFromPref(SPKeys.name),
          docData["quiz_code"],
          docData["quiz_name"],
          docData["attempt_count"] ?? intDefault,
          docData["time_stamp"] ?? intDefault,
          docData["time_taken"] ?? intDefault,
          docData["correct_answered"] ?? intDefault,
          docData["un_answered"] ?? intDefault,
          docData["wrong_answered"] ?? intDefault,
          docData["actual_time"] ?? intDefault,
          docData['question_list'] == null
              ? []
              : List<QuestionModel>.from(
                  docData['question_list']
                      .map((question) => QuestionModel.fromMap(question)),
                ));
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        notifyListeners();
      });
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  Future getTopperList(String quizCode) async {
    try {
      topperList.clear();
      CollectionReference collectionReference =
          FirebaseFirestore.instance.collection(results);
      QuerySnapshot querySnapshot = await collectionReference
          .orderBy('correct_answered', descending: true)
          .where("quiz_code", isEqualTo: quizCode)
          .orderBy("time_taken", descending: false)
          .limit(10)
          .get();
      for (int i = 0; i < querySnapshot.docs.length; i++) {
        Map<String, dynamic> docData =
            querySnapshot.docs[i].data() as Map<String, dynamic>;
        topperList.add(ResultModel(
            sp!.getStringFromPref(SPKeys.studentId),
            docData["student_name"],
            docData["quiz_code"],
            docData["quiz_name"],
            docData["attempt_count"] ?? intDefault,
            docData["timeStamp"] ?? intDefault,
            docData["time_taken"] ?? intDefault,
            docData["correct_answered"] ?? intDefault,
            docData["un_answered"] ?? intDefault,
            docData["wrong_answered"] ?? intDefault,
            docData["actual_time"] ?? intDefault,
            docData['question_list'] == null
                ? []
                : List<QuestionModel>.from(
                    docData['question_list']
                        .map((question) => QuestionModel.fromMap(question)),
                  )));
      }
     // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        notifyListeners();
     // });
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  setQuestionIndex({required int index}) {
    selectedQuestionIndex = index;
    selectedAnswer = questionList[index].selectedAnswer;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      notifyListeners();
    });
    getAnswerIndex(index);
  }

  clearData(List<QuestionModel> resultQuestion) {
    selectedQuestionIndex = 0;
    questionList.clear();
    questionList.addAll(resultQuestion);
    answerIndex = -1;
    setQuestionIndex(index: 0);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      notifyListeners();
    });
  }

  getAnswerIndex(int index) {
    if (questionList[index].answer == questionList[index].option1) {
      answerIndex = 1;
    } else if (questionList[index].answer == questionList[index].option2) {
      answerIndex = 2;
    } else if (questionList[index].answer == questionList[index].option3) {
      answerIndex = 3;
    } else if (questionList[index].answer == questionList[index].option4) {
      answerIndex = 4;
    }

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      notifyListeners();
    });
  }
  // int getAnsweredCount() {
  //   int count = 0;
  //   for (int i = 0; i < questionList.length; i++) {
  //     if (questionList[i].selectedAnswer != intDefault) {
  //       count += 1;
  //     }
  //   }
  //   return count;
  // }

  // int getUnAnsweredCount() {
  //   int count = 0;
  //   for (int i = 0; i < questionList.length; i++) {
  //     if (questionList[i].selectedAnswer == intDefault) {
  //       count += 1;
  //     }
  //   }
  //   return count;
  // }
}
