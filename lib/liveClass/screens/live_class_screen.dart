import 'package:b_barna_app/liveClass/models/live_class_model.dart';
import 'package:b_barna_app/textSize/text_view_bold.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'video_player_screen.dart';
import 'chat_tab_screen.dart';
import 'people_tab_screen.dart';

class ChatMessage {
  final String initials;
  final String name;
  final String text;
  final String time;
  final Color avatarBg;
  final Color avatarFg;
  final bool isMe;

  const ChatMessage({
    required this.initials,
    required this.name,
    required this.text,
    required this.time,
    required this.avatarBg,
    required this.avatarFg,
    this.isMe = false,
  });
}

final List<ChatMessage> sampleMessages = [
  const ChatMessage(
    initials: 'TS',
    name: 'Tanvi S.',
    text: 'Can you replay the interference part?',
    time: '14:10',
    avatarBg: Color(0xFFE1F5EE),
    avatarFg: Color(0xFF085041),
  ),
  const ChatMessage(
    initials: 'AK',
    name: 'Arjun K.',
    text: 'Is the formula A₁ + A₂ for constructive?',
    time: '14:15',
    avatarBg: Color(0xFFFBEAF0),
    avatarFg: Color(0xFF712B13),
  ),
  const ChatMessage(
    initials: 'RN',
    name: 'Rhea N.',
    text: 'Yes! Out of phase means subtraction.',
    time: '14:16',
    avatarBg: Color(0xFFFAEEDA),
    avatarFg: Color(0xFF633806),
  ),
  const ChatMessage(
    initials: 'YO',
    name: 'You',
    text: 'Thanks, that makes sense now!',
    time: '14:18',
    avatarBg: Color(0xFFEEEDFE),
    avatarFg: Color(0xFF3C3489),
    isMe: true,
  ),
  const ChatMessage(
    initials: 'PM',
    name: 'Priya M.',
    text: 'Will this be on the test?',
    time: '14:20',
    avatarBg: Color(0xFFE6F1FB),
    avatarFg: Color(0xFF0C447C),
  ),
];

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
  final List<ChatMessage> _messages = List.from(sampleMessages);
  bool _isPlaying = false;
  late YoutubePlayerController youtubePlayerController;
  static const Color _bgGrey = Color(0xFFF5F6FA);
  List<String> tabTitleList = ["Chat", "People"];

  List<IconData> iconList = [
    Icons.chat_bubble_outline_rounded,
    Icons.people_outline_rounded,
  ];
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
  }

  @override
  void dispose() {
    _tabController.dispose();
    _msgController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _msgController.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add(ChatMessage(
        initials: 'YO',
        name: 'You',
        text: text,
        time: TimeOfDay.now().format(context),
        avatarBg: const Color(0xFFEEEDFE),
        avatarFg: const Color(0xFF3C3489),
        isMe: true,
      ));
    });
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
                    const PeopleTabScreen(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
