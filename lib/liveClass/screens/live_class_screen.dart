import 'package:b_barna_app/core/constants/value_constants.dart';
import 'package:b_barna_app/liveClass/models/chat_message.dart';
import 'package:b_barna_app/liveClass/models/live_class_model.dart';
import 'package:b_barna_app/liveClass/models/live_user.dart';
import 'package:b_barna_app/textSize/text_view_bold.dart';
import 'package:b_barna_app/utils/sp_keys.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
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
  List<LiveUser> teacherList = [];

  @override
  void initState() {
    super.initState();
    String videoId =
        YoutubePlayer.convertUrlToId(widget.item.youtubeVideoLink)!;
    youtubePlayerController = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
        // forceHD: true,
        // loop: true,
        controlsVisibleAtStart: true,
        hideThumbnail: true,
        enableCaption: false,
      ),
    );
    _tabController = TabController(length: 2, vsync: this);
    _listenToMessages();
    _listenToParticipants();
    updateParticipantStatus();
  }

  @override
  void dispose() {
    updateParticipantStatus(isOnline: false);
    _tabController.dispose();
    _msgController.dispose();
    super.dispose();
  }

  void _sendMessage() async {
    final text = _msgController.text.trim();
    if (text.isEmpty) return;
    ChatMessage chatMessage = ChatMessage(
        senderId: sp?.getStringFromPref(SPKeys.studentId) ?? stringDefault,
        senderName: sp?.getStringFromPref(SPKeys.name) ?? stringDefault,
        text: _msgController.text,
        timestamp: DateTime.now().millisecondsSinceEpoch);
    // setState(() {
    //   _messages.add(ChatMessage(
    //       senderId: sp?.getStringFromPref(SPKeys.studentId) ?? stringDefault,
    //       senderName: sp?.getStringFromPref(SPKeys.name) ?? stringDefault,
    //       text: _msgController.text,
    //       timestamp: DateTime.now().millisecondsSinceEpoch));
    // });
    await _db
        .child('live_rooms/${widget.item.startTime}/messages')
        .push()
        .set(chatMessage.toMap());
    _msgController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgGrey,
      appBar: AppBar(
        backgroundColor: Color(0xFF09636E),
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back_ios_new,
            size: 25,
            color: Colors.white,
          ),
        ),
        title: TextViewBold(
            textContent: "NET Bengali".toUpperCase(), textSizeNumber: 17),
        centerTitle: true,
        // actions: [
        //   Container(
        //     padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        //     decoration: BoxDecoration(
        //       color: const Color(0xFFFCEBEB),
        //       borderRadius: BorderRadius.circular(5),
        //     ),
        //     child: Row(
        //       mainAxisSize: MainAxisSize.min,
        //       children: const [
        //         Icon(Icons.circle, size: 7, color: Color(0xFFA32D2D)),
        //         SizedBox(width: 4),
        //         Text('LIVE',
        //             style: TextStyle(
        //                 fontSize: 10,
        //                 fontWeight: FontWeight.w600,
        //                 color: Color(0xFFA32D2D))),
        //       ],
        //     ),
        //   ),
        // ],
      ),
      body: SafeArea(
        child: VideoPlayerScreen(
          controller: youtubePlayerController,
          onPlayPause: () => setState(() => _isPlaying = !_isPlaying),
          childData: Column(
            children: [
              TabBar(
                controller: _tabController,
                labelColor: Color(0xFF09636E),
                unselectedLabelColor: Colors.black.withValues(alpha: 0.6),
                labelStyle:
                    const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                unselectedLabelStyle:
                    const TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
                indicatorColor: Color(0xFF09636E),
                indicatorWeight: 2,
                indicatorSize: TabBarIndicatorSize.label,
                tabs: List.generate(
                  iconList.length,
                  (index) => Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(iconList[index], size: 15),
                        SizedBox(width: 5),
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
                    ),
                    PeopleTabScreen(
                      liveUser: _participants,
                      teacher: teacherList,
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
                Map<String, dynamic>.from(e.value as Map),
              ))
          .toList();

      // Sort by timestamp ascending
      loaded.sort((a, b) => a.timestamp.compareTo(b.timestamp));
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
        setState(() => _participants = []);
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

      setState(() {
        _participants = loaded;

        int index = _participants
            .indexWhere((user) => user.uid == widget.item.teacherId);
        if (index != -1) {
          LiveUser user = _participants[index];
          _participants.removeAt(index);
          teacherList.clear();
          teacherList.add(user);
        }
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
        });
      }

      debugPrint('Participant status updated successfully');
    } catch (e) {
      debugPrint('Error updating participant: $e');
      rethrow;
    }
  }
}
