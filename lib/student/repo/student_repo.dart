import 'dart:developer';
import 'dart:io';

import 'package:b_barna_app/core/route/route_name.dart';
import 'package:b_barna_app/utils/helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:b_barna_app/core/constants/value_constants.dart';
import 'package:b_barna_app/student/model/student_model.dart';
import 'package:b_barna_app/utils/sp_keys.dart';
import 'package:flutter/material.dart';

class StudentRepo {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Reference storageReference = FirebaseStorage.instance.ref();

  Future<Student> getCurrentStudentData() async {
    DocumentSnapshot<Map<String, dynamic>> documentSnapshot = await _firestore
        .collection(student)
        .doc(sp?.getStringFromPref(SPKeys.studentId))
        .get();
    return Student.fromDocumentSnapshot(documentSnapshot);
  }

  Future<bool> isStudentExist() async {
    bool result = false;

    await _firestore
        .collection(student)
        .where('mobile_number',
            isEqualTo: sp?.getStringFromPref(SPKeys.phoneNumber))
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        result = true;
        sp?.setStringToPref(SPKeys.studentId, value.docs.first.id);
      } else {
        result = false;
      }
    });
    return result;
  }

  Future addStudent(Student studentData) async {
    await _firestore.collection(student).add(studentData.toMap()).then((value) {
      sp?.setStringToPref(SPKeys.studentId, value.id);
    });
  }

  Future updateStudent(Student studentData) async {
    await _firestore
        .collection(student)
        .doc(sp?.getStringFromPref(SPKeys.studentId))
        .update(studentData.toMap());
  }

  Future uploadStudentImage(File image) async {
    Reference referenceDirImages = storageReference.child("images");
    Reference referenceImageToUpload = referenceDirImages
        .child("img${sp?.getStringFromPref(SPKeys.phoneNumber)}");
    try {
      await referenceImageToUpload.putFile(File(image.path));
      final imageUrl = await referenceImageToUpload.getDownloadURL();
      await _firestore
          .collection(student)
          .doc(sp?.getStringFromPref(SPKeys.studentId))
          .update({"student_image": imageUrl});
    } catch (e) {
      log(e.toString());
    }
  }

  Future deleteStudent() async {
    try {
      await _firestore
          .collection(student)
          .doc(sp?.getStringFromPref(SPKeys.studentId))
          .delete()
          .then((val) {
        Navigator.popAndPushNamed(
            navigatorKey.currentContext!, RouteName.loginScreenRoute);
        Helper.showSnackBarMessage(
            msg: "Account deleted successfully", isSuccess: false);
      });
    } catch (e) {
      Helper.showSnackBarMessage(
          msg: "Sorry something went wrong", isSuccess: false);
    }
  }
}
