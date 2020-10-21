// To parse this JSON data, do
//
//     final semester = semesterFromJson(jsonString);

import 'dart:convert';

List<Semester> semesterFromJson(String str) => List<Semester>.from(json.decode(str).map((x) => Semester.fromJson(x)));

String semesterToJson(List<Semester> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Semester {
  Semester({
    this.semesterId,
    this.semesterName,
  });

  int semesterId;
  String semesterName;

  factory Semester.fromJson(Map<String, dynamic> json) => Semester(
    semesterId: json["SemesterID"],
    semesterName: json["SemesterName"],
  );

  Map<String, dynamic> toJson() => {
    "SemesterID": semesterId,
    "SemesterName": semesterName,
  };
}
