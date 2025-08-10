import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:b_barna_app/core/constants/value_constants.dart';
import 'package:b_barna_app/core/route/route_name.dart';
import 'package:b_barna_app/quiz/model/question_model.dart';
import 'package:b_barna_app/quiz/model/quiz_model.dart';
import 'package:b_barna_app/quiz/model/result_model.dart';
import 'package:b_barna_app/quiz/repo/quiz_repo.dart';
import 'package:b_barna_app/utils/sp_keys.dart';

class QuizViewModel extends ChangeNotifier {
  List<QuizModel> quizList = [];
  List<String> selectedQuestionCodeList = [];
  List<QuestionModel> quizQuestionList = [];
  int selectedQuestionIndex = 0;
  QuizRepo quizRepo = QuizRepo();
  int remainingTimeCount = 0;
  int copyTimeCount = 0;
  int correctAnswerCount = 0;
  int wrongAnswerCount = 0;
  int unAnswerCount = 0;
  Timer? timer;
  String quizCode = stringDefault;
  String quizName = stringDefault;
  bool isSubmitted = false;
  clearQuizList() {
    quizList.clear();
  }

  fetchQuizList(List<String> quizCodeList) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection(quiz)
          .where("quiz_code", whereIn: quizCodeList)
          .get();
      for (int i = 0; i < querySnapshot.docs.length; i++) {
        Map<String, dynamic> docData =
            querySnapshot.docs[i].data() as Map<String, dynamic>;
        DocumentSnapshot<Map<String, dynamic>> docData1 =
            querySnapshot.docs[i] as DocumentSnapshot<Map<String, dynamic>>;
        quizList.add(QuizModel(
            docData1.id,
            docData["quiz_code"],
            docData["quiz_name"],
            docData["quiz_type"],
            docData["quiz_status"],
            docData["total_time"],
            docData["total_marks"],
            docData["number_deduction"],
            docData["timeStamp"],
            docData["total_wrong_answer"],
            docData["total_question"],
            List<String>.from(docData["question_code_list"] ?? [])));
      }
      notifyListeners();
    } catch (e) {
      log(e.toString());
    }
  }

  storeQuizDetails(String code, String name) {
    quizCode = code;
    quizName = name;
  }

  fetchQuizQuestionList(List<String> questionCodeList) async {
    selectedQuestionIndex = 0;
    try {
      quizQuestionList.clear();
      selectedQuestionCodeList.clear();
      for (int j = 0; j < questionCodeList.length; j += 25) {
        List<String> dummyQuestionCodeList = questionCodeList.sublist(
          j,
          j + 25 >= questionCodeList.length ? questionCodeList.length : j + 25,
        );
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection(question)
            .where("question_code", whereIn: dummyQuestionCodeList)
            .get();
        for (int i = 0; i < querySnapshot.docs.length; i++) {
          DocumentSnapshot<Map<String, dynamic>> docData =
              querySnapshot.docs[i] as DocumentSnapshot<Map<String, dynamic>>;
          Map<String, dynamic> docData1 =
              querySnapshot.docs[i].data() as Map<String, dynamic>;
          quizQuestionList.add(QuestionModel(
            docId: docData.id,
            questionCode: docData1["question_code"],
            question: docData1["question"],
            questionBody: docData1["question_body"],
            hints: docData1["hints"],
            solution: docData1["solution"],
            answer: docData1["answer"],
            option1: docData1["option1"],
            option2: docData1["option2"],
            option3: docData1["option3"],
            option4: docData1["option4"],
            timeStamp: docData1["time_stamp"] ?? intDefault,
            selectedAnswer: docData1["selected_answer"] ?? intDefault,
          ));
        }
        Future.delayed(const Duration(milliseconds: 100));
      }
      quizQuestionList.shuffle();
      WidgetsBinding.instance.addPostFrameCallback(
        (timeStamp) {
          notifyListeners();
        },
      );
    } catch (e) {
      log(e.toString());
    }
  }

  setAnswerByUser(int optionIndex) {
    quizQuestionList[selectedQuestionIndex].selectedAnswer = optionIndex;
    notifyListeners();
  }

  setQuestionIndex({required int index}) {
    selectedQuestionIndex = index;
    notifyListeners();
  }

  Future submitQuiz() async {
    try {
      ResultModel examQuizModel = ResultModel(
        sp!.getStringFromPref(SPKeys.studentId),
        sp!.getStringFromPref(SPKeys.name),
        quizCode,
        quizName,
        1,
        DateTime.now().millisecondsSinceEpoch,
        getTime(),
        correctAnswerCount,
        unAnswerCount,
        wrongAnswerCount,
        copyTimeCount,
        quizQuestionList,
      );
      timer?.cancel();
      quizRepo.submitQuiz(uploadData: examQuizModel).whenComplete(() {
        Navigator.pushReplacementNamed(
            navigatorKey.currentContext!, RouteName.scoreBoardScreenRoute,
            arguments: {"quizCode": quizCode});
      });
    } catch (e) {
      isSubmitted = false;
      notifyListeners();
    }
  }

  getAnswerCount() {
    isSubmitted = true;
    notifyListeners();
    for (int i = 0; i < quizQuestionList.length; i++) {
      int answerIndex = 0;
      if (quizQuestionList[i].answer == quizQuestionList[i].option1) {
        answerIndex = 1;
      } else if (quizQuestionList[i].answer == quizQuestionList[i].option2) {
        answerIndex = 2;
      } else if (quizQuestionList[i].answer == quizQuestionList[i].option3) {
        answerIndex = 3;
      } else {
        answerIndex = 4;
      }
      if (quizQuestionList[i].selectedAnswer == -1) {
        unAnswerCount += 1;
      } else if (quizQuestionList[i].selectedAnswer == answerIndex) {
        correctAnswerCount += 1;
      } else {
        wrongAnswerCount += 1;
      }
    }
    Navigator.pop(navigatorKey.currentContext!);
    submitQuiz();
  }

  int getTime() {
    if (remainingTimeCount == 0) {
      return remainingTimeCount;
    } else {
      return (copyTimeCount - remainingTimeCount);
    }
  }

  int getAnsweredCount() {
    int count = 0;
    for (int i = 0; i < quizQuestionList.length; i++) {
      if (quizQuestionList[i].selectedAnswer != intDefault) {
        count += 1;
      }
    }
    return count;
  }

  int getUnAnsweredCount() {
    int count = 0;
    for (int i = 0; i < quizQuestionList.length; i++) {
      if (quizQuestionList[i].selectedAnswer == intDefault) {
        count += 1;
      }
    }
    return count;
  }

  clearQuizQuestion() {
    quizQuestionList.clear();
    timer?.cancel();
    timer = null;
    isSubmitted = false;
    quizQuestionList.clear();
    correctAnswerCount = 0;
    wrongAnswerCount = 0;
    unAnswerCount = 0;
  }

  setQuizTime(int count) {
    remainingTimeCount = count * 60;
    copyTimeCount = remainingTimeCount;
  }

  startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (remainingTimeCount > 0) {
        remainingTimeCount -= 1;
        notifyListeners();
      } else {
        timer.cancel();
        getAnswerCount();
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    timer = null;
    super.dispose();
  }

  String convertToHour() {
    String remainingTime = "";
    int remaining = 0;
    int minute = 0;
    int second = 0;
    if (remainingTimeCount ~/ 3600 >= 1) {
      int hr = remainingTimeCount ~/ 3600;
      remaining = remainingTimeCount - (hr * 3600);
      if (remaining > 60) {
        minute = remaining ~/ 60;
        second = remaining - (minute * 60);
      } else {
        second = remaining;
      }
      if (minute != 0) {
        remainingTime = "$hr Hour $minute Minute $second Second";
      } else {
        remainingTime = "$hr Hour  $second Second";
      }
    } else if (remainingTimeCount ~/ 60 >= 1) {
      minute = remainingTimeCount ~/ 60;
      second = remainingTimeCount - (minute * 60);
      remainingTime = "$minute Minute $second Second";
    } else {
      remainingTime = "$remaining Second";
    }
    return remainingTime;
  }
}
