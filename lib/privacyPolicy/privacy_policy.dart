import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:b_barna_app/core/constants/privacy_policy.dart';

import '../core/widgets/app_header.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            AppHeader(
              shouldLanguageIconVisible: false,
              isBackVisible: true,
            ),
            Image.asset(
              'assets/images/jpg/privacy.jpg',
              height: 240,
              fit: BoxFit.fill,
            ),
            const Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: HtmlWidget(
                        // the first parameter (`html`) is required
                        PrivacyPolicyConst.privacyPolicy,
                        textStyle: TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
