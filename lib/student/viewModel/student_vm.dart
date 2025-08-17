import 'package:flutter/material.dart';
import 'package:b_barna_app/student/model/student_model.dart';
import 'package:b_barna_app/student/repo/student_repo.dart';

class StudentViewModel with ChangeNotifier {
  final StudentRepo _studentRepo = StudentRepo();

  Student? student;
  clearData() {
    student = null;
  }

  Future setCurrentStudentData() async {
    student = await _studentRepo.getCurrentStudentData();
    notifyListeners();
  }

  Future<bool> isStudentExist() async {
    return await _studentRepo.isStudentExist();
  }

  addStudent(Student studentData) async {
    await _studentRepo.addStudent(studentData).then((value) async {
      await setCurrentStudentData();
    });
  }

  Future updateStudent(Student studentData) async {
    await _studentRepo.updateStudent(studentData).then((value) async {
      await setCurrentStudentData();
    });
  }

  Future deleteStudent() async {
    await _studentRepo.deleteStudent();
  }
}
