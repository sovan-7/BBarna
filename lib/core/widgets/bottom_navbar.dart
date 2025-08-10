import 'package:flutter/material.dart';
import 'package:b_barna_app/core/widgets/app_header.dart';
import 'package:b_barna_app/courseSection/screen/course_list.dart';
import 'package:b_barna_app/courseSection/viewModel/course_view_model.dart';
import 'package:b_barna_app/editProfile/screen/edit_profile_screen.dart';
import 'package:b_barna_app/enrolledCourses/enrolledCourseViewmodel/enrolled_viewmodel.dart';
import 'package:b_barna_app/homeScreen/screen/home_screen.dart';
import 'package:b_barna_app/homeScreen/viewModel/home_viewmodel.dart';
import 'package:b_barna_app/student/viewModel/student_vm.dart';
import 'package:b_barna_app/textSize/text_view_bold.dart';
import 'package:provider/provider.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  List<String> navTextList = ["HOME", "COURSE", "PROFILE", "STORE"];
  List<IconData> iconList = [
    Icons.home,
    Icons.local_library,
    Icons.person,
    Icons.shopping_cart
  ];
  List<Widget> screenList = [
    const HomeScreen(),
    const CourseList(),
    const EditProfileScreen(),
    Container(
      alignment: Alignment.center,
      color: const Color(0xFF09636E).withOpacity(0.05),
      child: Column(
        children: [
          AppHeader(),
          const Spacer(),
          TextViewBold(
            textContent: "Coming Soon",
            textSizeNumber: 15,
            textColor: Colors.black,
          ),
          const Spacer(),
        ],
      ),
    ),
  ];
  int selectedIndex = 0;
  @override
  void initState() {
    Provider.of<StudentViewModel>(context, listen: false)
        .setCurrentStudentData()
        .then((value) {
      Provider.of<HomeViewModel>(context, listen: false).getSubjectList();
    });
    Provider.of<HomeViewModel>(context, listen: false).fetchBannerList();

    Provider.of<HomeViewModel>(context, listen: false).fetchTeacherList();
    Provider.of<CourseViewModel>(context, listen: false).getCourseList();
    Provider.of<EnrolledCourseViewModel>(context, listen: false)
        .getEnrolledCourseList();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: PopScope(
        onPopInvoked: (didPop) {
          setState(() {
            selectedIndex = 0;
          });
        },
        canPop: false,
        child: Scaffold(
          body: screenList[selectedIndex],
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Colors.white,
            currentIndex: selectedIndex,
            selectedItemColor: const Color(0xFF09636E).withOpacity(0.8),
            iconSize: 22,
            elevation: 3,
            selectedFontSize: 22,
            unselectedFontSize: 22,
            showUnselectedLabels: true,
            showSelectedLabels: true,
            type: BottomNavigationBarType.fixed,
            onTap: (index) {
              setState(() {
                selectedIndex = index;
              });
            },
            items: List.generate(
              navTextList.length,
              (index) => BottomNavigationBarItem(
                icon: Icon(
                  iconList[index],
                  color: index == selectedIndex
                      ? const Color(0xFF09636E).withOpacity(0.8)
                      : Colors.grey.shade600,
                ),
                label: navTextList[index],
              ),
            ),
            selectedLabelStyle: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF09636E).withOpacity(0.8)),
            unselectedLabelStyle: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade500),
          ),
        ),
      ),
    );
  }
}
