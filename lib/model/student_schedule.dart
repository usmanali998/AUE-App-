// To parse this JSON data, do
//
//     final courseSchedule = courseScheduleFromJson(jsonString);

import 'dart:convert';

List<CourseSchedule> courseScheduleFromJson(String str) => List<CourseSchedule>.from(json.decode(str).map((x) => CourseSchedule.fromJson(x)));

String courseScheduleToJson(List<CourseSchedule> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CourseSchedule {
  CourseSchedule({
    this.id,
    this.value,
    this.message,
    this.schedule,
  });

  int id;
  String value;
  String message;
  List<Schedule> schedule;

  factory CourseSchedule.fromJson(Map<String, dynamic> json) => CourseSchedule(
    id: json["ID"],
    value: json["Value"],
    message: json["Message"],
    schedule: List<Schedule>.from(json["Schedule"].map((x) => Schedule.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "ID": id,
    "Value": value,
    "Message": message,
    "Schedule": List<dynamic>.from(schedule.map((x) => x.toJson())),
  };
}

class Schedule {
  Schedule({
    this.sectionId,
    this.sectionCode,
    this.mergeId,
    this.courseName,
    this.courseCode,
    this.creditHours,
    this.classroom,
    this.totalStudents,
    this.dayId,
    this.day,
    this.startTime,
    this.endTime,
    this.timing,
    this.instructorImageByte,
    this.instructorName,
    this.code,
    this.message,
    this.syllabusNavigateUrl,
  });

  String sectionId;
  String sectionCode;
  String mergeId;
  String courseName;
  String courseCode;
  String creditHours;
  String classroom;
  String totalStudents;
  String dayId;
  String day;
  DateTime startTime;
  DateTime endTime;
  String timing;
  dynamic instructorImageByte;
  String instructorName;
  String code;
  String message;
  String syllabusNavigateUrl;

  factory Schedule.fromJson(Map<String, dynamic> json) => Schedule(
    sectionId: json["SectionID"],
    sectionCode: json["SectionCode"],
    mergeId: json["MergeID"],
    courseName: json["CourseName"],
    courseCode: json["CourseCode"],
    creditHours: json["CreditHours"],
    classroom: json["Classroom"],
    totalStudents: json["TotalStudents"],
    dayId: json["DayID"],
    day: json["Day"],
    startTime: DateTime.parse(json["StartTime"]),
    endTime: DateTime.parse(json["EndTime"]),
    timing: json["Timing"],
    instructorImageByte: json["InstructorImageByte"],
    instructorName: json["InstructorName"],
    code: json["code"],
    message: json["Message"],
    syllabusNavigateUrl: json["SyllabusNavigateURL"],
  );

  Map<String, dynamic> toJson() => {
    "SectionID": sectionId,
    "SectionCode": sectionCode,
    "MergeID": mergeId,
    "CourseName": courseName,
    "CourseCode": courseCode,
    "CreditHours": creditHours,
    "Classroom": classroom,
    "TotalStudents": totalStudents,
    "DayID": dayId,
    "Day": day,
    "StartTime": startTime.toIso8601String(),
    "EndTime": endTime.toIso8601String(),
    "Timing": timing,
    "InstructorImageByte": instructorImageByte,
    "InstructorName": instructorName,
    "code": code,
    "Message": message,
    "SyllabusNavigateURL": syllabusNavigateUrl,
  };
}
