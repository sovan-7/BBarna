// ignore_for_file: must_be_immutable

import 'package:b_barna_app/core/widgets/delete_account.dart';
import 'package:b_barna_app/student/viewModel/student_vm.dart';
import 'package:flutter/material.dart';
import 'package:b_barna_app/core/route/route_name.dart';
import 'package:b_barna_app/core/widgets/logout_dialog.dart';
import 'package:b_barna_app/enrolledCourses/screens/enrolled_course_list.dart';
import 'package:b_barna_app/textSize/text_view_normal.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class ListCard extends StatefulWidget {
  String? listItemsName;
  IconData iconData;
  int? index;
  ListCard({
    super.key,
    required this.listItemsName,
    required this.iconData,
    required this.index,
  });

  @override
  State<ListCard> createState() => _ListCardState();
}

class _ListCardState extends State<ListCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (widget.index == 0) {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return const Dialog(
                    insetPadding: EdgeInsets.all(0),
                    backgroundColor: Colors.transparent,
                    child: EnrolledCourseList());
              });
        } else if (widget.index == 1) {
          Navigator.pushNamed(context, RouteName.termsConditionScreenRoute);
        } else if (widget.index == 2) {
          Navigator.pushNamed(context, RouteName.privacyPolicyScreenRoute);
        } else if (widget.index == 3) {
          Navigator.pushNamed(context, RouteName.aboutUsScreenRoute);
        } else if (widget.index == 4) {
          Share.share('check out my website https://flutter.dev',
              subject: 'Look what I made!');
        } else if (widget.index == 5) {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return const LogoutDialog();
              });
        } else if (widget.index == 6) {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return DeleteAccount(
                  onSubmit: () {
                    Navigator.pop(context);
                    Provider.of<StudentViewModel>(context, listen: false)
                        .deleteStudent();
                  },
                );
              });
        }
      },
      child: Container(
        height: 65,
        decoration: const BoxDecoration(
            border: Border(
                bottom: BorderSide(
          color: Colors.black,
          width: 1,
        ))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  widget.iconData,
                  size: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: TextViewNormal(
                    textContent: widget.listItemsName,
                    textSizeNumber: 16,
                    textColor: Colors.black,
                  ),
                ),
              ],
            ),
            Icon(
              Icons.arrow_circle_right,
              size: 30,
              color: Colors.black.withOpacity(0.8),
            ),
          ],
        ),
      ),
    );
  }
}
