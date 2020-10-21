// To parse this JSON data, do
//
//     final singleSection = singleSectionFromJson(jsonString);

import 'dart:convert';

List<SingleSection> singleSectionFromJson(String str) => List<SingleSection>.from(json.decode(str).map((x) => SingleSection.fromJson(x)));

String singleSectionToJson(List<SingleSection> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SingleSection {
  SingleSection({
    this.employeeId,
    this.dateOfBirth,
    this.fullName,
    this.displayName,
    this.eMail,
    this.mobile,
    this.courseCode,
    this.courseName,
    this.sectionId,
    this.organizationName,
    this.schedule,
    this.mergeId,
    this.courseId,
    this.imageByte,
  });

  String employeeId;
  DateTime dateOfBirth;
  String fullName;
  String displayName;
  String eMail;
  String mobile;
  String courseCode;
  String courseName;
  int sectionId;
  String organizationName;
  String schedule;
  String mergeId;
  String courseId;
  String imageByte;

  factory SingleSection.fromJson(Map<String, dynamic> json) => SingleSection(
    employeeId: json["EmployeeID"],
    dateOfBirth: DateTime.parse(json["DateOfBirth"]),
    fullName: json["FullName"],
    displayName: json["DisplayName"],
    eMail: json["EMail"],
    mobile: json["Mobile"],
    courseCode: json["CourseCode"],
    courseName: json["CourseName"],
    sectionId: json["SectionID"],
    organizationName: json["OrganizationName"],
    schedule: json["Schedule"],
    mergeId: json["MergeID"],
    courseId: json["CourseID"],
    imageByte: json["ImageByte"],
  );

  Map<String, dynamic> toJson() => {
    "EmployeeID": employeeId,
    "DateOfBirth": dateOfBirth.toIso8601String(),
    "FullName": fullName,
    "DisplayName": displayName,
    "EMail": eMail,
    "Mobile": mobile,
    "CourseCode": courseCode,
    "CourseName": courseName,
    "SectionID": sectionId,
    "OrganizationName": organizationName,
    "Schedule": schedule,
    "MergeID": mergeId,
    "CourseID": courseId,
    "ImageByte": imageByte,
  };
}
