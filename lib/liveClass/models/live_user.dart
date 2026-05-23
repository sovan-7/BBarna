class LiveUser {
  final String uid;
  final String name;
  final bool online;

  LiveUser({
    required this.uid,
    required this.name,
    required this.online,
  });

  factory LiveUser.fromMap(String uid, Map data) {
    return LiveUser(
      uid: uid,
      name: data['name'] ?? '',
      online: data['online'] ?? false,
    );
  }
}