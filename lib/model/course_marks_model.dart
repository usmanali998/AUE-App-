// To parse this JSON data, do
//
//     final courseMarks = courseMarksFromJson(jsonString);

import 'dart:convert';

CourseMarks courseMarksFromJson(String str) => CourseMarks.fromJson(json.decode(str));

String courseMarksToJson(CourseMarks data) => json.encode(data.toJson());

class CourseMarks {
  CourseMarks({
    this.table1,
    this.courseWorkDetails,
  });

  List<Table1> table1;
  List<CourseWorkDetail> courseWorkDetails;

  factory CourseMarks.fromJson(Map<String, dynamic> json) => CourseMarks(
        table1: List<Table1>.from(json["Table1"].map((x) => Table1.fromJson(x))),
        courseWorkDetails: List<CourseWorkDetail>.from(json["CourseWorkDetails"].map((x) => CourseWorkDetail.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Table1": List<dynamic>.from(table1.map((x) => x.toJson())),
        "CourseWorkDetails": List<dynamic>.from(courseWorkDetails.map((x) => x.toJson())),
      };
}

class CourseWorkDetail {
  CourseWorkDetail({
    this.courseWorkPatternId,
    this.courseWorkId,
    this.description,
    this.dated,
    this.totalMark,
    this.actualMark,
    this.rubricId,
    this.inCompleteExamEligible,
    this.paperDownloadLink,
  });

  int courseWorkPatternId;
  int courseWorkId;
  String description;
  DateTime dated;
  double totalMark;
  double actualMark;
  bool inCompleteExamEligible;
  int rubricId;
  String paperDownloadLink;

  factory CourseWorkDetail.fromJson(Map<String, dynamic> json) => CourseWorkDetail(
        courseWorkPatternId: json["CourseWorkPatternID"],
        courseWorkId: json["CourseWorkID"],
        description: json["Description"],
        dated: DateTime.parse(json["Dated"]),
        totalMark: json["TotalMark"],
        actualMark: json["ActualMark"],
        inCompleteExamEligible: json['InCompleteExamEligible'],
        rubricId: json["RubricID"],
        paperDownloadLink: json['PaperDownloadLink'],
      );

  Map<String, dynamic> toJson() => {
        "CourseWorkPatternID": courseWorkPatternId,
        "CourseWorkID": courseWorkId,
        "Description": description,
        "Dated": dated.toIso8601String(),
        "TotalMark": totalMark,
        "ActualMark": actualMark,
        'InCompleteExamEligible': inCompleteExamEligible,
        "RubricID": rubricId,
        'PaperDownloadLink': paperDownloadLink
      };
}

class Table1 {
  Table1({
    this.courseCode,
    this.totalGrades,
    this.assessmentName,
    this.weight,
    this.grade,
    this.courseWorkPatternId,
  });

  String courseCode;
  double totalGrades;
  String assessmentName;
  double weight;
  double grade;
  int courseWorkPatternId;

  factory Table1.fromJson(Map<String, dynamic> json) => Table1(
        courseCode: json["CourseCode"],
        totalGrades: json["TotalGrades"],
        assessmentName: json["AssessmentName"],
        weight: json["Weight"],
        grade: json["Grade"],
        courseWorkPatternId: json["CourseWorkPatternID"],
      );

  Map<String, dynamic> toJson() => {
        "CourseCode": courseCode,
        "TotalGrades": totalGrades,
        "AssessmentName": assessmentName,
        "Weight": weight,
        "Grade": grade,
        "CourseWorkPatternID": courseWorkPatternId,
      };
}
