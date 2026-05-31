// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// import '../providers/live_class_viewmodel.dart';
//
// class MentionTextField extends StatefulWidget {
//   final String roomId;
//   final Function(String) onSend;
//
//   const MentionTextField({
//     super.key,
//     required this.roomId,
//     required this.onSend,
//   });
//
//   @override
//   State<MentionTextField> createState() =>
//       _MentionTextFieldState();
// }
//
// class _MentionTextFieldState
//     extends State<MentionTextField> {
//   final TextEditingController controller =
//   TextEditingController();
//
//   @override
//   void initState() {
//     super.initState();
//
//     Future.microtask(() {
//       context
//           .read<ChatProvider>()
//           .listenParticipants(widget.roomId);
//     });
//   }
//
//   void onChanged(String value) {
//     final match =
//     RegExp(r'@(\w*)$').firstMatch(value);
//
//     if (match != null) {
//       final query = match.group(1) ?? '';
//
//       context
//           .read<ChatProvider>()
//           .updateMentionQuery(query);
//     } else {
//       context
//           .read<ChatProvider>()
//           .updateMentionQuery('');
//     }
//   }
//
//   void selectUser(String name) {
//     final text = controller.text;
//
//     final newText = text.replaceAll(
//       RegExp(r'@(\w*)$'),
//       '@$name ',
//     );
//
//     controller.text = newText;
//
//     controller.selection =
//         TextSelection.fromPosition(
//           TextPosition(
//             offset: controller.text.length,
//           ),
//         );
//
//     context
//         .read<ChatProvider>()
//         .updateMentionQuery('');
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<ChatProvider>(
//       builder: (_, provider, __) {
//         return Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             /// 🔥 USER LIST
//             if (provider.filteredUsers.isNotEmpty)
//               Container(
//                 margin:
//                 const EdgeInsets.only(bottom: 8),
//                 constraints:
//                 const BoxConstraints(
//                   maxHeight: 200,
//                 ),
//                 decoration: BoxDecoration(
//                   color: Colors.grey.shade900,
//                   borderRadius:
//                   BorderRadius.circular(16),
//                 ),
//                 child: ListView.builder(
//                   shrinkWrap: true,
//                   itemCount:
//                   provider.filteredUsers.length,
//                   itemBuilder: (_, index) {
//                     final user =
//                     provider.filteredUsers[index];
//
//                     return ListTile(
//                       onTap: () =>
//                           selectUser(user.name),
//
//                       leading: CircleAvatar(
//                         child: Text(
//                           user.name[0]
//                               .toUpperCase(),
//                         ),
//                       ),
//
//                       title: Text(
//                         user.name,
//                         style: const TextStyle(
//                           color: Colors.white,
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//
//             /// 🔥 TEXT FIELD
//             Container(
//               padding:
//               const EdgeInsets.symmetric(
//                 horizontal: 14,
//               ),
//               decoration: BoxDecoration(
//                 color: Colors.grey.shade900,
//                 borderRadius:
//                 BorderRadius.circular(30),
//               ),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: TextField(
//                       controller: controller,
//                       onChanged: onChanged,
//                       style: const TextStyle(
//                         color: Colors.white,
//                       ),
//                       decoration:
//                       const InputDecoration(
//                         border: InputBorder.none,
//                         hintText:
//                         "Type message...",
//                         hintStyle: TextStyle(
//                           color: Colors.grey,
//                         ),
//                       ),
//                     ),
//                   ),
//
//                   IconButton(
//                     onPressed: () {
//                       final text =
//                       controller.text.trim();
//
//                       if (text.isEmpty) return;
//
//                       widget.onSend(text);
//
//                       controller.clear();
//
//                       context
//                           .read<ChatProvider>()
//                           .updateMentionQuery('');
//                     },
//                     icon: const Icon(
//                       Icons.send,
//                       color: Colors.blue,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }