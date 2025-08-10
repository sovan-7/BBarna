import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:b_barna_app/core/constants/value_constants.dart';
import 'package:b_barna_app/utils/helper.dart';
import 'package:b_barna_app/utils/sp_keys.dart';

class ScoreRepo {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  final Reference storageReference = FirebaseStorage.instance.ref();

  Future fetchQuiz(
      {required String quizCode,
      required int attemptCount,
      required List<Map<String, dynamic>> questionList}) async {
    try {
      CollectionReference collectionReference = _fireStore.collection(student);
      QuerySnapshot querySnapshot = await collectionReference
          .where("mobile_number",
              isEqualTo: sp!.getStringFromPref(SPKeys.phoneNumber))
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        // UploadQuizModel uploadQuizModel =
        //     UploadQuizModel(quizCode, 0, questionList);
        await _fireStore.collection(student).get();
      } else {
        Helper.showSnackBarMessage(
            msg: "Sorry something went wrong", isSuccess: false);

        return null;
      }
    } catch (e) {
      log(e.toString());
      return null;
    }
  }
}
