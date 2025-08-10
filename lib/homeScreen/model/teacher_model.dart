import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:b_barna_app/core/constants/value_constants.dart';

class TeacherModel {
  String name = stringDefault;
  String image = stringDefault;
  int displayPriority = intDefault;
  TeacherModel.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : name = doc["name"] ?? stringDefault,
        image = doc["image"] ?? stringDefault,
        displayPriority = doc["displayPriority"] ?? intDefault;
}
