import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:b_barna_app/core/constants/value_constants.dart';
import 'package:b_barna_app/video/model/video_model.dart';

class VideoViewModel extends ChangeNotifier {
  List<VideoModel> videoList = [];
  List<VideoModel> freeVideoList = [];

  void clearVideoList() {
    videoList.clear();
    freeVideoList.clear();
  }

  Future fetchVideoList(List<String> videoCodeList) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection(video)
          .where("video_code", whereIn: videoCodeList)
          .get();
      for (int i = 0; i < querySnapshot.docs.length; i++) {
        DocumentSnapshot<Map<String, dynamic>> docData =
            querySnapshot.docs[i] as DocumentSnapshot<Map<String, dynamic>>;
        videoList.add(VideoModel.fromDocumentSnapshot(docData));
      }
      notifyListeners();
    } catch (e) {
      log(e.toString());
    }
  }

  Future fetchFreeVideoList() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection(video)
          .where("video_type", isEqualTo: "FREE")
          .get();
      for (int i = 0; i < querySnapshot.docs.length; i++) {
        DocumentSnapshot<Map<String, dynamic>> docData =
            querySnapshot.docs[i] as DocumentSnapshot<Map<String, dynamic>>;
        freeVideoList.add(VideoModel.fromDocumentSnapshot(docData));
      }
      notifyListeners();
    } catch (e) {
      log(e.toString());
    }
  }
}
