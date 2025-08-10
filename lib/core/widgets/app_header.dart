import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:b_barna_app/core/constants/value_constants.dart';
import 'package:b_barna_app/editProfile/screen/edit_profile_screen.dart';
import 'package:b_barna_app/student/viewModel/student_vm.dart';
import 'package:b_barna_app/textSize/text_view_bold.dart';
import 'package:b_barna_app/textSize/text_view_normal.dart';
import 'package:b_barna_app/utils/sp_keys.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class AppHeader extends StatelessWidget {
  bool shouldLanguageIconVisible;
  bool isBackVisible;
  AppHeader(
      {super.key,
      this.shouldLanguageIconVisible = true,
      this.isBackVisible = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: isBackVisible ? 0 : 10,
        right: 10,
      ),
      height: 50,
      width: MediaQuery.of(context).size.width,
      color: const Color(0xFF09636E),
      //Colors.blue,
      child: Row(
        children: [
          Visibility(
            visible: isBackVisible,
            child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.white,
                  size: 25,
                )),
          ),
          Consumer<StudentViewModel>(
            builder: (BuildContext context, studentVM, Widget? child) {
              return Row(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const EditProfileScreen()),
                      );
                    },
                    child: Container(
                        height: 35,
                        width: 35,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Colors.white,
                        ),
                        child:
                            // (studentVM.student?.studentProfileImage)?.isEmpty ==
                            //         null
                            Image.asset(
                          "assets/images/png/user.png",
                          fit: BoxFit.fill,
                        )
                        // : Image.network(
                        //     (studentVM.student?.studentProfileImage)!),
                        ),
                  ),
                  Container(
                    height: 30,
                    width: 2,
                    margin: const EdgeInsets.only(
                      left: 5,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.white.withOpacity(0.5),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextViewNormal(
                            textContent: getGreetingMessage(),
                            textSizeNumber: 14.0),
                        TextViewBold(
                            textContent: sp!.getStringFromPref(SPKeys.name),
                            //studentVM.student?.studentName,
                            textSizeNumber: 15.0),
                      ],
                    ),
                  )
                ],
              );
            },
          ),
          const Spacer(),
          Visibility(
            visible: shouldLanguageIconVisible,
            child: InkWell(
              onTap: () {},
              child: SvgPicture.asset(
                "assets/images/svg/language.svg",
                height: 40,
                colorFilter:
                    const ColorFilter.mode(Colors.white, BlendMode.srcIn),
              ),
            ),
          )
        ],
      ),
    );
  }

  String getGreetingMessage() {
    final hour = DateTime.now().hour;

    if (hour < 12) {
      return "Good Morning";
    } else if (hour < 18) {
      return "Good Afternoon";
    } else if (hour < 21) {
      return "Good Evening";
    } else {
      return "Still awake? Glad to have you here!";
    }
  }
}
