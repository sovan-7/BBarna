import 'package:flutter/material.dart';
import 'package:b_barna_app/core/route/route_name.dart';
import 'package:b_barna_app/core/widgets/app_header.dart';
import 'package:b_barna_app/courseSection/widgets/course_card.dart';
import 'package:b_barna_app/courseSection/viewModel/course_view_model.dart';
import 'package:provider/provider.dart';

class CourseList extends StatelessWidget {
  const CourseList({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Container(
        color: const Color(0xFF09636E).withOpacity(0.05),
        child: Column(
          children: [
            AppHeader(),
            Expanded(child: Consumer<CourseViewModel>(
                builder: (context, courseDataProvider, child) {
              return SizedBox(
                height:
                    (260 * courseDataProvider.courseList.length.toDouble()) / 2,
                child: RefreshIndicator(
                  onRefresh: () async {
                    courseDataProvider.getCourseList();
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: GridView.builder(
                        physics: const ClampingScrollPhysics(),
                        itemCount: courseDataProvider.courseList.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisExtent: 230,
                        ),
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, RouteName.subjectList,
                                  arguments: {
                                    "courseCode": courseDataProvider
                                        .courseList[index].code,
                                    "appHeaderName": courseDataProvider
                                        .courseList[index].name
                                  });
                            },
                            child: CourseCard(
                                courseImage:
                                    courseDataProvider.courseList[index].image,
                                courseText:
                                    courseDataProvider.courseList[index].name,
                                isUpperStackCardVisible: false),
                          );
                        }),
                  ),
                ),
              );
            }))
          ],
        ),
      ),
    ));
  }
}
