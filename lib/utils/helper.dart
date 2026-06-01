import 'dart:math';

import 'package:flutter/material.dart';
import 'package:b_barna_app/core/constants/value_constants.dart';

class Helper {
  static Future<void> showSnackBarMessage(
      {required String msg, required bool isSuccess}) async {
    ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(SnackBar(
      duration: const Duration(milliseconds: 750),
      content: Row(
        children: [
          isSuccess
              ? const Icon(
                  Icons.check_circle,
                  size: 20,
                  color: Colors.white,
                )
              : const Icon(
                  Icons.cancel_outlined,
                  size: 20,
                  color: Colors.white,
                ),
          const SizedBox(
            width: 8,
          ),
          Expanded(
            child: Text(
              msg,
              textAlign: TextAlign.left,
              maxLines: 2,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.italic),
            ),
          ),
        ],
      ),
      backgroundColor: isSuccess ? Colors.green[800] : Colors.amber[800],
    ));
  }
  static String formatTimestamp(int timestamp) {
    final dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final hour = dateTime.hour;
    final minute = dateTime.minute;
    final period = hour >= 12 ? 'PM' : 'AM';
    final hour12 = hour % 12 == 0 ? 12 : hour % 12;
    final minuteStr = minute.toString().padLeft(2, '0');
    return '$hour12:$minuteStr$period';
  }
  static String nameToInitials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));

    if (parts.length == 1) {
      // Single word: take first and last letter → "Sovan" → "SN"
      final word = parts[0];
      return (word[0] + word[word.length - 1]).toUpperCase();
    } else {
      // Multiple words: take first letter of first and last word → "Sovan Lal Maity" → "SM"
      return (parts.first[0] + parts.last[0]).toUpperCase();
    }
  }
  AvatarColors getRandomAvatarColors() {
    final random = Random();
    final index = random.nextInt(avatarBgColors.length);
    return (bg: avatarBgColors[index], fg: avatarFgColors[index]);
  }
}
