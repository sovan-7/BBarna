import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:b_barna_app/core/constants/value_constants.dart';
import 'package:b_barna_app/courseSection/model/subject_model.dart';
import 'package:b_barna_app/homeScreen/model/banners_model.dart';
import 'package:b_barna_app/homeScreen/model/teacher_model.dart';

class HomeRepo {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  final Reference storageReference = FirebaseStorage.instance.ref();

  Future<List<BannersModel>> getBannerList() async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await _fireStore.collection(banners).get();
    return snapshot.docs
        .map((docSnapshot) => BannersModel.fromDocumentSnapshot(docSnapshot))
        .toList();
  }

  Future<List<SubjectModel>> getSubjectList() async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await _fireStore
        .collection(subject)
        .where("willDisplay", isEqualTo: true)
        .where("isPopular", isEqualTo: true)
        .get();
    return snapshot.docs
        .map((docSnapshot) => SubjectModel.fromDocumentSnapshot(docSnapshot))
        .toList();
  }

  Future<List<TeacherModel>> getTeacherList() async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await _fireStore.collection(teachers).get();
    return snapshot.docs
        .map((docSnapshot) => TeacherModel.fromDocumentSnapshot(docSnapshot))
        .toList();
  }
}
