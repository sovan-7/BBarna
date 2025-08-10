import 'package:flutter/foundation.dart';
import 'package:b_barna_app/courseSection/model/course_model.dart';
import 'package:b_barna_app/courseSection/repo/course_repo.dart';

class CourseViewModel extends ChangeNotifier {
  final CourseRepo _courseRepo = CourseRepo();
  List<CourseModel> courseList = [];
  getCourseList() async {
    try {
      courseList.clear();
      courseList = await _courseRepo.getCourseList();
      courseList.sort((a, b) => a.displayPriority.compareTo(b.displayPriority));
      notifyListeners();
    } catch (e) {
      // Helper.showSnackBarMessage(
      //     msg: "Error while fetching data", isSuccess: false);
    }
  }
}
