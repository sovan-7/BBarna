import 'package:b_barna_app/core/constants/value_constants.dart';

class QuizModel {
  String docId = stringDefault;
  String code = stringDefault;
  int timeStamp = intDefault;
  String name = stringDefault;
  String status = stringDefault;
  String type = stringDefault;
  int totalTime = intDefault;
  int totalMarks = intDefault;
  int numberDeduction = intDefault;
  int totalWrongAnswer = intDefault;
  int totalQuestion = intDefault;
  List<String>? questionCodeList = [];

  QuizModel(
      this.docId,
      this.code,
      this.name,
      this.status,
      this.type,
      this.totalTime,
      this.timeStamp,
      this.totalMarks,
      this.numberDeduction,
      this.totalWrongAnswer,
      this.totalQuestion,
      this.questionCodeList);
  Map<String, dynamic> toMap() {
    return {
      "quiz_code": code.trim(),
      "quiz_name": name,
      "timeStamp": timeStamp,
      "quiz_status": status,
      "quiz_type": type,
      "total_time": totalTime,
      "total_marks": totalMarks,
      "number_deduction": numberDeduction,
      "total_wrong_answer": totalWrongAnswer,
      "total_question": totalQuestion,
      "question_code_list": questionCodeList
    };
  }

  QuizModel.fromMap(Map<String, dynamic> doc)
      : docId = doc["doc_id"],
        code = doc["quiz_code"] ?? stringDefault,
        name = doc["quiz_name"] ?? stringDefault,
        type = doc["quiz_type"] ?? stringDefault,
        status = doc["quiz_status"] ?? stringDefault,
        totalTime = doc["total_time"] ?? stringDefault,
        totalMarks = doc["total_marks"] ?? stringDefault,
        numberDeduction = doc["number_deduction"] ?? stringDefault,
        timeStamp = doc["timeStamp"] ?? intDefault,
        totalWrongAnswer = doc["total_wrong_answer"] ?? intDefault,
        totalQuestion = doc["total_question"] ?? intDefault,
        questionCodeList = doc["question_code_list"] == null
            ? []
            : List<String>.from(doc["question_code_list"].map((x) => x));
}
