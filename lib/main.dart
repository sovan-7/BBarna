import 'package:flutter/material.dart';
//import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:b_barna_app/audio/viewModel/audio_viewmodel.dart';
import 'package:b_barna_app/core/constants/value_constants.dart';
import 'package:b_barna_app/core/route/app_route.dart';
import 'package:b_barna_app/core/route/route_name.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:b_barna_app/courseSection/viewModel/course_view_model.dart';
import 'package:b_barna_app/courseSection/viewModel/subject_viewmodel.dart';
import 'package:b_barna_app/courseSection/viewModel/topic_viewmodel.dart';
import 'package:b_barna_app/courseSection/viewModel/unit_viewmodel.dart';
import 'package:b_barna_app/enrolledCourses/enrolledCourseViewmodel/enrolled_viewmodel.dart';
import 'package:b_barna_app/homeScreen/viewModel/home_viewmodel.dart';
import 'package:b_barna_app/pdf/viewModel/pdf_viewmodel.dart';
import 'package:b_barna_app/quiz/viewModel/quiz_viewmodel.dart';
import 'package:b_barna_app/scoreBoard/viewmodel/score_viewmodel.dart';
import 'package:b_barna_app/student/viewModel/student_vm.dart';
import 'package:b_barna_app/utils/shared_pref_operations.dart';
import 'package:b_barna_app/utils/size_config.dart';
import 'package:b_barna_app/video/viewmodel/video_viewmodel.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  sp = SharedPrefOperations.getInstance;
  sp?.init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (_) => StudentViewModel(),
    ),
    ChangeNotifierProvider(create: (_) => CourseViewModel()),
    ChangeNotifierProvider(create: (_) => SubjectViewModel()),
    ChangeNotifierProvider(create: (_) => UnitViewModel()),
    ChangeNotifierProvider(create: (_) => TopicViewModel()),
    ChangeNotifierProvider(create: (_) => QuizViewModel()),
    ChangeNotifierProvider(create: (_) => PdfViewModel()),
    ChangeNotifierProvider(create: (_) => ScoreViewModel()),
    ChangeNotifierProvider(create: (_) => VideoViewModel()),
    ChangeNotifierProvider(create: (_) => AudioViewModel()),
    ChangeNotifierProvider(create: (_) => HomeViewModel()),
    ChangeNotifierProvider(create: (_) => EnrolledCourseViewModel()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return MaterialApp(
      title: 'B_Barna',
      scaffoldMessengerKey: snackBarKey,
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      onGenerateRoute: AppRouter.generateRoute,
      initialRoute: RouteName.splashScreenRoute,
    );
  }
}
