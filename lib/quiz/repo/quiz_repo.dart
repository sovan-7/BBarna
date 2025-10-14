import 'dart:developer';

import 'package:b_barna_app/quiz/model/quiz_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:b_barna_app/core/constants/value_constants.dart';
import 'package:b_barna_app/quiz/model/result_model.dart';
import 'package:b_barna_app/utils/helper.dart';
import 'package:b_barna_app/utils/sp_keys.dart';

class QuizRepo {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  final Reference storageReference = FirebaseStorage.instance.ref();

  Future submitQuiz({required ResultModel uploadData}) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await _fireStore
          .collection(results)
          .where("student_id",
              isEqualTo: sp!.getStringFromPref(SPKeys.studentId))
          .get();
      ResultModel? resultModel;
      if (querySnapshot.docs.isNotEmpty) {
        for (int i = 0; i < querySnapshot.docs.length; i++) {
          if (querySnapshot.docs[i].data()["quiz_code"] ==
              uploadData.quizCode) {
            DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
                querySnapshot.docs[i];
            resultModel = ResultModel.fromDocumentSnapshot(documentSnapshot);
            break;
          }
        }
        if (resultModel?.quizCode == uploadData.quizCode) {
          resultModel = uploadData;
          await _fireStore
              .collection(results)
              .doc(querySnapshot.docs.first.id)
              .update(resultModel.toMap())
              .then((value) {
            Helper.showSnackBarMessage(
                msg: "Quiz updated successfully", isSuccess: true);
          });
        } else {
          await _fireStore
              .collection(results)
              .add(uploadData.toMap())
              .then((value) {
            Helper.showSnackBarMessage(
                msg: "Quiz submitted successfully", isSuccess: true);
          });
        }
      } else {
        await _fireStore
            .collection(results)
            .add(uploadData.toMap())
            .then((value) {
          Helper.showSnackBarMessage(
              msg: "Quiz submitted successfully", isSuccess: true);
        });
        return null;
      }
    } catch (e) {
      log(e.toString());
      Helper.showSnackBarMessage(
          msg: "Sorry something went wrong", isSuccess: false);
      return null;
    }
  }

  Future fetchFreeQuizList() async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await _fireStore
          .collection(quiz)
          .where("quiz_type", isEqualTo: "FREE")
          .get();
      return snapshot.docs
          .map((docSnapshot) => QuizModel.fromMap(docSnapshot.data()))
          .toList();
    } catch (e) {
      log(e.toString());
      return null;
    }
  }
}
