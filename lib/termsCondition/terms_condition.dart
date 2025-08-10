import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:b_barna_app/core/constants/terms_condition.dart';

import '../core/widgets/app_header.dart';

class TermsConditionScreen extends StatefulWidget {
  const TermsConditionScreen({super.key});

  @override
  State<TermsConditionScreen> createState() => _TermsConditionScreenState();
}

class _TermsConditionScreenState extends State<TermsConditionScreen> {
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
              'assets/images/jpg/terms.jpg',
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
                        TermsCondition.termsCondition,
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
