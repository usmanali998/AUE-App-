import 'package:aue/model/current_semester.dart';

class User {
  String studentID;
  String fullName;
  String gender;
  String dateOfBirth;
  String firstName;
  String lastName;
  String nationality;
  String token;
  String collegeName;
  String programName;
  String degreeName;
  String semesterName;
  String arabicName;
  String mobileNo1;
  String mobileNo2;
  String emailAddress;
  CurrentSemester currentSemester;

  User({
    this.studentID,
    this.fullName,
    this.gender,
    this.dateOfBirth,
    this.firstName,
    this.lastName,
    this.nationality,
    this.token,
    this.collegeName,
    this.programName,
    this.degreeName,
    this.semesterName,
    this.arabicName,
    this.mobileNo1,
    this.mobileNo2,
    this.emailAddress,
    this.currentSemester,
  });

  User.fromJson(Map<String, dynamic> json) {
    studentID = json['StudentID'];
    fullName = json['FullName'];
    gender = json['Gender'];
    dateOfBirth = json['DateOfBirth'];
    firstName = json['FirstName'];
    lastName = json['LastName'];
    nationality = json['Nationality'];
    token = json['Token'];
    collegeName = json['CollegeName'];
    programName = json['ProgramName'];
    degreeName = json['DegreeName'];
    semesterName = json['SemesterName'];
    arabicName = json['ArabicName'];
    mobileNo1 = json['MobileNo1'];
    mobileNo2 = json['MobileNo2'];
    emailAddress = json['EmailAddress'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['StudentID'] = this.studentID;
    data['FullName'] = this.fullName;
    data['Gender'] = this.gender;
    data['DateOfBirth'] = this.dateOfBirth;
    data['FirstName'] = this.firstName;
    data['LastName'] = this.lastName;
    data['Nationality'] = this.nationality;
    data['Token'] = this.token;
    data['CollegeName'] = this.collegeName;
    data['ProgramName'] = this.programName;
    data['DegreeName'] = this.degreeName;
    data['SemesterName'] = this.semesterName;
    data['ArabicName'] = this.arabicName;
    data['MobileNo1'] = this.mobileNo1;
    data['MobileNo2'] = this.mobileNo2;
    data['EmailAddress'] = this.emailAddress;
    return data;
  }
}
