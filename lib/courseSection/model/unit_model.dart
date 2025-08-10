import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:b_barna_app/core/constants/value_constants.dart';

class UnitModel {
  String id = stringDefault;
  String code = stringDefault;
  String courseCode = stringDefault;
  String courseName = stringDefault;
  String subjectCode = stringDefault;
  String subjectName = stringDefault;
  bool lockStatus = boolDefault;
  int timeStamp = intDefault;
  String description = stringDefault;
  String name = stringDefault;
  String image = stringDefault;
  int displayPriority = intDefault;
  bool willShow = boolDefault;

  UnitModel(
      this.courseCode,
      this.courseName,
      this.subjectCode,
      this.subjectName,
      this.lockStatus,
      this.code,
      this.description,
      this.name,
      this.image,
      this.displayPriority,
      this.timeStamp,
      this.willShow);

  UnitModel.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : id = doc.id,
        courseCode = doc.data()!["course_code"] ?? stringDefault,
        courseName = doc.data()!["course_name"] ?? stringDefault,
        subjectCode = doc.data()!["subject_code"] ?? stringDefault,
        subjectName = doc.data()!["subject_name"] ?? stringDefault,
        code = doc.data()!["unit_code"] ?? stringDefault,
        description = doc.data()!["unit_description"] ?? stringDefault,
        name = doc.data()!["unit_name"] ?? stringDefault,
        image = doc.data()!["unit_image"] ?? stringDefault,
        lockStatus = doc.data()!["lock_status"] ?? stringDefault,
        displayPriority = doc.data()!["display_priority"] ?? intDefault,
        timeStamp = doc.data()!["timeStamp"] ?? intDefault,
        willShow = doc.data()!["willShow"] ?? boolDefault;
}
