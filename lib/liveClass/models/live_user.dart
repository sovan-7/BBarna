class LiveUser {
  final String uid;
  final String name;
  final bool isOnline;

  LiveUser({
    required this.uid,
    required this.name,
    required this.isOnline,
  });

  factory LiveUser.fromMap(String uid, Map data) {
    return LiveUser(
      uid: uid,
      name: data['name'] ?? '',
      isOnline: data['isOnline'] ?? false,
    );
  }
}