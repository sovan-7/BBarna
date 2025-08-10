import 'package:b_barna_app/core/constants/value_constants.dart';

class QuestionModel {
  QuestionModel({
    this.docId = "",
    this.questionCode = "",
    this.question = "",
    this.questionBody = "",
    this.hints = "",
    this.solution = "",
    this.answer = "",
    this.option1 = "",
    this.option2 = "",
    this.option3 = "",
    this.option4 = "",
    this.timeStamp = -1,
    this.selectedAnswer = -1,
  });
  String docId = stringDefault;
  String questionCode = stringDefault;
  String question = stringDefault;
  String questionBody = stringDefault;
  String hints = stringDefault;
  String solution = stringDefault;
  String answer = stringDefault;
  String option1 = stringDefault;
  String option2 = stringDefault;
  String option3 = stringDefault;
  String option4 = stringDefault;
  int timeStamp = intDefault;
  int selectedAnswer = intDefault;
  Map<String, dynamic> toMap() {
    return {
      "question_code": questionCode.trim(),
      "question": question,
      "question_body": questionBody,
      "hints": hints,
      "solution": solution,
      "answer": answer,
      "option1": option1,
      "option2": option2,
      "option3": option3,
      "option4": option4,
      "selected_answer": selectedAnswer
    };
  }

  QuestionModel.fromMap(Map<String, dynamic> doc)
      : questionCode = doc['question_code'] ?? stringDefault,
        question = doc['question'] ?? stringDefault,
        questionBody = doc['question_body'] ?? stringDefault,
        hints = doc['hints'] ?? stringDefault,
        solution = doc['solution'] ?? stringDefault,
        answer = doc['answer'] ?? stringDefault,
        option1 = doc['option1'] ?? stringDefault,
        option2 = doc['option2'] ?? stringDefault,
        option3 = doc['option3'] ?? stringDefault,
        option4 = doc['option4'] ?? stringDefault,
        timeStamp = doc['timeStamp'] ?? intDefault,
        selectedAnswer = doc['selected_answer'] ?? intDefault;
}
