import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:b_barna_app/audio/model/audio_model.dart';
import 'package:b_barna_app/core/constants/value_constants.dart';

class AudioViewModel extends ChangeNotifier {
  List<AudioModel> audioList = [];
  void clearAudioList() {
    audioList.clear();
  }

  Future fetchAudioList(List<String> audioCodeList) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection(audio)
          .where("audio_code", whereIn: audioCodeList)
          .get();
      for (int i = 0; i < querySnapshot.docs.length; i++) {
        DocumentSnapshot<Map<String, dynamic>> docData =
            querySnapshot.docs[i] as DocumentSnapshot<Map<String, dynamic>>;
        audioList.add(AudioModel.fromDocumentSnapshot(docData));
      }
      audioList.add(audioList[0]);
      audioList.add(audioList[0]);
      notifyListeners();
    } catch (e) {
      log(e.toString());
    }
  }
}
