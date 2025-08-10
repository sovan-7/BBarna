import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:b_barna_app/core/constants/string_constants.dart';
import 'package:b_barna_app/textSize/text_view_bold.dart';
import 'package:b_barna_app/utils/helper.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/widgets/app_header.dart';

class AboutUsScreen extends StatefulWidget {
  const AboutUsScreen({super.key});

  @override
  State<AboutUsScreen> createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> {
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
              'assets/images/png/about_us_banner.png',
              height: 240,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: HtmlWidget(
                        // the first parameter (`html`) is required
                        StringConstants.aboutUsHtml,
                        textStyle: TextStyle(fontSize: 14),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 20, right: 20, top: 20, bottom: 20),
                      child: InkWell(
                        onTap: () async {
                          try {
                            await launchUrl(Uri.parse(
                                "https://b-barna-website.vercel.app/"));
                          } catch (e) {
                            Helper.showSnackBarMessage(
                                msg: "Sorry something went wrong",
                                isSuccess: false);
                          }
                        },
                        child: Container(
                          height: 60,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: const Color(0xFF09636E),
                              borderRadius: BorderRadius.circular(12)),
                          child: Center(
                              child: TextViewBold(
                                  textContent: "Visit Our Website",
                                  textSizeNumber: 16)),
                        ),
                      ),
                    )
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
