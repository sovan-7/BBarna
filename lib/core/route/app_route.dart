import 'package:b_barna_app/pdf/screen/free_pdf.dart';
import 'package:b_barna_app/quiz/screen/free_quiz.dart';
import 'package:b_barna_app/video/screen/free_video_list.dart';
import 'package:flutter/material.dart';
import 'package:b_barna_app/aboutUs/screens/about_us_screen.dart';
import 'package:b_barna_app/privacyPolicy/privacy_policy.dart';
import 'package:b_barna_app/termsCondition/terms_condition.dart';
import 'package:b_barna_app/core/route/route_name.dart';
import 'package:b_barna_app/core/widgets/bottom_navbar.dart';
import 'package:b_barna_app/pdf/screen/pdf_list.dart';
import 'package:b_barna_app/quiz/screen/quiz_screen.dart';
import 'package:b_barna_app/courseSection/screen/course_list.dart';
import 'package:b_barna_app/courseSection/screen/subject_list.dart';
import 'package:b_barna_app/courseSection/screen/topic_list.dart';
import 'package:b_barna_app/courseSection/screen/unit_list.dart';
import 'package:b_barna_app/editProfile/screen/edit_profile_screen.dart';
import 'package:b_barna_app/homeScreen/screen/home_screen.dart';
import 'package:b_barna_app/login/screen/login_screen.dart';
import 'package:b_barna_app/login/screen/otp_screen.dart';
import 'package:b_barna_app/quiz/screen/question_paper_screen.dart';
import 'package:b_barna_app/registrationScreen/screen/registration_screen.dart';
import 'package:b_barna_app/scoreBoard/screen/score_board_screen.dart';
import 'package:b_barna_app/scoreBoard/screen/view_result.dart';
import 'package:b_barna_app/splash/screen/splash_screen.dart';
import 'package:b_barna_app/userProfile/screen/user_profile_screen.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteName.courseList:
        return MaterialPageRoute(builder: (_) => const CourseList());
      case RouteName.subjectList:
        return MaterialPageRoute(builder: (_) {
          final args = settings.arguments as Map<String, dynamic>;

          return SubjectList(
            appHeaderName: args["appHeaderName"],
            courseCode: args["courseCode"],
          );
        });
      case RouteName.editProfile:
        return MaterialPageRoute(builder: (_) => const EditProfileScreen());
      case RouteName.allCourseScreenRoute:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case RouteName.questionPaperScreenRoute:
        return MaterialPageRoute(builder: (_) {
          final args = settings.arguments as Map<String, dynamic>;
          return QuestionPaperScreen(
            quizModel: args["quizModel"],
          );
        });
      case RouteName.registrationScreenRoute:
        return MaterialPageRoute(builder: (_) => const RegistrationScreen());
      case RouteName.scoreBoardScreenRoute:
        return MaterialPageRoute(builder: (_) {
          final args = settings.arguments as Map<String, dynamic>;
          return ScoreBoardScreen(
            quizCode: args["quizCode"],
          );
        });
      case RouteName.userProfileScreenRoute:
        return MaterialPageRoute(builder: (_) => const UserProfileScreen());
      case RouteName.bottomNavBarScreenRoute:
        return MaterialPageRoute(builder: (_) => const BottomNavBar());
      case RouteName.unitList:
        return MaterialPageRoute(builder: (_) {
          final args = settings.arguments as Map<String, dynamic>;
          return UnitList(
            subjectName: args["subjectName"],
            subjectCode: args["subjectCode"],
          );
        });
      case RouteName.topicList:
        return MaterialPageRoute(builder: (_) {
          final args = settings.arguments as Map<String, dynamic>;
          return TopicsList(
            unitCode: args["unitCode"],
            unitName: args["unitName"],
          );
        });
      case RouteName.aboutUsScreenRoute:
        return MaterialPageRoute(builder: (_) => const AboutUsScreen());
      case RouteName.quizScreenRoute:
        return MaterialPageRoute(builder: (_) {
          final args = settings.arguments as Map<String, dynamic>;
          return QuizScreen(
            quizCodeList: args["quizCodeList"],
          );
        });
      case RouteName.freeQuizScreenRoute:
        return MaterialPageRoute(builder: (_) {
          return FreeQuizScreen();
        });
        case RouteName.freePdfScreenRoute:
        return MaterialPageRoute(builder: (_) {
          return FreePdfList();
        });
        case RouteName.freeVideoScreenRoute:
        return MaterialPageRoute(builder: (_) {
          return FreeVideoList();
        });
      case RouteName.pdfList:
        return MaterialPageRoute(builder: (_) {
          final args = settings.arguments as Map<String, dynamic>;
          return PdfList(
            pdfCodeList: args["pdfCodeList"],
          );
        });
      case RouteName.loginScreenRoute:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case RouteName.otpVerificationScreenRoute:
        final arguments = (settings.arguments ?? <String, String>{}) as Map;
        return MaterialPageRoute(
            builder: (_) => OTPScreen(
                  verificationId: arguments["verificationId"],
                  phoneNumber: arguments["phoneNumber"],
                ));

      case RouteName.viewResult:
        return MaterialPageRoute(builder: (_) {
          final arguments = (settings.arguments ?? <String, String>{}) as Map;
          return ViewResult(
            resultModel: arguments["resultModel"],
          );
        });
      case RouteName.splashScreenRoute:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case RouteName.termsConditionScreenRoute:
        return MaterialPageRoute(builder: (_) => const TermsConditionScreen());
      case RouteName.privacyPolicyScreenRoute:
        return MaterialPageRoute(builder: (_) => const PrivacyPolicyScreen());
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(child: Text('Page not found')),
      );
    });
  }
}
