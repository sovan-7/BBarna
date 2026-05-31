import 'package:b_barna_app/liveClass/models/live_class_model.dart';
import 'package:b_barna_app/liveClass/providers/live_class_viewmodel.dart';
import 'package:b_barna_app/liveClass/widgets/class_card.dart';
import 'package:b_barna_app/textSize/text_view_bold.dart';
import 'package:flutter/material.dart';

class ClassListView extends StatelessWidget {
  final List<LiveClassModel> classes;
  final LiveClassViewModel vm;
  final String classStatus;

  const ClassListView(
      {required this.classes,
      required this.vm,
      required this.classStatus,
      super.key});

  @override
  Widget build(BuildContext context) {
    if (classes.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.school_outlined, size: 44, color: Colors.grey),
            SizedBox(height: 10),
            TextViewBold(
              textContent: 'No classes here yet',
              textColor: Colors.grey,
              textSizeNumber: 15,
            ),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: classes.length,
      itemBuilder: (_, i) => Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: ClassCard(
          item: classes[i],
          vm: vm,
          classStatus: classStatus,
        ),
      ),
    );
  }
}
