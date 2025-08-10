import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:b_barna_app/core/constants/value_constants.dart';
import 'package:b_barna_app/enrolledCourses/model/enrolled_course_model.dart';
import 'package:b_barna_app/utils/helper.dart';
import 'package:b_barna_app/utils/sp_keys.dart';

class EnrolledCourseRepo {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  Future<EnrolledCourseBaseModel> getCourseList() async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await _fireStore
        .collection(enrolledCourse)
        .where("student_id", isEqualTo: sp!.getStringFromPref(SPKeys.studentId))
        .get();
    return EnrolledCourseBaseModel.fromDocumentSnapshot(snapshot.docs.first);
  }

  Future addCourse(Map<String, dynamic> newCourse) async {
    try {
      CollectionReference studentsRef =
          FirebaseFirestore.instance.collection(enrolledCourse);
      // Query the document where student_id matches
      QuerySnapshot querySnapshot = await studentsRef
          .where('student_id',
              isEqualTo: sp!.getStringFromPref(SPKeys.studentId))
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        // Assuming student_id is unique and you fetch only one document
        DocumentSnapshot studentDoc = querySnapshot.docs.first;

        // Update the course_list array with the new course
        await studentDoc.reference.update({
          'course_list': FieldValue.arrayUnion([newCourse]),
        });
      } else {
        studentsRef.add(newCourse);
      }
    } catch (e) {
      Helper.showSnackBarMessage(
          msg: "Error while fetching data", isSuccess: false);
    }
  }
}
