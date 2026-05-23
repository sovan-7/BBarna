import 'package:flutter/material.dart';
import 'package:b_barna_app/textSize/text_view_bold.dart';
import 'package:b_barna_app/textSize/text_view_normal.dart';

class AppUpdateDialog extends StatelessWidget {
  final bool isForceUpdate;
  final VoidCallback onUpdate;
  final VoidCallback? onSkip;

  const AppUpdateDialog({
    super.key,
    required this.isForceUpdate,
    required this.onUpdate,
    this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    const dialogExtraWidthToMinus = 80;
    final dialogWidth =
        MediaQuery.of(context).size.width - dialogExtraWidthToMinus;
    final buttonWidth = (dialogWidth - 2) / 2;

    return Dialog(
      insetPadding: const EdgeInsets.all(0),
      backgroundColor: Colors.transparent,
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      child: Container(
        height: 270,
        width: dialogWidth,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 0),
          child: Column(
            children: [
              Image.asset(
                "assets/images/png/update.png",
                height: 100,
                width: 100,
                fit: BoxFit.fill,
              ),
              TextViewBold(
                textContent:
                isForceUpdate ? "Update Required!" : "Update Available",
                textSizeNumber: 16,
                textColor: Colors.black,
              ),
              Padding(
                padding:
                const EdgeInsets.only(top: 8.0, left: 16, right: 16),
                child: TextViewNormal(
                  textContent: isForceUpdate
                      ? "A new version of the app is available. You must update to continue using the app."
                      : "A new version of the app is available. Would you like to update now?",
                  textSizeNumber: 14,
                  textColor: Colors.black,
                ),
              ),
              const Spacer(),
              if (isForceUpdate)
                _buildFullWidthButton(
                  context: context,
                  dialogWidth: dialogWidth,
                  label: "Update",
                  onTap: onUpdate,
                )
              else
                Row(
                  children: [
                    InkWell(
                      onTap: onSkip,
                      child: Container(
                        height: 50,
                        width: buttonWidth,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          border: Border(
                            top: BorderSide(width: 1, color: Colors.grey),
                          ),
                        ),
                        child: TextViewBold(
                          textContent: "Skip",
                          textSizeNumber: 14,
                          textColor: Colors.black,
                        ),
                      ),
                    ),
                    Container(height: 50, width: 2, color: Colors.grey),
                    InkWell(
                      onTap: onUpdate,
                      child: Container(
                        height: 50,
                        width: buttonWidth,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          border: Border(
                            top: BorderSide(width: 1, color: Colors.grey),
                          ),
                        ),
                        child: TextViewBold(
                          textContent: "Update",
                          textSizeNumber: 14,
                          textColor: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFullWidthButton({
    required BuildContext context,
    required double dialogWidth,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 50,
        width: dialogWidth,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(width: 1, color: Colors.grey),
          ),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
        ),
        child: TextViewBold(
          textContent: label,
          textSizeNumber: 14,
          textColor: Colors.blue,
        ),
      ),
    );
  }
}
