import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:b_barna_app/core/constants/value_constants.dart';
import 'package:b_barna_app/courseSection/model/subject_model.dart';

class SubjectRepo {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  final Reference storageReference = FirebaseStorage.instance.ref();

  Future<List<SubjectModel>> getSubjectList(String courseCode) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await _fireStore
        .collection(subject)
        .where("willDisplay", isEqualTo: true)
        .where("course_code", isEqualTo: courseCode)
        .get();

    return snapshot.docs
        .map((docSnapshot) => SubjectModel.fromDocumentSnapshot(docSnapshot))
        .toList();
  }
}
