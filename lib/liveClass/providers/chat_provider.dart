import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

import '../models/live_user.dart';

class ChatProvider extends ChangeNotifier {
  final db = FirebaseDatabase.instance.ref();

  List<LiveUser> users = [];
  String mentionQuery = "";

  void listenParticipants(String roomId) {
    db.child("live_rooms/$roomId/participants").onValue.listen((event) {
      final data = event.snapshot.value;

      if (data == null) return;

      final map = Map<String, dynamic>.from(data as Map);

      users = map.entries.map((e) {
        return LiveUser.fromMap(
          e.key,
          Map<String, dynamic>.from(e.value),
        );
      }).toList();

      notifyListeners();
    });
  }

  void updateMentionQuery(String value) {
    mentionQuery = value;
    notifyListeners();
  }

  List<LiveUser> get filteredUsers {
    if (mentionQuery.isEmpty) return [];

    return users.where((u) {
      return u.name.toLowerCase().contains(
        mentionQuery.toLowerCase(),
      );
    }).toList();
  }

  Future<void> sendMessage({
    required String roomId,
    required String senderId,
    required String senderName,
    required String text,
  }) async {
    if (text.trim().isEmpty) return;

    final msgRef = db.child("live_rooms/$roomId/messages").push();

    await msgRef.set({
      "senderId": senderId,
      "senderName": senderName,
      "text": text,
      "timestamp": DateTime.now().millisecondsSinceEpoch,
    });
  }
}