// To parse this JSON data, do
//
//     final excusableAttendance = excusableAttendanceFromJson(jsonString);

import 'dart:convert';

List<ExcusableAttendance> excusableAttendanceFromJson(String str) => List<ExcusableAttendance>.from(json.decode(str).map((x) => ExcusableAttendance.fromJson(x)));

String excusableAttendanceToJson(List<ExcusableAttendance> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ExcusableAttendance {
  ExcusableAttendance({
    this.attendanceDate,
    this.attendanceId,
    this.courseCode,
    this.courseName,
    this.instructor,
    this.lectureHours,
  });

  DateTime attendanceDate;
  int attendanceId;
  String courseCode;
  String courseName;
  String instructor;
  double lectureHours;

  factory ExcusableAttendance.fromJson(Map<String, dynamic> json) => ExcusableAttendance(
    attendanceDate: DateTime.parse(json["AttendanceDate"]),
    attendanceId: json["AttendanceID"],
    courseCode: json["CourseCode"],
    courseName: json["CourseName"],
    instructor: json["Instructor"],
    lectureHours: json["LectureHours"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "AttendanceDate": attendanceDate.toIso8601String(),
    "AttendanceID": attendanceId,
    "CourseCode": courseCode,
    "CourseName": courseName,
    "Instructor": instructor,
    "LectureHours": lectureHours,
  };
}
