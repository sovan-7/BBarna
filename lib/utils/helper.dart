import 'package:flutter/material.dart';
import 'package:b_barna_app/core/constants/value_constants.dart';

class Helper {
  static showSnackBarMessage(
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
}
