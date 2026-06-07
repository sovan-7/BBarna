import 'package:b_barna_app/core/constants/value_constants.dart';
import 'package:b_barna_app/liveClass/models/live_user.dart';
import 'package:b_barna_app/liveClass/providers/live_class_viewmodel.dart';
import 'package:b_barna_app/utils/helper.dart';
import 'package:b_barna_app/utils/sp_keys.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum StudentStatus { teacher, online, handRaised }

class PeopleTabScreen extends StatefulWidget {
  List<LiveUser> liveUser;
  List<LiveUser> teacher;
  String teacherId;
  PeopleTabScreen(
      {required this.liveUser,
      required this.teacher,
      required this.teacherId,
      super.key});

  @override
  State<PeopleTabScreen> createState() => _PeopleTabScreenState();
}

class _PeopleTabScreenState extends State<PeopleTabScreen> {
  AvatarColors avatarColors = Helper().getRandomAvatarColors();
  int onlineCount = 0;

  @override
  void initState() {
    super.initState();
    onlineCount = widget.liveUser.where((user) => user.isOnline).length;
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 2),
          child: Text('Teacher'.toUpperCase(),
              style: const TextStyle(
                  fontSize: 10,
                  color: Color(0xFF8E8E93),
                  letterSpacing: 0.5,
                  fontWeight: FontWeight.w500)),
        ),
        const SizedBox(height: 6),
        PeopleCard(
          students: widget.teacher,
          avatarColors: avatarColors,
          role: "Teacher",
          isTeacher: false, // Teachers can't moderate other teachers
        ),
        const SizedBox(height: 14),
        Padding(
          padding: const EdgeInsets.only(left: 2),
          child: Text('Students — $onlineCount online'.toUpperCase(),
              style: const TextStyle(
                  fontSize: 10,
                  color: Color(0xFF8E8E93),
                  letterSpacing: 0.5,
                  fontWeight: FontWeight.w500)),
        ),
        const SizedBox(height: 6),
        PeopleCard(
          students: widget.liveUser,
          avatarColors: avatarColors,
          role: "Student",
          isTeacher: sp?.getStringFromPref(SPKeys.studentId) ==
              widget.teacherId, // Teacher can moderate students
        ),
      ],
    );
  }
}

class PeopleCard extends StatelessWidget {
  final List<LiveUser> students;
  final AvatarColors avatarColors;
  final String role;
  final bool isTeacher;

  const PeopleCard({
    super.key,
    required this.students,
    required this.avatarColors,
    required this.role,
    required this.isTeacher,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E5EA), width: 0.5),
      ),
      child: Column(
        children: [
          ...students.asMap().entries.map((e) {
            final isLast = e.key == students.length - 1;
            return StudentRow(
              liveUser: e.value,
              showDivider: !isLast,
              avatarColors: avatarColors,
              role: role,
              isTeacher: isTeacher,
            );
          }),
        ],
      ),
    );
  }
}

class StudentRow extends StatelessWidget {
  final LiveUser liveUser;
  final bool showDivider;
  final AvatarColors avatarColors;
  final String role;
  final bool isTeacher;

  const StudentRow({
    super.key,
    required this.liveUser,
    required this.showDivider,
    required this.avatarColors,
    required this.role,
    required this.isTeacher,
  });

  void _showActionMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _StudentActionSheet(liveUser: liveUser),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              // Avatar
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                    color: avatarColors.bg, shape: BoxShape.circle),
                child: Center(
                  child: Text(
                    Helper.nameToInitials(liveUser.name),
                    style: TextStyle(
                        fontSize: 8,
                        fontWeight: FontWeight.w600,
                        color: avatarColors.fg),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              // Name + role
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(liveUser.name,
                        style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF1C1C1E))),
                    Text(role,
                        style: const TextStyle(
                            fontSize: 10, color: Color(0xFF8E8E93))),
                  ],
                ),
              ),
              // Online/Offline badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: liveUser.isOnline
                      ? const Color(0xFFE1F5EE)
                      : const Color(0xFFFAEEDA),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  liveUser.isOnline ? "Online" : "Offline",
                  style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: liveUser.isOnline
                          ? const Color(0xFF085041)
                          : const Color(0xFF633806)),
                ),
              ),
              // Three-dot menu — only visible to teacher
              if (isTeacher) ...[
                const SizedBox(width: 6),
                GestureDetector(
                  onTap: () => _showActionMenu(context),
                  child: const Padding(
                    padding: EdgeInsets.all(4),
                    child: Icon(Icons.more_vert,
                        size: 18, color: Color(0xFF8E8E93)),
                  ),
                ),
              ],
            ],
          ),
        ),
        if (showDivider)
          const Divider(
              height: 0.5,
              thickness: 0.5,
              color: Color(0xFFF2F2F7),
              indent: 56),
      ],
    );
  }
}

