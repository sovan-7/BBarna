import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:b_barna_app/core/constants/value_constants.dart';

class BannersModel {
  String docId = stringDefault;
  String image = stringDefault;
  BannersModel.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : docId = doc.id,
        image = doc["banner_image"] ?? stringDefault;
}
