import 'package:flutter/material.dart';

// ─── Data models ──────────────────────────────────────────────────────────────

class Student {
  final String initials;
  final String name;
  final String role;
  final Color avatarBg;
  final Color avatarFg;
  final StudentStatus status;

  const Student({
    required this.initials,
    required this.name,
    required this.role,
    required this.avatarBg,
    required this.avatarFg,
    required this.status,
  });
}

enum StudentStatus { teacher, online, handRaised }

typedef AvatarData = ({String initials, Color bg, Color fg});


final List<Student> sampleStudents = [
  const Student(
    initials: 'AS',
    name: 'Prof. Anil Sharma',
    role: 'Host',
    avatarBg: Color(0xFFEEEDFE),
    avatarFg: Color(0xFF3C3489),
    status: StudentStatus.teacher,
  ),
  const Student(
    initials: 'TS',
    name: 'Tanvi S.',
    role: 'Student',
    avatarBg: Color(0xFFE1F5EE),
    avatarFg: Color(0xFF085041),
    status: StudentStatus.handRaised,
  ),
  const Student(
    initials: 'AK',
    name: 'Arjun K.',
    role: 'Student',
    avatarBg: Color(0xFFFBEAF0),
    avatarFg: Color(0xFF712B13),
    status: StudentStatus.online,
  ),
  const Student(
    initials: 'RN',
    name: 'Rhea N.',
    role: 'Student',
    avatarBg: Color(0xFFFAEEDA),
    avatarFg: Color(0xFF633806),
    status: StudentStatus.online,
  ),
];


class PeopleTabScreen extends StatelessWidget {
  const PeopleTabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final teacher =
        sampleStudents.where((s) => s.status == StudentStatus.teacher).toList();
    final students =
        sampleStudents.where((s) => s.status != StudentStatus.teacher).toList();

    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        _SectionLabel(label: 'Teacher'),
        const SizedBox(height: 6),
        _PeopleCard(students: teacher),
        const SizedBox(height: 14),
        _SectionLabel(label: 'Students — ${students.length + 24} online'),
        const SizedBox(height: 6),
        _PeopleCard(
          students: students,
          extraCount: 24,
          extraAvatars: const [
            (initials: 'PM', bg: Color(0xFFE6F1FB), fg: Color(0xFF0C447C)),
            (initials: 'KP', bg: Color(0xFFE1F5EE), fg: Color(0xFF085041)),
          ],
        ),
      ],
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 2),
      child: Text(label.toUpperCase(),
          style: const TextStyle(
              fontSize: 10,
              color: Color(0xFF8E8E93),
              letterSpacing: 0.5,
              fontWeight: FontWeight.w500)),
    );
  }
}

class _PeopleCard extends StatelessWidget {
  final List<Student> students;
  final int extraCount;
  final List<AvatarData> extraAvatars;

  const _PeopleCard({
    required this.students,
    this.extraCount = 0,
    this.extraAvatars = const [],
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
            final isLast = e.key == students.length - 1 && extraCount == 0;
            return _StudentRow(student: e.value, showDivider: !isLast);
          }),
          if (extraCount > 0)
            _ExtraRow(count: extraCount, avatars: extraAvatars),
        ],
      ),
    );
  }
}

class _StudentRow extends StatelessWidget {
  final Student student;
  final bool showDivider;

  const _StudentRow({required this.student, required this.showDivider});

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
                decoration: BoxDecoration(color: student.avatarBg, shape: BoxShape.circle),
                child: Center(
                  child: Text(student.initials,
                      style: TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.w600,
                          color: student.avatarFg)),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(student.name,
                        style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF1C1C1E))),
                    Text(student.role,
                        style: const TextStyle(
                            fontSize: 10, color: Color(0xFF8E8E93))),
                  ],
                ),
              ),
              _StatusBadge(status: student.status),
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

class _ExtraRow extends StatelessWidget {
  final int count;
  final List<AvatarData> avatars;

  const _ExtraRow({required this.count, required this.avatars});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          SizedBox(
            width: 60,
            height: 26,
            child: Stack(
              children: [
                ...avatars.asMap().entries.map((e) => Positioned(
                      left: e.key * 16.0,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border:
                              Border.all(color: Colors.white, width: 1.5),
                        ),
                        child:
                        Container(
                          width: 24,
                          height: 8,
                          decoration: BoxDecoration(color: e.value.bg, shape: BoxShape.circle),
                          child: Center(
                            child: Text(e.value.initials,
                                style: TextStyle(
                                    fontSize: 8,
                                    fontWeight: FontWeight.w600,
                                    color: e.value.fg)),
                          ),
                        ),
                      ),
                    )),
                Positioned(
                  left: avatars.length * 16.0,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1.5),
                    ),
                    child:Container(
                      width: 28,
                      height: 8,
                      decoration: BoxDecoration(color: const Color(0xFFF1EFE8), shape: BoxShape.circle),
                      child: Center(
                        child: Text('+$count',
                            style: TextStyle(
                                fontSize: 8,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF5F5E5A))),
                      ),
                    ),

                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text('$count more students online',
              style: const TextStyle(
                  fontSize: 12, color: Color(0xFF8E8E93))),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final StudentStatus status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case StudentStatus.teacher:
        return _Badge(
            label: 'Teacher',
            bg: const Color(0xFFEEEDFE),
            fg: const Color(0xFF3C3489));
      case StudentStatus.online:
        return _Badge(
            label: 'Online',
            bg: const Color(0xFFE1F5EE),
            fg: const Color(0xFF085041));
      case StudentStatus.handRaised:
        return _BadgeWithIcon(
            label: 'Hand up',
            bg: const Color(0xFFFAEEDA),
            fg: const Color(0xFF633806),
            icon: Icons.front_hand_outlined);
    }
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final Color bg;
  final Color fg;

  const _Badge({required this.label, required this.bg, required this.fg});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(label,
          style: TextStyle(
              fontSize: 10, fontWeight: FontWeight.w500, color: fg)),
    );
  }
}

class _BadgeWithIcon extends StatelessWidget {
  final String label;
  final Color bg;
  final Color fg;
  final IconData icon;

  const _BadgeWithIcon(
      {required this.label,
      required this.bg,
      required this.fg,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 10, color: fg),
          const SizedBox(width: 3),
          Text(label,
              style: TextStyle(
                  fontSize: 10, fontWeight: FontWeight.w500, color: fg)),
        ],
      ),
    );
  }
}