// ── Bottom Sheet ──────────────────────────────────────────────────────────────

class _StudentActionSheet extends StatelessWidget {
  final LiveUser liveUser;
  const _StudentActionSheet({required this.liveUser});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 10, bottom: 4),
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFFD1D1D6),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // User name header
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
              liveUser.name,
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1C1C1E)),
            ),
          ),
          const Divider(height: 0.5, thickness: 0.5, color: Color(0xFFE5E5EA)),
          // Warn
          _ActionTile(
            icon: Icons.warning_amber_rounded,
            label: 'Warn',
            iconColor: const Color(0xFFFF9500),
            onTap: () {
              LiveClassViewModel livClassVM =
                  Provider.of<LiveClassViewModel>(context, listen: false);
              Navigator.pop(context);
              _showConfirmDialog(
                context: context,
                title: 'Warn ${liveUser.name}?',
                message:
                    'A warning will be sent to this student during the live class.',
                confirmLabel: 'Warn',
                confirmColor: const Color(0xFFFF9500),
                onConfirm: () {
                  livClassVM.updateParticipantStatus(
                      liveUser.uid, ParticipantAction.isWarned);
                },
              );
            },
          ),
          const Divider(
              height: 0.5,
              thickness: 0.5,
              color: Color(0xFFE5E5EA),
              indent: 52),
          // Delete message
          _ActionTile(
            icon: Icons.delete_outline_rounded,
            label: 'Delete Message',
            iconColor: const Color(0xFFFF3B30),
            onTap: () {
              LiveClassViewModel livClassVM =
                  Provider.of<LiveClassViewModel>(context, listen: false);
              Navigator.pop(context);
              _showConfirmDialog(
                context: context,
                title: 'Delete message?',
                message:
                    'All messages from ${liveUser.name} will be removed for everyone.',
                confirmLabel: 'Delete',
                confirmColor: const Color(0xFFFF3B30),
                onConfirm: () {
                  livClassVM.updateParticipantStatus(
                      liveUser.uid, ParticipantAction.isDelete);
                },
              );
            },
          ),
          const Divider(
              height: 0.5,
              thickness: 0.5,
              color: Color(0xFFE5E5EA),
              indent: 52),
          // Block
          _ActionTile(
            icon: Icons.block_rounded,
            label: 'Block',
            iconColor: const Color(0xFFFF3B30),
            onTap: () {
              LiveClassViewModel livClassVM =
                  Provider.of<LiveClassViewModel>(context, listen: false);
              Navigator.pop(context);
              _showConfirmDialog(
                context: context,
                title: 'Block ${liveUser.name}?',
                message:
                    'This student will be removed from the live class and won\'t be able to rejoin.',
                confirmLabel: 'Block',
                confirmColor: const Color(0xFFFF3B30),
                onConfirm: () {
                  livClassVM.updateParticipantStatus(
                      liveUser.uid, ParticipantAction.isBlock);
                },
              );
            },
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

void _showConfirmDialog({
  required BuildContext context,
  required String title,
  required String message,
  required String confirmLabel,
  required Color confirmColor,
  required VoidCallback onConfirm,
}) {
  showDialog(
    context: context,
    builder: (dialogContext) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      title: Text(title,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
      content: Text(message,
          style: const TextStyle(fontSize: 13, color: Color(0xFF6C6C70))),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext),
          child:
              const Text('Cancel', style: TextStyle(color: Color(0xFF8E8E93))),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(dialogContext);
            onConfirm();
          },
          child: Text(confirmLabel,
              style:
                  TextStyle(color: confirmColor, fontWeight: FontWeight.w600)),
        ),
      ],
    ),
  );
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color iconColor;
  final VoidCallback onTap;

  const _ActionTile({
    required this.icon,
    required this.label,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 18, color: iconColor),
            ),
            const SizedBox(width: 14),
            Text(label,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: iconColor)),
          ],
        ),
      ),
    );
  }
}
