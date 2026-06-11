import 'package:b_barna_app/core/constants/value_constants.dart';
import 'package:b_barna_app/liveClass/models/chat_message.dart';
import 'package:b_barna_app/liveClass/models/live_class_model.dart';
import 'package:b_barna_app/liveClass/models/live_user.dart';
import 'package:b_barna_app/liveClass/providers/live_class_viewmodel.dart';
import 'package:b_barna_app/textSize/text_view_bold.dart';
import 'package:b_barna_app/utils/sp_keys.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'video_player_screen.dart';
import 'chat_tab_screen.dart';
import 'people_tab_screen.dart';

class ClassroomScreen extends StatefulWidget {
  final LiveClassModel item;
  const ClassroomScreen({required this.item, super.key});

  @override
  State<ClassroomScreen> createState() => _ClassroomScreenState();
}

class _ClassroomScreenState extends State<ClassroomScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _msgController = TextEditingController();
  bool _isPlaying = false;
  late YoutubePlayerController youtubePlayerController;
  static const Color _bgGrey = Color(0xFFF5F6FA);
  List<String> tabTitleList = ["Chat", "People"];

  List<IconData> iconList = [
    Icons.chat_bubble_outline_rounded,
    Icons.people_outline_rounded,
  ];
  final DatabaseReference _db = FirebaseDatabase.instance.ref();

  List<ChatMessage> _messages = [];
  List<LiveUser> _participants = [];
  List<LiveUser> _teacherList = []; // ✅ renamed & kept in state

  @override
  void initState() {
    super.initState();

    String videoId =
    getVideoId(widget.item.youtubeVideoLink)!;
    youtubePlayerController = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
        controlsVisibleAtStart: true,
        hideThumbnail: true,
        enableCaption: false,
      ),
    );
    _tabController = TabController(length: 2, vsync: this);
    _listenToMessages();
    _listenToParticipants();
    updateParticipantStatus();
    Provider.of<LiveClassViewModel>(context, listen: false)
        .storeLiveClassId(widget.item.startTime.toString());
  }

  @override
  void dispose() {
    updateParticipantStatus(isOnline: false);
    _tabController.dispose();
    _msgController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<LiveUser> allUsers = [..._participants, ..._teacherList];
    return Scaffold(
      backgroundColor: _bgGrey,
      appBar: AppBar(
        backgroundColor: const Color(0xFF09636E),
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: const Icon(
            Icons.arrow_back_ios_new,
            size: 25,
            color: Colors.white,
          ),
        ),
        title: TextViewBold(
          textContent: widget.item.subject.toUpperCase(),
          textSizeNumber: 17,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: VideoPlayerScreen(
          controller: youtubePlayerController,
          onPlayPause: () => setState(() => _isPlaying = !_isPlaying),
          childData: Column(
            children: [
              TabBar(
                controller: _tabController,
                labelColor: const Color(0xFF09636E),
                unselectedLabelColor: Colors.black.withValues(alpha: 0.6),
                labelStyle: const TextStyle(
                    fontSize: 13, fontWeight: FontWeight.w600),
                unselectedLabelStyle: const TextStyle(
                    fontSize: 13, fontWeight: FontWeight.w400),
                indicatorColor: const Color(0xFF09636E),
                indicatorWeight: 2,
                indicatorSize: TabBarIndicatorSize.label,
                tabs: List.generate(
                  iconList.length,
                      (index) => Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(iconList[index], size: 15),
                        const SizedBox(width: 5),
                        Text(tabTitleList[index]),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    ChatTabScreen(
                      messages: _messages,
                      controller: _msgController,
                      onSend: _sendMessage,
                      liveUsersList: allUsers, // ✅ always fresh combined list
                    ),
                    PeopleTabScreen(
                      liveUser: _participants,
                      teacher: _teacherList, // ✅ reassigned state variable
                      teacherId: widget.item.teacherId,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _listenToMessages() {
    _db
        .child('live_rooms/${widget.item.startTime}/messages')
        .onValue
        .listen((event) {
      final data = event.snapshot.value;
      if (!mounted) return;

      if (data == null) {
        setState(() => _messages = []);
        return;
      }

      final Map<dynamic, dynamic> map = data as Map<dynamic, dynamic>;
      final List<ChatMessage> loaded = map.entries
          .map((e) => ChatMessage.fromMap(
        Map<String, dynamic>.from(e.value as Map),e.key.toString()
      ))
          .toList()
        ..sort((a, b) => a.timestamp.compareTo(b.timestamp));

      if (!mounted) return;
      setState(() => _messages = loaded);
    });
  }

  void _listenToParticipants() {
    _db
        .child('live_rooms/${widget.item.startTime}/participants')
        .onValue
        .listen((event) {
      final data = event.snapshot.value;
      if (!mounted) return;

      if (data == null) {
        setState(() {
          _participants = [];
          _teacherList = []; // ✅ reassign, not mutate
        });
        return;
      }

      final Map<dynamic, dynamic> map = data as Map<dynamic, dynamic>;
      final List<LiveUser> loaded = map.entries
          .map((e) => LiveUser.fromMap(
        e.key as String,
        Map<String, dynamic>.from(e.value as Map),
      ))
          .toList();

      if (!mounted) return;

      // ✅ Work on a mutable copy, then reassign state cleanly
      final mutableList = List<LiveUser>.from(loaded);
      final teacherIndex = mutableList
          .indexWhere((user) => user.uid == widget.item.teacherId);

      List<LiveUser> newTeacherList = [];
      if (teacherIndex != -1) {
        final teacher = mutableList.removeAt(teacherIndex);
        newTeacherList = [teacher]; // ✅ new list, not mutated
      }

      setState(() {
        _participants = mutableList;
        _teacherList = newTeacherList; // ✅ reassignment triggers rebuild
      });
    });
  }

  Future<void> updateParticipantStatus({bool isOnline = true}) async {
    String userId = sp?.getStringFromPref(SPKeys.studentId) ?? stringDefault;
    String name = sp?.getStringFromPref(SPKeys.name) ?? stringDefault;
    final participantRef = FirebaseDatabase.instance
        .ref('live_rooms/${widget.item.startTime}/participants/$userId');

    try {
      final snapshot = await participantRef.get();

      if (snapshot.exists) {
        await participantRef.update({'isOnline': isOnline});
      } else {
        await participantRef.set({
          'userId': userId,
          'name': name,
          'isOnline': isOnline,
          "isWarned":false,
          "isBlock":false
        });
      }
    } catch (e) {
      debugPrint('Error updating participant: $e');
      rethrow;
    }
  }

  void _sendMessage() async {
    final text = _msgController.text.trim();
    if (text.isEmpty) return;

    final ChatMessage chatMessage = ChatMessage(
      senderId: sp?.getStringFromPref(SPKeys.studentId) ?? stringDefault,
      senderName: sp?.getStringFromPref(SPKeys.name) ?? stringDefault,
      text: _msgController.text,
      timestamp: DateTime.now().millisecondsSinceEpoch,
      msgId:DateTime.now().millisecondsSinceEpoch.toString()
    );

    await _db
        .child('live_rooms/${widget.item.startTime}/messages')
        .push()
        .set(chatMessage.toMap());

    _msgController.clear();
  }
  String? getVideoId(String? url) {
    if (url == null || url.isEmpty) return null;

    // ✅ Handle live URL: https://www.youtube.com/live/VIDEO_ID
    final liveRegex = RegExp(r'youtube\.com/live/([a-zA-Z0-9_-]{11})');
    final liveMatch = liveRegex.firstMatch(url);
    if (liveMatch != null) return liveMatch.group(1);

    // ✅ Handle all other formats (watch, youtu.be, shorts, embed)
    return YoutubePlayer.convertUrlToId(url);
  }
}