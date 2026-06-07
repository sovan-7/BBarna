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

  /// Shows a bottom sheet with a Delete option on long-press.
  void _showMessageOptions(BuildContext context, ChatMessage msg) {
    final vm = context.read<LiveClassViewModel>();

    // Only allow deleting own messages (adjust field name to match your model)
    if (!vm.isMyMessage(msg)) return;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
            Container(
              margin: const EdgeInsets.only(top: 8, bottom: 4),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline, color: Colors.red),
              title: const Text(
                'Delete Message',
                style: TextStyle(color: Colors.red),
              ),
              onTap: () {
                Navigator.pop(context);
                _confirmDelete(context, msg);
              },
            ),
            ListTile(
              leading: const Icon(Icons.close),
              title: const Text('Cancel'),
              onTap: () => Navigator.pop(context),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  /// Shows a confirmation dialog before deleting.
  void _confirmDelete(BuildContext context, ChatMessage msg) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Message'),
        content: const Text('Are you sure you want to delete this message?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<LiveClassViewModel>().deleteMessage(msg);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isBlocked =
    context.watch<LiveClassViewModel>().isBlockedMe(widget.liveUsersList);
    final isWarned =
    context.watch<LiveClassViewModel>().isWarnedMe(widget.liveUsersList);

    return Container(
      decoration: isBlocked || isWarned
          ? BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            isBlocked
                ? 'assets/images/png/block_bg.png'
                : 'assets/images/png/warn_bg.png',
          ),
          fit: BoxFit.fill,
          opacity: 0.35,
        ),
      )
          : null,
      child: Column(
        children: [
          Expanded(
            child: ListView.separated(
              controller: _scrollController,
              padding: const EdgeInsets.all(12),
              itemCount: widget.messages.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (_, i) => GestureDetector(
                onLongPress: () =>
                    _showMessageOptions(context, widget.messages[i]),
                child: MessageBubble(
                  msg: widget.messages[i],
                  avatarColors: colors,
                ),
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