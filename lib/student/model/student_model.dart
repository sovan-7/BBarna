import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:b_barna_app/core/constants/value_constants.dart';

class Student {
  String? studentName = stringDefault;
  String? studentPhoneNumber = stringDefault;
  String? studentWhatsappNumber = stringDefault;
  String? studentEmail = stringDefault;
  String? studentProfileImage = stringDefault;
  String? guardianFullName = stringDefault;
  String? birthDay = stringDefault;
  bool? isMarried = boolDefault;
  String? highestDegree = stringDefault;
  String? collegeName = stringDefault;
  bool? isTmsAccepted;
  Address? address;

  Student(
      {required this.studentName,
      required this.studentProfileImage,
      required this.studentPhoneNumber,
      required this.studentWhatsappNumber,
      required this.studentEmail,
      this.guardianFullName,
      this.birthDay,
      this.isMarried,
      this.highestDegree,
      this.collegeName,
      this.isTmsAccepted,
      this.address});

  Map<String, dynamic> toMap() {
    return {
      "name": studentName,
      "student_image": studentProfileImage,
      "student_email": studentEmail,
      "mobile_number": studentPhoneNumber,
      "student_wp_number": studentWhatsappNumber,
      "guardian_full_name": guardianFullName,
      "birthday": birthDay,
      "is_married": isMarried,
      "highest_degree": highestDegree,
      "college_name": collegeName,
      "is_tms_accepted": isTmsAccepted,
      "address": address?.toMap()
    };
  }

  Student.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : studentName = doc.data()!["name"] ?? stringDefault,
        studentEmail = doc.data()!["student_email"] ?? stringDefault,
        studentProfileImage = doc.data()!["student_image"] ?? stringDefault,
        studentPhoneNumber = doc.data()!["mobile_number"] ?? stringDefault,
        studentWhatsappNumber =
            doc.data()!["student_wp_number"] ?? stringDefault,
        guardianFullName = doc.data()!["guardian_full_name"] ?? stringDefault,
        birthDay = doc.data()!["birthday"] ?? stringDefault,
        isMarried = doc.data()!["is_married"] ?? boolDefault,
        highestDegree = doc.data()!["highest_degree"] ?? stringDefault,
        collegeName = doc.data()!["college_name"] ?? stringDefault,
        isTmsAccepted = doc.data()!["is_tms_accepted"] ?? boolDefault,
        address = doc.data()!["address"] != null
            ? Address.fromMap(doc.data()!["address"])
            : Address(stringDefault, stringDefault, stringDefault,
                stringDefault, stringDefault);
}

class Address {
  String? pinCode = stringDefault;
  String? line1 = stringDefault;
  String? locality = stringDefault;
  String? city = stringDefault;
  String? state = stringDefault;

  Address(this.pinCode, this.line1, this.locality, this.city, this.state);

  Map<String, dynamic> toMap() {
    return {
      "pin_code": pinCode,
      "line1": line1,
      "locality": locality,
      "city": city,
      "state": state
    };
  }

  Address.fromMap(Map<String, dynamic> map)
      : pinCode = map["pin_code"],
        line1 = map["line1"],
        locality = map["locality"],
        city = map["city"],
        state = map["state"];
}
