import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:b_barna_app/core/constants/value_constants.dart';

class SubjectModel {
  String docId = stringDefault;
  String code = stringDefault;
  String courseCode = stringDefault;
  String courseName = stringDefault;
  String courseType = stringDefault;
  int timeStamp = intDefault;
  String description = stringDefault;
  String name = stringDefault;
  String image = stringDefault;
  double price = doubleDefault;
  double sellingPrice = doubleDefault;

  int displayPriority = intDefault;
  bool willDisplay = boolDefault;
  bool isLocked = boolDefault;

  SubjectModel(
      this.courseCode,
      this.courseType,
      this.courseName,
      this.price,
      this.code,
      this.description,
      this.name,
      this.image,
      this.displayPriority,
      this.timeStamp,
      this.willDisplay,
      this.isLocked);

  SubjectModel.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : docId = doc.id,
        courseCode = doc.data()!["course_code"] ?? stringDefault,
        courseType = doc.data()!["course_type"] ?? stringDefault,
        courseName = doc.data()!["course_name"] ?? stringDefault,
        code = doc.data()!["subject_code"] ?? stringDefault,
        description = doc.data()!["subject_description"] ?? stringDefault,
        name = doc.data()!["subject_name"] ?? stringDefault,
        image = doc.data()!["subject_image"] ?? stringDefault,
        price = doc.data()!["subject_price"] == null
            ? doubleDefault
            : doc.data()!["subject_price"].toDouble(),
        sellingPrice = doc.data()!["selling_price"] == null
            ? doubleDefault
            : doc.data()!["selling_price"].toDouble(),
        displayPriority = doc.data()!["display_priority"] ?? intDefault,
        willDisplay = doc.data()!["willDisplay"] ?? boolDefault,
        isLocked = doc.data()!["isLocked"] ?? boolDefault,
        timeStamp = doc.data()!["created_at"] ?? intDefault;
}
