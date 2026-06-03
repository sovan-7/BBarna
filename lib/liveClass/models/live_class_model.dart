import 'package:b_barna_app/core/constants/value_constants.dart';

class LiveClassModel {
  final String id;
  final String subject;
  final String subjectId;
  final String title;
  final String subtitle;
  final String teacherName;
  final String teacherId;
  final int startTime;
  final int endTime;
  final String youtubeVideoLink;

  LiveClassModel({
    required this.id,
    required this.subject,
    required this.subjectId,
    required this.title,
    required this.subtitle,
    required this.teacherName,
    required this.teacherId,
    required this.startTime,
    required this.endTime,
    required this.youtubeVideoLink,
  });

  factory LiveClassModel.fromMap(
      Map<String, dynamic> map,
      String documentId,
      ) {
    return LiveClassModel(
      id: documentId,
      subject: map['subject'] ?? stringDefault,
      subjectId:map['subjectId'] ?? stringDefault,
      title: map['title'] ?? stringDefault,
      subtitle: map['subtitle'] ?? stringDefault,
      teacherName: map['teacherName'] ?? stringDefault,
      teacherId:map['teacherId'] ?? stringDefault ,
      startTime: map['startTime'] ?? 0,
      endTime: map['endTime'] ?? 0,
      youtubeVideoLink: map['youtubeVideoLink'] ?? stringDefault,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'subject': subject,
      "subjectId":subjectId,
      'title': title,
      'subtitle': subtitle,
      'teacherName': teacherName,
      'teacherId': teacherId,
      'startTime': startTime,
      'endTime': endTime,
      'youtubeVideoLink': youtubeVideoLink,
    };
  }
}