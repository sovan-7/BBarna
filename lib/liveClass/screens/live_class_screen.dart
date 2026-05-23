import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import 'package:b_barna_app/liveClass/models/live_class_model.dart';
import 'package:b_barna_app/liveClass/providers/chat_provider.dart';
import 'package:b_barna_app/liveClass/widgets/mention_text_field.dart';

class LiveClassScreen extends StatefulWidget {
  final LiveClassModel liveClass;

  const LiveClassScreen({
    super.key,
    required this.liveClass,
  });

  @override
  State<LiveClassScreen> createState() =>
      _LiveClassScreenState();
}

class _LiveClassScreenState
    extends State<LiveClassScreen> {
  late YoutubePlayerController controller;

  final currentUserId = "u1";
  final currentUserName = "Sovan";

  late String roomId;

  @override
  void initState() {
    super.initState();

    /// 🔥 use firebase live class id as room id
    roomId = widget.liveClass.youtubeVideoId;

    controller = YoutubePlayerController(
      initialVideoId:
      widget.liveClass.youtubeVideoId,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        isLive: true,
      ),
    );

    /// 🔥 listen participants
    Future.microtask(() {
      context
          .read<ChatProvider>()
          .listenParticipants(roomId);
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void openChatSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black,
      isScrollControlled: true,
      builder: (_) {
        return SizedBox(
          height:
          MediaQuery.of(context).size.height * 0.85,
          child: Column(
            children: [
              const SizedBox(height: 12),

              Container(
                width: 60,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius:
                  BorderRadius.circular(20),
                ),
              ),

              const SizedBox(height: 16),

              const Text(
                "Live Chat",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 16),
//$roomId
              /// 🔥 CHAT MESSAGES
              Expanded(
                child: StreamBuilder(
                  stream: FirebaseDatabase.instance
                      .ref(
                    "live_rooms/room_1/messages",
                  )
                      .onValue,
                  builder: (_, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child:
                        CircularProgressIndicator(),
                      );
                    }

                    final data = snapshot
                        .data!.snapshot.value;

                    if (data == null) {
                      return const Center(
                        child: Text(
                          "No messages",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      );
                    }

                    final map =
                    Map<String, dynamic>.from(
                      data as Map,
                    );

                    final messages = map.values
                        .toList()
                        .reversed
                        .toList();

                    return ListView.builder(
                      reverse: true,
                      itemCount: messages.length,
                      itemBuilder: (_, index) {
                        final msg =
                        Map<String, dynamic>.from(
                          messages[index],
                        );

                        final isMe =
                            msg['senderId'] ==
                                currentUserId;

                        return Align(
                          alignment: isMe
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Container(
                            margin:
                            const EdgeInsets.all(8),
                            padding:
                            const EdgeInsets.all(
                              12,
                            ),
                            constraints:
                            const BoxConstraints(
                              maxWidth: 280,
                            ),
                            decoration: BoxDecoration(
                              color: isMe
                                  ? Colors.blue
                                  : Colors.grey
                                  .shade900,
                              borderRadius:
                              BorderRadius.circular(
                                16,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,
                              children: [
                                Text(
                                  msg['senderName'],
                                  style:
                                  const TextStyle(
                                    fontWeight:
                                    FontWeight
                                        .bold,
                                    color:
                                    Colors.white,
                                  ),
                                ),

                                const SizedBox(
                                    height: 4),

                                Text(
                                  msg['text'],
                                  style:
                                  const TextStyle(
                                    color:
                                    Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),

              /// 🔥 MENTION TEXT FIELD
              Padding(
                padding: EdgeInsets.only(
                  left: 12,
                  right: 12,
                  top: 12,
                  bottom:
                  MediaQuery.of(context)
                      .viewInsets
                      .bottom +
                      12,
                ),
                child: MentionTextField(
                  roomId: roomId,
                  onSend: (text) {
                    context
                        .read<ChatProvider>()
                        .sendMessage(
                      roomId: roomId,
                      senderId:
                      currentUserId,
                      senderName:
                      currentUserName,
                      text: text,
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildTopInfo() {
    return Container(
      padding: const EdgeInsets.all(12),
      color: Colors.black87,
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.red,
            child: Text(
              widget.liveClass.teacherName[0],
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  widget.liveClass.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  widget.liveClass.teacherName,
                  style: const TextStyle(
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),

          Container(
            padding:
            const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 5,
            ),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius:
              BorderRadius.circular(30),
            ),
            child: const Text(
              "LIVE",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          "YouTube Live Class",
        ),
        actions: [
          IconButton(
            onPressed: openChatSheet,
            icon: const Icon(Icons.chat),
          ),
        ],
      ),

      body: Column(
        children: [
          /// 🔥 VIDEO
          YoutubePlayer(
            controller: controller,
            showVideoProgressIndicator: true,
          ),

          /// 🔥 CLASS INFO
          buildTopInfo(),

          const Spacer(),
        ],
      ),

      floatingActionButton:
      FloatingActionButton.extended(
        backgroundColor: Colors.red,
        onPressed: openChatSheet,
        icon: const Icon(Icons.chat_bubble),
        label: const Text("Live Chat"),
      ),
    );
  }
}