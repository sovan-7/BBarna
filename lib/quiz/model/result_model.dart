import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:b_barna_app/core/constants/value_constants.dart';
import 'package:b_barna_app/quiz/model/question_model.dart';
import 'package:b_barna_app/utils/sp_keys.dart';

class ResultModel {
  String docId = stringDefault;
  String studentName = stringDefault;
  String studentId = stringDefault;
  String quizCode = stringDefault;
  String quizName = stringDefault;
  int attemptCount = intDefault;
  int timeStamp = intDefault;
  int timeTaken = intDefault;
  int correctAnswered = intDefault;
  int wrongAnswered = intDefault;
  int unAnswered = intDefault;
  int actualTime = intDefault;
  List<QuestionModel> questionList = [];

  ResultModel(
    this.studentId,
    this.studentName,
    this.quizCode,
    this.quizName,
    this.attemptCount,
    this.timeStamp,
    this.timeTaken,
    this.correctAnswered,
    this.unAnswered,
    this.wrongAnswered,
    this.actualTime,
    this.questionList,
  );

  // Convert ResultModel to a Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      "student_id": sp?.getStringFromPref(SPKeys.studentId),
      "student_name": sp?.getStringFromPref(SPKeys.name),
      "quiz_code": quizCode,
      "quiz_name": quizName,
      "attempt_count": attemptCount,
      "time_stamp": timeStamp,
      "time_taken": timeTaken,
      "correct_answered": correctAnswered,
      "un_answered": unAnswered,
      "wrong_answered": wrongAnswered,
      "actual_time": actualTime,
      "question_list":
          questionList.map((question) => question.toMap()).toList(),
    };
  }

  // Construct ResultModel from Firestore DocumentSnapshot
  ResultModel.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : docId = doc.id,
        studentId = doc.data()?['student_id'] ?? stringDefault,
        studentName = doc.data()?['student_name'] ?? stringDefault,
        quizCode = doc['quiz_code'] ?? stringDefault,
        quizName = doc['quiz_name'] ?? stringDefault,
        attemptCount = doc['attempt_count'] ?? intDefault,
        timeStamp = doc['time_stamp'] ?? intDefault,
        timeTaken = doc['time_taken'] ?? intDefault,
        correctAnswered = doc['correct_answered'] ?? intDefault,
        unAnswered = doc['un_answered'] ?? intDefault,
        wrongAnswered = doc['wrong_answered'] ?? intDefault,
        questionList = doc['question_list'] == null
            ? []
            : List<QuestionModel>.from(
                doc['question_list']
                    .map((question) => QuestionModel.fromMap(question)),
              );
}
