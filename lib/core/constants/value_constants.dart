import 'package:flutter/material.dart';
import 'package:b_barna_app/utils/shared_pref_operations.dart';

int intDefault = -1;
double doubleDefault = -1;
bool boolDefault = false;
String stringDefault = "NA";
OverlayState? overlayState;
SharedPrefOperations? sp;
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<ScaffoldMessengerState> snackBarKey =
    GlobalKey<ScaffoldMessengerState>();

/// Firestore collections
String student = "student";
const String admin = "admin";
const String question = "question";
const String course = "course";
const String subject = "subject";
const String unit = "unit";
const String topic = "topic";
const String video = "video";
const String pdf = "pdf";
const String audio = "audio";
const String quiz = "quiz";
const String banners = "banners";
const String results = "results";
const String enrolledCourse = "enrolledCourses";
const String teachers = "teachers";
// Avatar Background Colors
const List<Color> avatarBgColors = [
  Color(0xFFE1F5EE),
  Color(0xFFFBEAF0),
  Color(0xFFFAEEDA),
  Color(0xFFEEEDFE),
  Color(0xFFE6F1FB),
];

// Avatar Foreground Colors
const List<Color> avatarFgColors = [
  Color(0xFF085041),
  Color(0xFF712B13),
  Color(0xFF633806),
  Color(0xFF3C3489),
  Color(0xFF0C447C),
];
typedef AvatarColors = ({Color bg, Color fg});
