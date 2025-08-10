import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:b_barna_app/core/constants/value_constants.dart';

class PdfModel {
  String docId = stringDefault;
  String code = stringDefault;
  int timeStamp = intDefault;
  String title = stringDefault;
  String description = stringDefault;
  String pdfLink = stringDefault;
  String pdfType = stringDefault;
  bool isDownloadable = boolDefault;
  bool isLocked = boolDefault;

  PdfModel(
    this.code,
    this.description,
    this.title,
    this.pdfLink,
    this.isDownloadable,
    this.pdfType,
    this.timeStamp,
    this.isLocked,
  );

  PdfModel.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : docId = doc.id,
        code = doc.data()!["pdf_code"] ?? stringDefault,
        description = doc.data()!["pdf_description"] ?? stringDefault,
        title = doc.data()!["pdf_title"] ?? stringDefault,
        pdfLink = doc.data()!["pdf_link"] ?? stringDefault,
        pdfType = doc.data()!["pdf_type"] ?? stringDefault,
        isDownloadable = doc.data()!["is_downloadable"] ?? boolDefault,
        timeStamp = doc.data()!["timeStamp"] ?? intDefault,
        isLocked = doc.data()!["is_locked"] ?? boolDefault;
}
