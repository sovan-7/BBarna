class LiveClassModel {
  final int endTime;
  final int startTime;
  final String teacherName;
  final String thumbnail;
  final String title;
  final String youtubeVideoId;

  LiveClassModel({
    required this.endTime,
    required this.startTime,
    required this.teacherName,
    required this.thumbnail,
    required this.title,
    required this.youtubeVideoId,
  });

  factory LiveClassModel.fromMap(
      Map<String, dynamic> map,
      ) {
    return LiveClassModel(
      endTime: map['endTime'] ?? 0,
      startTime: map['startTime'] ?? 0,
      teacherName: map['teacherName'] ?? '',
      thumbnail: map['thumbnail'] ?? '',
      title: map['title'] ?? '',
      youtubeVideoId: map['youtubeVideoId'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'endTime': endTime,
      'startTime': startTime,
      'teacherName': teacherName,
      'thumbnail': thumbnail,
      'title': title,
      'youtubeVideoId': youtubeVideoId,
    };
  }
}