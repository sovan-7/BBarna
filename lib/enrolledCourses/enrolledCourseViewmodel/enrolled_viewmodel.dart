import 'package:flutter/foundation.dart';
import 'package:b_barna_app/enrolledCourses/model/enrolled_course_model.dart';
import 'package:b_barna_app/enrolledCourses/repo/enrolled_course_repo.dart';
import 'package:b_barna_app/utils/helper.dart';

class EnrolledCourseViewModel extends ChangeNotifier {
  final EnrolledCourseRepo _courseRepo = EnrolledCourseRepo();
  EnrolledCourseBaseModel? enrolledCourseBaseModel;
  clearData() {
    enrolledCourseBaseModel = null;
  }

  getEnrolledCourseList() async {
    try {
      enrolledCourseBaseModel = await _courseRepo.getCourseList();
      notifyListeners();
    } catch (e) {
      //   Helper.showSnackBarMessage(
      //       msg: "Error while fetching data", isSuccess: false);
    }
  }

  Future enrolledCourse(newCourse) async {
    try {
      _courseRepo.addCourse(newCourse).then((value) {
        getEnrolledCourseList();
      });
    } catch (e) {
      Helper.showSnackBarMessage(
          msg: "Error while fetching data", isSuccess: false);
    }
  }
}
