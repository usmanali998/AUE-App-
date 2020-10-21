// To parse this JSON data, do
//
//     final studentProfile = studentProfileFromJson(jsonString);

import 'dart:convert';

List<StudentProfile> studentProfileFromJson(String str) => List<StudentProfile>.from(json.decode(str).map((x) => StudentProfile.fromJson(x)));

String studentProfileToJson(List<StudentProfile> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class StudentProfile {
  StudentProfile({
    this.studentId,
    this.fullName,
    this.email,
    this.mobileNumber,
    this.dateOfBirth,
    this.college,
    this.degree,
    this.specialization,
    this.englishLevel,
    this.englishScore,
    this.studentAdvisor,
    this.cgpa,
    this.imageThumbnail,
  });

  String studentId;
  String fullName;
  String email;
  String mobileNumber;
  DateTime dateOfBirth;
  String college;
  String degree;
  String specialization;
  String englishLevel;
  double englishScore;
  String studentAdvisor;
  double cgpa;
  String imageThumbnail;

  factory StudentProfile.fromJson(Map<String, dynamic> json) => StudentProfile(
    studentId: json["StudentID"],
    fullName: json["FullName"],
    email: json["Email"],
    mobileNumber: json["MobileNumber"],
    dateOfBirth: DateTime.parse(json["DateOfBirth"]),
    college: json["College"],
    degree: json["Degree"],
    specialization: json["Specialization"],
    englishLevel: json["EnglishLevel"],
    englishScore: json["EnglishScore"],
    studentAdvisor: json["StudentAdvisor"],
    cgpa: json["CGPA"].toDouble(),
    imageThumbnail: json["ImageThumbnail"],
  );

  Map<String, dynamic> toJson() => {
    "StudentID": studentId,
    "FullName": fullName,
    "Email": email,
    "MobileNumber": mobileNumber,
    "DateOfBirth": dateOfBirth.toIso8601String(),
    "College": college,
    "Degree": degree,
    "Specialization": specialization,
    "EnglishLevel": englishLevel,
    "EnglishScore": englishScore,
    "StudentAdvisor": studentAdvisor,
    "CGPA": cgpa,
    "ImageThumbnail": imageThumbnail,
  };
}
