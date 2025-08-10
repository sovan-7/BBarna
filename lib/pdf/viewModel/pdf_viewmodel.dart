import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:b_barna_app/core/constants/value_constants.dart';
import 'package:b_barna_app/pdf/model/pdf_model.dart';

class PdfViewModel extends ChangeNotifier {
  List<PdfModel> pdfList = [];
  clearPdfList() {
    pdfList.clear();
  }

  fetchPdfList(List<String> pdfCodeList) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection(pdf)
          .where("pdf_code", whereIn: pdfCodeList)
          .get();
      for (int i = 0; i < querySnapshot.docs.length; i++) {
        DocumentSnapshot<Map<String, dynamic>> docData =
            querySnapshot.docs[i] as DocumentSnapshot<Map<String, dynamic>>;
        pdfList.add(PdfModel.fromDocumentSnapshot(docData));
      }
      notifyListeners();
    } catch (e) {
      log(e.toString());
    }
  }
}
