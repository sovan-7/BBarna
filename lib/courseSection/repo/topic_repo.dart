import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:b_barna_app/core/constants/value_constants.dart';
import 'package:b_barna_app/courseSection/model/topic_model.dart';

class TopicRepo {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  final Reference storageReference = FirebaseStorage.instance.ref();

  Future<List<TopicModel>> getTopicList(String unitCode) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await _fireStore
        .collection(topic)
        .where("unit_code", isEqualTo: unitCode)
        .get();
    return snapshot.docs
        .map((docSnapshot) => TopicModel.fromDocumentSnapshot(docSnapshot))
        .toList();
  }
}
