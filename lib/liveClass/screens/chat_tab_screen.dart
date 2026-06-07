import 'package:b_barna_app/core/constants/value_constants.dart';
import 'package:b_barna_app/liveClass/models/chat_message.dart';
import 'package:b_barna_app/liveClass/models/live_user.dart';
import 'package:b_barna_app/liveClass/providers/live_class_viewmodel.dart';
import 'package:b_barna_app/liveClass/widgets/mention_widget.dart';
import 'package:b_barna_app/liveClass/widgets/message_buble.dart';
import 'package:b_barna_app/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatTabScreen extends StatefulWidget {
  final List<ChatMessage> messages;
  final TextEditingController controller;
  final VoidCallback onSend;
  final List<LiveUser> liveUsersList;

  const ChatTabScreen({
    super.key,
    required this.messages,
    required this.controller,
    required this.onSend,
    required this.liveUsersList,
  });

  @override
  State<ChatTabScreen> createState() => _ChatTabScreenState();
}

class _ChatTabScreenState extends State<ChatTabScreen> {
  final ScrollController _scrollController = ScrollController();

  static const Color _border = Color(0xFFE5E5EA);
  static const Color _bgGrey = Color(0xFFF5F6FA);
  AvatarColors colors = Helper().getRandomAvatarColors();

  @override
  void didUpdateWidget(ChatTabScreen old) {
    super.didUpdateWidget(old);
    if (widget.messages.length != old.messages.length) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ✅ context.watch — rebuilds this widget whenever notifyListeners() is called
    final isBlocked = context
        .watch<LiveClassViewModel>()
        .isBlockedMe(widget.liveUsersList);
    final isWarned = context
        .watch<LiveClassViewModel>()
        .isWarnedMe(widget.liveUsersList);
    return Container(
        decoration: BoxDecoration(

        image: DecorationImage(
        image: AssetImage(
          isBlocked
              ? 'assets/images/png/block_bg.png'
              : isWarned
              ? 'assets/images/png/warn_bg.png'
              : '',
        ),
        fit: BoxFit.fill,
        opacity: 0.35, // subtle watermark effect
      ),
        ),
      child: Column(
        children: [
          Expanded(
            child: ListView.separated(
              controller: _scrollController,
              padding: const EdgeInsets.all(12),
              itemCount: widget.messages.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (_, i) => MessageBubble(
                msg: widget.messages[i],
                avatarColors: colors,
              ),
            ),
          ),
          if (!isBlocked)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: _border, width: 0.5)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: _bgGrey,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.grey.withValues(alpha: 0.6),
                          width: 0.5,
                        ),
                      ),
                      child: MentionInputWidget(
                        controller: widget.controller,
                        onSend: widget.onSend,
                        users: widget.liveUsersList,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: widget.onSend,
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: const BoxDecoration(
                        color: Color(0xFF09636E),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.send_rounded,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}