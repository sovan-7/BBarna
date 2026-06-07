import 'package:b_barna_app/core/constants/value_constants.dart';
import 'package:b_barna_app/core/widgets/loader_dialog.dart';
import 'package:b_barna_app/liveClass/models/chat_message.dart';
import 'package:b_barna_app/liveClass/models/live_class_model.dart';
import 'package:b_barna_app/utils/sp_keys.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:b_barna_app/liveClass/models/live_user.dart';

class LiveClassViewModel extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<LiveClassModel> _allClasses = [];
  bool _isLoading = false;
  String? _error;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String liveClassId = stringDefault;

  List<LiveClassModel> get liveClasses => _allClasses.where((c) {
        final now = DateTime.now().millisecondsSinceEpoch;
        return c.startTime <= now && now <= c.endTime;
      }).toList();

  List<LiveClassModel> get upcomingClasses => _allClasses
      .where((c) => c.startTime > DateTime.now().millisecondsSinceEpoch)
      .toList()
    ..sort((a, b) => a.startTime.compareTo(b.startTime));

  List<LiveClassModel> get pastClasses => _allClasses
      .where((c) => c.endTime < DateTime.now().millisecondsSinceEpoch)
      .toList()
    ..sort((a, b) => b.startTime.compareTo(a.startTime));

  final db = FirebaseDatabase.instance.ref();
  List<LiveUser> users = [];
  String mentionQuery = "";

  void storeLiveClassId(String id) {
    liveClassId = id;
  }

  Future<void> fetchClasses() async {
    _isLoading = true;
    _error = null;
    notifyListeners(); // ✅ direct call, not addPersistentFrameCallback

    LoaderDialog.show(navigatorKey.currentContext!);
    try {
      final snapshot = await _firestore.collection('live_classes').get();
      _allClasses = snapshot.docs
          .map((doc) => LiveClassModel.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      _error = 'Failed to load classes. Please try again.';
    } finally {
      LoaderDialog.hide(navigatorKey.currentContext!);
      _isLoading = false;
      notifyListeners(); // ✅ direct call
    }
  }

  void listenParticipants(String roomId) {
    db.child("live_rooms/$roomId/participants").onValue.listen((event) {
      final data = event.snapshot.value;

      if (data == null) {
        users = [];
        notifyListeners(); // ✅ direct call
        return;
      }

      final map = Map<String, dynamic>.from(data as Map);
      users = map.entries.map((e) {
        return LiveUser.fromMap(
          e.key,
          Map<String, dynamic>.from(e.value),
        );
      }).toList();

      notifyListeners(); // ✅ direct call — triggers Consumer/Selector rebuilds
    });
  }

  void updateMentionQuery(String value) {
    mentionQuery = value;
    notifyListeners();
  }

  List<LiveUser> get filteredUsers {
    if (mentionQuery.isEmpty) return [];
    return users.where((u) {
      return u.name.toLowerCase().contains(mentionQuery.toLowerCase());
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

  String formatTimeSlot(LiveClassModel c) {
    final start = DateTime.fromMillisecondsSinceEpoch(c.startTime);
    final end = DateTime.fromMillisecondsSinceEpoch(c.endTime);
    return '${_fmt(start)} – ${_fmt(end)}';
  }

  String formatDateLabel(LiveClassModel c) {
    final start = DateTime.fromMillisecondsSinceEpoch(c.startTime);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final classDay = DateTime(start.year, start.month, start.day);
    final diff = classDay.difference(today).inDays;

    if (diff == 0) return 'Today';
    if (diff == 1) return 'Tomorrow';
    if (diff == -1) return 'Yesterday';
    return '${start.day} ${_month(start.month)}';
  }

  String _fmt(DateTime dt) {
    final h = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final m = dt.minute.toString().padLeft(2, '0');
    final period = dt.hour < 12 ? 'AM' : 'PM';
    return '$h:$m $period';
  }

  String _month(int m) => const [
        '',
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec'
      ][m];

  String getButtonStatus(LiveClassModel c, String classStatus) {
    if (classStatus == "upcoming") return formatDateLabel(c);
    if (classStatus == "live") return "Join Now";
    if (classStatus == "past") return "Watch Recording";
    return "";
  }

  Future<void> updateParticipantStatus(
      String studentId, ParticipantAction action) async {
    final participantRef = FirebaseDatabase.instance
        .ref('live_rooms/$liveClassId/participants/$studentId');
    try {
      final snapshot = await participantRef.get();
      if (snapshot.exists) {
        switch (action) {
          case ParticipantAction.isBlock:
            await participantRef.update({'isBlock': true});
            break;
          case ParticipantAction.isWarned:
            await participantRef.update({'isWarned': true});
            break;
          case ParticipantAction.isDelete:
            deleteAllMessagesOfUser(studentId);

            break;
        }
      }
    } catch (e) {
      debugPrint('Error updating participant: $e');
    }
  }

  bool isBlockedMe(List<LiveUser> liveUserList) {
    return liveUserList.any((user) =>
        user.uid == sp?.getStringFromPref(SPKeys.studentId) && user.isBlock);
  }

  bool isWarnedMe(List<LiveUser> liveUserList) {
    return liveUserList.any((user) =>
        user.uid == sp?.getStringFromPref(SPKeys.studentId) && user.isWarned);
  }

  bool isMyMessage(ChatMessage msg) {
    return msg.senderId == sp?.getStringFromPref(SPKeys.studentId);
  }

  void deleteMessage(ChatMessage msg) async {
    try {
      final messagesRef =
          FirebaseDatabase.instance.ref('live_rooms/$liveClassId/messages');

      await messagesRef.child(msg.msgId).remove();
    } catch (e) {
      debugPrint('Error deleting message: $e');
    }
  }

  void deleteAllMessagesOfUser(String senderId) async {
    try {
      final messagesRef =
          FirebaseDatabase.instance.ref('live_rooms/$liveClassId/messages');

      final snapshot = await messagesRef.get();

      if (snapshot.exists) {
        final data = Map<String, dynamic>.from(snapshot.value as Map);
        final Map<String, Null> updates = {};
        data.forEach((key, value) {
          final msgData = Map<String, dynamic>.from(value);
          if (msgData['senderId'] == senderId) {
            updates[key] = null;
          }
        });

        // Delete all matched messages in one batch call
        if (updates.isNotEmpty) {
          await messagesRef.update(updates);
        }
      }

      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting messages: $e');
    }
  }
}
