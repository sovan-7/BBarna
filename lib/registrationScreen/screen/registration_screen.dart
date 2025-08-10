import 'package:flutter/material.dart';
import 'package:b_barna_app/core/constants/value_constants.dart';
import 'package:b_barna_app/core/route/route_name.dart';
import 'package:b_barna_app/core/widgets/app_loader.dart';
import 'package:b_barna_app/student/model/student_model.dart';
import 'package:b_barna_app/student/viewModel/student_vm.dart';
import 'package:b_barna_app/textSize/text_view_bold.dart';
import 'package:b_barna_app/textSize/text_view_normal.dart';
import 'package:b_barna_app/utils/sp_keys.dart';
import 'package:provider/provider.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  bool? isChecked = true;
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  @override
  void initState() {
    phoneController.text = (sp?.getStringFromPref(SPKeys.phoneNumber))!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: MediaQuery.of(context).size.width,
        color: const Color(0xFF09636E),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 80,
              width: 80,
              margin: const EdgeInsets.only(
                bottom: 10,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                color: Colors.white,
              ),
              child: Image.asset(
                "assets/images/png/logo.png",
                fit: BoxFit.contain,
              ),
            ),
            TextViewBold(
              textContent: "Student Registration",
              textSizeNumber: 25,
              textColor: Colors.black,
            ),
            Container(
              height: 450,
              width: MediaQuery.of(context).size.width - 40,
              margin: const EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
              ),
              padding: const EdgeInsets.only(
                left: 10,
                right: 10,
                top: 10,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextViewNormal(
                    textContent: "Welcome ,",
                    textSizeNumber: 22,
                    textColor: Colors.black,
                  ),
                  TextViewNormal(
                    textContent: "Create New Account",
                    textSizeNumber: 18,
                    textColor: Colors.grey,
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 20.0),
                    child: Column(
                      children: [
                        TextField(
                          obscureText: false,
                          controller: nameController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Full Name',
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 15.0),
                          child: TextField(
                            controller: emailController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Email ID',
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 15.0),
                          child: TextField(
                            controller: phoneController,
                            readOnly: true,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Phone No',
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Checkbox(
                              activeColor: Colors.black,
                              isError: true,
                              // tristate: true,
                              value: isChecked,
                              onChanged: (bool? value) {
                                setState(() {
                                  isChecked = value;
                                });
                              },
                            ),
                            TextViewNormal(
                              textContent: "I agree with Terms & Condition",
                              textSizeNumber: 13,
                              textColor: Colors.black,
                            )
                          ],
                        ),
                        InkWell(
                          onTap: () async {
                            AppLoader.showLoader(context);
                            Student studentData = Student(
                              studentProfileImage: "",
                              studentName: nameController.text,
                              studentPhoneNumber: phoneController.text,
                              studentWhatsappNumber: phoneController.text,
                              studentEmail: emailController.text,
                            );
                            await Provider.of<StudentViewModel>(context,
                                    listen: false)
                                .addStudent(studentData)
                                .then((value) {
                              //sp?.setBoolToPref(SPKeys.isLoggedIn, true);
                              AppLoader.hideLoader(context);
                              Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  RouteName.bottomNavBarScreenRoute,
                                  (r) => false);
                            });
                          },
                          child: Container(
                            height: 50,
                            width: MediaQuery.of(context).size.width - 40 - 10,
                            margin: const EdgeInsets.only(
                                left: 5, right: 5, top: 15),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: isChecked!
                                  ? const Color(0xFF09636E)
                                  : const Color(0xFF09636E).withOpacity(0.5),
                            ),
                            child: TextViewNormal(
                              textContent: "CONTINUE",
                              textSizeNumber: 25,
                              textColor: Colors.black,
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
