import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:b_barna_app/core/constants/value_constants.dart';
import 'package:b_barna_app/courseSection/model/unit_model.dart';

class UnitRepo {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  final Reference storageReference = FirebaseStorage.instance.ref();

  Future<List<UnitModel>> getUnitList(String subjectCode) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await _fireStore
        .collection(unit)
        .where("subject_code", isEqualTo: subjectCode)
        .where("willShow", isEqualTo: true)
        .get();
    return snapshot.docs
        .map((docSnapshot) => UnitModel.fromDocumentSnapshot(docSnapshot))
        .toList();
  }

  Future<List<UnitModel>> getUnitListById(List<String> subjectCode) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await _fireStore
        .collection(unit)
        .where("unit_code", whereIn: subjectCode)
        .where("willShow", isEqualTo: true)
        .get();
    return snapshot.docs
        .map((docSnapshot) => UnitModel.fromDocumentSnapshot(docSnapshot))
        .toList();
  }
}
