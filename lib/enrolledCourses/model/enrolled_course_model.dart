import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:b_barna_app/core/constants/value_constants.dart';

class EnrolledCourseBaseModel {
  String studentId = stringDefault;
  List<EnrolledCourseModel> enrolledCourseList = [];

  EnrolledCourseBaseModel.fromDocumentSnapshot(
      DocumentSnapshot<Map<String, dynamic>> doc)
      : studentId = doc.data()?["student_id"] ?? stringDefault,
        enrolledCourseList = doc.data()?["course_list"] == null
            ? []
            : List<EnrolledCourseModel>.from(
                (doc.data()?["course_list"] as List<dynamic>).map((x) =>
                    EnrolledCourseModel.fromMap(x as Map<String, dynamic>)));
}

class EnrolledCourseModel {
  String subjectCode = stringDefault;
  String subjectName = stringDefault;
  String subjectImage = stringDefault;
  int accessTill = intDefault;
  String accessType = stringDefault;
  List<String> unitCodeList = [];

  EnrolledCourseModel(
    this.subjectCode,
    this.subjectName,
    this.subjectImage,
    this.accessTill,
    this.accessType,
    this.unitCodeList,
  );

  EnrolledCourseModel.fromMap(Map<String, dynamic> map)
      : subjectCode = map["subject_code"] ?? stringDefault,
        subjectName = map["subject_name"] ?? stringDefault,
        subjectImage = map["subject_image"] ?? stringDefault,
        accessTill = map["access_till"] ?? intDefault,
        accessType = map["access_type"] ?? stringDefault,
        unitCodeList = map["unit_code_list"] == null
            ? []
            : List<String>.from(map["unit_code_list"] as List<dynamic>);
}
