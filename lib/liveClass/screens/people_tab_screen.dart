import 'package:b_barna_app/core/constants/value_constants.dart';
import 'package:b_barna_app/liveClass/models/live_user.dart';
import 'package:b_barna_app/utils/helper.dart';
import 'package:flutter/material.dart';
enum StudentStatus { teacher, online, handRaised }


class PeopleTabScreen extends StatefulWidget {
  List<LiveUser> liveUser;
  List<LiveUser> teacher;
   PeopleTabScreen({ required this.liveUser,required this.teacher,super.key});

  @override
  State<PeopleTabScreen> createState() => _PeopleTabScreenState();
}

class _PeopleTabScreenState extends State<PeopleTabScreen> {
  AvatarColors avatarColors= Helper().getRandomAvatarColors();

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
        PeopleCard(students: widget.teacher,avatarColors: avatarColors,role: "Teacher",),
        const SizedBox(height: 14),
        Padding(
          padding: const EdgeInsets.only(left: 2),
          child: Text('Students — ${1 + 24} online'.toUpperCase(),
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
        ),
      ],
    );
  }
}



class PeopleCard extends StatelessWidget {
  final List<LiveUser> students;
 final AvatarColors avatarColors;
 final String role;
  const PeopleCard({
    required this.students,
    required this.avatarColors,
    required this.role
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
            final isLast = e.key == students.length - 1 ;
            return StudentRow(liveUser: e.value, showDivider: !isLast,avatarColors: avatarColors, role: role,);
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

  const StudentRow({required this.liveUser, required this.showDivider,required this.avatarColors,required this.role});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              Container(
                width: 34,
                height: 11,
                decoration: BoxDecoration(color: avatarColors.bg, shape: BoxShape.circle),
                child: Center(
                  child: Text(Helper.nameToInitials(liveUser.name) ,
                      style: TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.w600,
                          color: avatarColors.fg)),
                ),
              ),
              const SizedBox(width: 10),
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
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: Color(0xFFE1F5EE),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(liveUser.isOnline? "Online":"Offline",
                    style: TextStyle(
                        fontSize: 10, fontWeight: FontWeight.w500, color: Color(0xFF085041))),
              )
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

// bg: const Color(0xFFEEEDFE),
// fg: const Color(0xFF3C3489));
// bg: const Color(0xFFFAEEDA),
// fg: const Color(0xFF633806),


