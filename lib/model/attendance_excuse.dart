// To parse this JSON data, do
//
//     final attendanceExcuse = attendanceExcuseFromJson(jsonString);

import 'dart:convert';

List<AttendanceExcuse> attendanceExcuseFromJson(String str) => List<AttendanceExcuse>.from(json.decode(str).map((x) => AttendanceExcuse.fromJson(x)));

String attendanceExcuseToJson(List<AttendanceExcuse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AttendanceExcuse {
  AttendanceExcuse({
    this.courseCode,
    this.courseName,
    this.attendanceDate,
    this.statusName,
    this.requestDate,
    this.processedDate,
  });

  String courseCode;
  String courseName;
  DateTime attendanceDate;
  String statusName;
  DateTime requestDate;
  dynamic processedDate;

  factory AttendanceExcuse.fromJson(Map<String, dynamic> json) => AttendanceExcuse(
    courseCode: json["CourseCode"],
    courseName: json["CourseName"],
    attendanceDate: DateTime.parse(json["AttendanceDate"]),
    statusName: json["StatusName"],
    requestDate: DateTime.parse(json["RequestDate"]),
    processedDate: json["ProcessedDate"],
  );

  Map<String, dynamic> toJson() => {
    "CourseCode": courseCode,
    "CourseName": courseName,
    "AttendanceDate": attendanceDate.toIso8601String(),
    "StatusName": statusName,
    "RequestDate": requestDate.toIso8601String(),
    "ProcessedDate": processedDate,
  };
}
