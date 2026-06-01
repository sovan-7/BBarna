import 'package:b_barna_app/core/constants/value_constants.dart';
import 'package:b_barna_app/liveClass/models/chat_message.dart';
import 'package:b_barna_app/utils/helper.dart';
import 'package:b_barna_app/utils/sp_keys.dart';
import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final ChatMessage msg;
  AvatarColors avatarColors;
   MessageBubble({required this.msg,required this.avatarColors});

  @override
  Widget build(BuildContext context) {
    if (msg.senderId == sp?.getStringFromPref(SPKeys.studentId)) {
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
              Text(Helper.formatTimestamp(msg.timestamp),
                  style: TextStyle(
                      fontSize: 9, color: Colors.black.withValues(alpha: 0.7))),
            ],
          ),
          const SizedBox(width: 6),
          Container(
            width: 28,
            height: 28,
            decoration:
            BoxDecoration(color: avatarColors.bg, shape: BoxShape.circle),
            child: Center(
              child: Text(Helper.nameToInitials(msg.senderName),
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: avatarColors.fg)),
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
          BoxDecoration(color: avatarColors.bg, shape: BoxShape.circle),
          child: Center(
            child: Text(Helper.nameToInitials(msg.senderName),
                style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: avatarColors.fg)),
          ),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(msg.senderName,
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
            Text(Helper.formatTimestamp(msg.timestamp),
                style: TextStyle(
                    fontSize: 9, color: Colors.black.withValues(alpha: 0.7))),
          ],
        ),
      ],
    );
  }
}
