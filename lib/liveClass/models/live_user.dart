class LiveUser {
  final String uid;
  final String name;
  final bool isOnline;
  final bool isBlock;
  final bool isWarned;

  LiveUser({
    required this.uid,
    required this.name,
    required this.isOnline,
    required this.isBlock,
    required this.isWarned
  });

  factory LiveUser.fromMap(String uid, Map data) {
    return LiveUser(
      uid: uid,
      name: data['name'] ?? '',
      isOnline: data['isOnline'] ?? false,
      isBlock: data['isBlock'] ?? false,
      isWarned: data['isWarned'] ?? false,
    );
  }
}