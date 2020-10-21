// To parse this JSON data, do
//
//     final studyPlan = studyPlanFromJson(jsonString);

import 'dart:convert';

StudyPlan studyPlanFromJson(String str) => StudyPlan.fromJson(json.decode(str));

String studyPlanToJson(StudyPlan data) => json.encode(data.toJson());

class StudyPlan {
  StudyPlan({
    this.courseCategories,
    this.courses,
  });

  List<StudyPlanCourseCategory> courseCategories;
  List<StudyPlanCourse> courses;

  factory StudyPlan.fromJson(Map<String, dynamic> json) => StudyPlan(
    courseCategories: List<StudyPlanCourseCategory>.from(json["CourseCategories"].map((x) => StudyPlanCourseCategory.fromJson(x))),
    courses: List<StudyPlanCourse>.from(json["Courses"].map((x) => StudyPlanCourse.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "CourseCategories": List<dynamic>.from(courseCategories.map((x) => x.toJson())),
    "Courses": List<dynamic>.from(courses.map((x) => x.toJson())),
  };
}

class StudyPlanCourseCategory {
  StudyPlanCourseCategory({
    this.courseCategoryId,
    this.name,
    this.requiredCredits,
    this.completedCredits,
    this.sequence,
  });

  int courseCategoryId;
  String name;
  int requiredCredits;
  int completedCredits;
  int sequence;

  factory StudyPlanCourseCategory.fromJson(Map<String, dynamic> json) => StudyPlanCourseCategory(
    courseCategoryId: json["CourseCategoryID"],
    name: json["Name"],
    requiredCredits: json["RequiredCredits"],
    completedCredits: json["CompletedCredits"],
    sequence: json["Sequence"],
  );

  Map<String, dynamic> toJson() => {
    "CourseCategoryID": courseCategoryId,
    "Name": name,
    "RequiredCredits": requiredCredits,
    "CompletedCredits": completedCredits,
    "Sequence": sequence,
  };
}

class StudyPlanCourse {
  StudyPlanCourse({
    this.courseCategoryId,
    this.group,
    this.groupCreditRequired,
    this.courseCode,
    this.courseName,
    this.courseCreditHours,
    this.courseStatusId,
    this.courseStatus,
    this.grade,
    this.gradeValue,
    this.prerequisite,
  });

  int courseCategoryId;
  String group;
  int groupCreditRequired;
  String courseCode;
  String courseName;
  int courseCreditHours;
  int courseStatusId;
  String courseStatus;
  String grade;
  double gradeValue;
  String prerequisite;

  factory StudyPlanCourse.fromJson(Map<String, dynamic> json) => StudyPlanCourse(
    courseCategoryId: json["CourseCategoryID"],
    group: json["Group"],
    groupCreditRequired: json["GroupCreditRequired"],
    courseCode: json["CourseCode"],
    courseName: json["CourseName"],
    courseCreditHours: json["CourseCreditHours"],
    courseStatusId: json["CourseStatusID"],
    courseStatus: json["CourseStatus"],
    grade: json["Grade"],
    gradeValue: json["GradeValue"],
    prerequisite: json["Prerequisite"],
  );

  Map<String, dynamic> toJson() => {
    "CourseCategoryID": courseCategoryId,
    "Group": group,
    "GroupCreditRequired": groupCreditRequired,
    "CourseCode": courseCode,
    "CourseName": courseName,
    "CourseCreditHours": courseCreditHours,
    "CourseStatusID": courseStatusId,
    "CourseStatus": courseStatus,
    "Grade": grade,
    "GradeValue": gradeValue,
    "Prerequisite": prerequisite,
  };
}
