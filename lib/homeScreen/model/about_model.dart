import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:b_barna_app/core/constants/value_constants.dart';

class AboutModel {
  String facebookLink = stringDefault;
  String instagramLink = stringDefault;
  String playStoreLink = stringDefault;
  AboutModel.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : playStoreLink = doc["playStore_link"] ?? stringDefault,
        instagramLink = doc["instagram_link"] ?? stringDefault,
        facebookLink = doc["facebook_link"] ?? intDefault;
}
