// To parse this JSON data, do
//
//     final studentGrades = studentGradesFromJson(jsonString);

import 'dart:convert';

StudentGrades studentGradesFromJson(String str) => StudentGrades.fromJson(json.decode(str));

String studentGradesToJson(StudentGrades data) => json.encode(data.toJson());

class StudentGrades {
  StudentGrades({
    this.semesters,
    this.details,
  });

  List<StudentGradesSemester> semesters;
  List<StudentGradesDetail> details;

  factory StudentGrades.fromJson(Map<String, dynamic> json) => StudentGrades(
    semesters: List<StudentGradesSemester>.from(json["Semesters"].map((x) => StudentGradesSemester.fromJson(x))),
    details: List<StudentGradesDetail>.from(json["Details"].map((x) => StudentGradesDetail.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "Semesters": List<dynamic>.from(semesters.map((x) => x.toJson())),
    "Details": List<dynamic>.from(details.map((x) => x.toJson())),
  };
}

class StudentGradesDetail {
  StudentGradesDetail({
    this.semesterId,
    this.courseCode,
    this.courseName,
    this.grade,
    this.gpa,
    this.gradeTotal,
  });

  int semesterId;
  String courseCode;
  String courseName;
  String grade;
  double gpa;
  double gradeTotal;

  factory StudentGradesDetail.fromJson(Map<String, dynamic> json) => StudentGradesDetail(
    semesterId: json["SemesterID"],
    courseCode: json["CourseCode"],
    courseName: json["CourseName"],
    grade: json["Grade"],
    gpa: json["GPA"].toDouble(),
    gradeTotal: json["GradeTotal"] == null ? null : json["GradeTotal"],
  );

  Map<String, dynamic> toJson() => {
    "SemesterID": semesterId,
    "CourseCode": courseCode,
    "CourseName": courseName,
    "Grade": grade,
    "GPA": gpa,
    "GradeTotal": gradeTotal == null ? null : gradeTotal,
  };
}

class StudentGradesSemester {
  StudentGradesSemester({
    this.semesterId,
    this.semesterName,
    this.semesterNameAr,
    this.sgpa,
    this.cgpa,
    this.academicStanding,
  });

  int semesterId;
  String semesterName;
  String semesterNameAr;
  double sgpa;
  double cgpa;
  String academicStanding;

  factory StudentGradesSemester.fromJson(Map<String, dynamic> json) => StudentGradesSemester(
    semesterId: json["SemesterID"],
    semesterName: json["SemesterName"],
    semesterNameAr: json["SemesterNameAR"],
    sgpa: json["SGPA"].toDouble(),
    cgpa: json["CGPA"].toDouble(),
    academicStanding: json["AcademicStanding"],
  );

  Map<String, dynamic> toJson() => {
    "SemesterID": semesterId,
    "SemesterName": semesterName,
    "SemesterNameAR": semesterNameAr,
    "SGPA": sgpa,
    "CGPA": cgpa,
    "AcademicStanding": academicStanding,
  };
}
