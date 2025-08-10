import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:b_barna_app/textSize/text_view_bold.dart';
import 'package:b_barna_app/textSize/text_view_normal.dart';

// ignore: must_be_immutable
class CoursePrizeBottomSheet extends StatelessWidget {
  void Function()? onContinueButtonClick;
  CoursePrizeBottomSheet({super.key, this.onContinueButtonClick});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      padding: const EdgeInsets.only(
        top: 15,
        bottom: 15,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                height: 80,
                width: ((MediaQuery.of(context).size.width) - 40) / 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextViewBold(
                      textContent: "Change Plan",
                      textSizeNumber: 14,
                      textColor: Colors.black,
                    ),
                    TextViewBold(
                      textContent: "1 Year 16000/-",
                      textSizeNumber: 14,
                      textColor: Colors.black,
                    ),
                  ],
                ),
              ),
              Container(
                height: 80,
                width: ((MediaQuery.of(context).size.width) - 40) / 2,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.greenAccent,
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextViewBold(
                            textContent: "Code: BAI05000",
                            textSizeNumber: 14,
                            textColor: Colors.black,
                          ),
                          const Padding(
                            padding: EdgeInsets.only(right: 8.0),
                            child: Icon(
                              Icons.edit,
                              size: 18,
                            ),
                          )
                        ],
                      ),
                      TextViewBold(
                        textContent: "Discounted RS: 5000/-",
                        textSizeNumber: 14,
                        textColor: Colors.black,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Container(
            height: 40,
            width: (MediaQuery.of(context).size.width) - 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.greenAccent,
            ),
            child: TextViewBold(
              textContent: "Discounted Price: 11999/-",
              textSizeNumber: 16,
              textColor: Colors.black,
            ),
          ),
          InkWell(
            onTap: () {
              const dialogExtraWidthToMinus = 80;
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Dialog(
                      insetPadding: const EdgeInsets.all(0),
                      backgroundColor: Colors.transparent,
                      child: Container(
                        height: 300,
                        width: MediaQuery.of(context).size.width -
                            dialogExtraWidthToMinus,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),
                        child: Padding(
                          padding:
                              const EdgeInsets.only(top: 10.0, bottom: 10.0),
                          child: Column(
                            children: [
                              Lottie.asset("assets/json/success.json",
                                  height: 80, width: 80),
                              Padding(
                                padding: const EdgeInsets.only(top: 15.0),
                                child: TextViewBold(
                                  textContent: "Welcome Amaresh Sarkar",
                                  textSizeNumber: 18,
                                  textColor: Colors.black,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: TextViewNormal(
                                  textContent:
                                      "You are noe Enrolled Bengali Sahitto (Free)",
                                  textSizeNumber: 16,
                                  textColor: Colors.black,
                                ),
                              ),
                              const Spacer(),
                              InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  height: 40,
                                  width: MediaQuery.of(context).size.width -
                                      dialogExtraWidthToMinus,
                                  margin: const EdgeInsets.only(
                                    left: 10,
                                    right: 10,
                                    top: 20,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: const Color(0xFF09636E),
                                  ),
                                  alignment: Alignment.center,
                                  child: TextViewBold(
                                    textContent: "CONTINUE",
                                    textSizeNumber: 17,
                                    textColor: Colors.black,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  });
            },
            child: InkWell(
              onTap: onContinueButtonClick,
              child: Container(
                height: 50,
                width: (MediaQuery.of(context).size.width) - 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color(0xFF09636E)),
                child: TextViewBold(
                  textContent: "Continue >>",
                  textSizeNumber: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
