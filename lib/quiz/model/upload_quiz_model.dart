import 'package:b_barna_app/core/constants/value_constants.dart';
import 'package:b_barna_app/utils/sp_keys.dart';

class UploadQuizModel {
  String quizCode = stringDefault;
  String quizName = stringDefault;
  int attemptCount = intDefault;
  int timeStamp = intDefault;
  int timeTaken = intDefault;
  List<Map<String, dynamic>> questionList = [];
  UploadQuizModel(this.quizCode, this.quizName, this.attemptCount,
      this.timeStamp, this.timeTaken, this.questionList);

  Map<String, dynamic> toMap() {
    return {
      "student_id": sp?.getStringFromPref(SPKeys.studentId),
      "quiz": [
        {
          "quiz_code": quizCode,
          "quiz_name": quizName,
          "attempt_count": attemptCount,
          "time_stamp": DateTime.now().millisecondsSinceEpoch,
          "time_taken": timeTaken,
          "question_list": questionList
        }
      ]
    };
  }
}
