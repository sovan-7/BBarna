import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:b_barna_app/courseSection/model/subject_model.dart';
import 'package:b_barna_app/homeScreen/model/about_model.dart';
import 'package:b_barna_app/homeScreen/model/banners_model.dart';
import 'package:b_barna_app/homeScreen/model/teacher_model.dart';
import 'package:b_barna_app/homeScreen/repo/home_repo.dart';
import 'package:b_barna_app/utils/helper.dart';

class HomeViewModel with ChangeNotifier {
  HomeRepo homeRepo = HomeRepo();
  List<BannersModel> bannerList = [];
  List<SubjectModel> subjectList = [];
  List<TeacherModel> teacherList = [];
  late AboutModel aboutModel;
  Future<void> fetchBannerList() async {
    try {
      bannerList.clear();
      bannerList = await homeRepo.getBannerList();
      notifyListeners();
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> getSubjectList() async {
    try {
      subjectList.clear();
      subjectList = await homeRepo.getSubjectList();
      subjectList
          .sort((a, b) => a.displayPriority.compareTo(b.displayPriority));
      subjectList
          .sort((a, b) => a.displayPriority.compareTo(b.displayPriority));
      notifyListeners();
    } catch (e) {
      Helper.showSnackBarMessage(
          msg: "Error while fetching data", isSuccess: false);
    }
  }

  Future<void> fetchTeacherList() async {
    try {
      teacherList = await homeRepo.getTeacherList();
      teacherList
          .sort((a, b) => a.displayPriority.compareTo(b.displayPriority));
      notifyListeners();
    } catch (e) {
      log(e.toString());
    }
  }

  // getAboutData() async {
  //   try {
  //     aboutModel = await homeRepo.getTeacherList();

  //     notifyListeners();
  //   } catch (e) {
  //     log(e.toString());
  //   }
  // }
}
