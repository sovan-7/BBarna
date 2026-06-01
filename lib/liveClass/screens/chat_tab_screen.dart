import 'package:flutter/material.dart';
import 'live_class_screen.dart' show ChatMessage;

class ChatTabScreen extends StatefulWidget {
  final List<ChatMessage> messages;
  final TextEditingController controller;
  final VoidCallback onSend;

  const ChatTabScreen({
    super.key,
    required this.messages,
    required this.controller,
    required this.onSend,
  });

  @override
  State<ChatTabScreen> createState() => _ChatTabScreenState();
}

class _ChatTabScreenState extends State<ChatTabScreen> {
  final ScrollController _scrollController = ScrollController();

  static const Color _purple = Color(0xFF534AB7);
  static const Color _border = Color(0xFFE5E5EA);
  static const Color _bgGrey = Color(0xFFF5F6FA);

  @override
  void didUpdateWidget(ChatTabScreen old) {
    super.didUpdateWidget(old);
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

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            controller: _scrollController,
            padding: const EdgeInsets.all(12),
            itemCount: widget.messages.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (_, i) => _MessageBubble(msg: widget.messages[i]),
          ),
        ),
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
                        color: Colors.grey.withValues(alpha: 0.6), width: 0.5),
                  ),
                  child: TextField(
                    controller: widget.controller,
                    cursorColor: Color(0xFF09636E),
                    style: const TextStyle(fontSize: 13),
                    decoration: InputDecoration(
                      hintText: 'Type a message…',
                      hintStyle: TextStyle(
                          color: Colors.black.withValues(alpha: 0.6),
                          fontSize: 13),
                      border: InputBorder.none,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                    ),
                    onSubmitted: (_) => widget.onSend(),
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
                  child: const Icon(Icons.send_rounded,
                      color: Colors.white, size: 16),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final ChatMessage msg;

  const _MessageBubble({required this.msg});

  @override
  Widget build(BuildContext context) {
    if (msg.isMe) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.62),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF09636E).withValues(alpha: 0.05),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(14),
                    topRight: Radius.circular(3),
                    bottomLeft: Radius.circular(14),
                    bottomRight: Radius.circular(14),
                  ),
                  border: Border.all(
                      color: const Color(0xFF09636E).withValues(alpha: 0.3),
                      width: 0.5),
                ),
                child: Text(msg.text,
                    style: const TextStyle(
                        fontSize: 12, color: Color(0xFF1C1C1E))),
              ),
              const SizedBox(height: 3),
              Text(msg.time,
                  style: TextStyle(
                      fontSize: 9, color: Colors.black.withValues(alpha: 0.7))),
            ],
          ),
          const SizedBox(width: 6),
          Container(
            width: 28,
            height: 28,
            decoration:
                BoxDecoration(color: msg.avatarBg, shape: BoxShape.circle),
            child: Center(
              child: Text(msg.initials,
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: msg.avatarFg)),
            ),
          )
        ],
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 28,
          height: 28,
          decoration:
              BoxDecoration(color: msg.avatarBg, shape: BoxShape.circle),
          child: Center(
            child: Text(msg.initials,
                style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: msg.avatarFg)),
          ),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(msg.name,
                style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF534AB7))),
            const SizedBox(height: 3),
            Container(
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.62),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(3),
                  topRight: Radius.circular(14),
                  bottomLeft: Radius.circular(14),
                  bottomRight: Radius.circular(14),
                ),
                border: Border.all(color: const Color(0xFFE5E5EA), width: 0.5),
              ),
              child: Text(msg.text,
                  style:
                      const TextStyle(fontSize: 12, color: Color(0xFF1C1C1E))),
            ),
            const SizedBox(height: 3),
            Text(msg.time,
                style: TextStyle(
                    fontSize: 9, color: Colors.black.withValues(alpha: 0.7))),
          ],
        ),
      ],
    );
  }
}
