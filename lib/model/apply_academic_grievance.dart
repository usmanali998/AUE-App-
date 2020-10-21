// To parse this JSON data, do
//
//     final applyAcademicGrievance = applyAcademicGrievanceFromJson(jsonString);

import 'dart:convert';

ApplyAcademicGrievance applyAcademicGrievanceFromJson(String str) => ApplyAcademicGrievance.fromJson(json.decode(str));

String applyAcademicGrievanceToJson(ApplyAcademicGrievance data) => json.encode(data.toJson());

class ApplyAcademicGrievance {
  ApplyAcademicGrievance({
    this.studentId,
    this.categoryId,
    this.courseId,
    this.courseWorkId,
    this.details,
    this.communicatedTo,
    this.attachments,
  });

  String studentId;
  int categoryId;
  int courseId;
  int courseWorkId;
  String details;
  List<CommunicatedTo> communicatedTo;
  List<String> attachments;

  factory ApplyAcademicGrievance.fromJson(Map<String, dynamic> json) => ApplyAcademicGrievance(
    studentId: json["StudentID"],
    categoryId: json["CategoryID"],
    courseId: json["CourseID"],
    courseWorkId: json["CourseWorkID"],
    details: json["Details"],
    communicatedTo: List<CommunicatedTo>.from(json["CommunicatedTo"].map((x) => CommunicatedTo.fromJson(x))),
    attachments: List<String>.from(json["Attachments"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "StudentID": studentId,
    "CategoryID": categoryId,
    "CourseID": courseId,
    "CourseWorkID": courseWorkId,
    "Details": details,
    "CommunicatedTo": List<dynamic>.from(communicatedTo.map((x) => x.toJson())),
    "Attachments": List<dynamic>.from(attachments.map((x) => x)),
  };
}


class CommunicatedTo {
  CommunicatedTo({
    this.integerValue,
    this.stringValue,
  });

  int integerValue;
  String stringValue;

  factory CommunicatedTo.fromJson(Map<String, dynamic> json) => CommunicatedTo(
    integerValue: json["IntegerValue"],
    stringValue: json["StringValue"],
  );

  Map<String, dynamic> toJson() => {
    "IntegerValue": integerValue,
    "StringValue": stringValue,
  };
}
