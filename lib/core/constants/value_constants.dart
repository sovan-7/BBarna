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
