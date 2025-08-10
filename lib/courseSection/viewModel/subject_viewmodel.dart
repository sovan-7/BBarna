import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:b_barna_app/courseSection/model/subject_model.dart';
import 'package:b_barna_app/courseSection/repo/subject_repo.dart';

class SubjectViewModel extends ChangeNotifier {
  final SubjectRepo _subjectRepo = SubjectRepo();
  bool canAccessSubject = false;
  Map<String, List<SubjectModel>> subjectMapList = {};
  List<String> courseTypeList = ["Full Course", "Part Course", "Mock Test"];
  List<String> fetchTypeList = [];

  getSubjectList(String courseCode) async {
    try {
      List<SubjectModel> subjectList = [];
      subjectMapList.clear();
      fetchTypeList.clear();
      subjectList = await _subjectRepo.getSubjectList(courseCode);
      subjectList
          .sort((a, b) => a.displayPriority.compareTo(b.displayPriority));
      for (int i = 0; i < courseTypeList.length; i++) {
        List<SubjectModel> filterSubjectList = subjectList
            .where((element) =>
                element.courseType.toLowerCase() ==
                courseTypeList[i].toLowerCase())
            .toList();
        if (subjectMapList[courseTypeList[i].toLowerCase()] == null &&
            filterSubjectList.isNotEmpty) {
          fetchTypeList.add(courseTypeList[i].toLowerCase());
          subjectMapList[courseTypeList[i].toLowerCase()] = [];
          subjectMapList[courseTypeList[i].toLowerCase()]!
              .addAll(filterSubjectList);
        }
      }
      // for (int i = 0; i < fetchTypeList.length; i++) {
      //   print(fetchTypeList[i]);
      //   print(((subjectMapList[fetchTypeList[i]]!.length)/2).roundToDouble());
      // }
      notifyListeners();
    } catch (e) {
      // Helper.showSnackBarMessage(
      //     msg: "Error while fetching data", isSuccess: false);
    }
  }

  setAccessLevelOfUser(String subjectCode) {
    canAccessSubject = true;
  }
}
