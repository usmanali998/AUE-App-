// To parse this JSON data, do
//
//     final grievanceAcademicForm = grievanceAcademicFormFromJson(jsonString);

import 'dart:convert';

GrievanceAcademicForm grievanceAcademicFormFromJson(String str) => GrievanceAcademicForm.fromJson(json.decode(str));

String grievanceAcademicFormToJson(GrievanceAcademicForm data) => json.encode(data.toJson());

class GrievanceAcademicForm {
  GrievanceAcademicForm({
    this.category,
    this.courses,
    this.courseMarks,
    this.communicatedTo,
    this.academicAdvisor,
    this.coordinators,
  });

  List<GrievanceAcademicCategory> category;
  List<GrievanceAcademicCourse> courses;
  List<GrievanceAcademicCourseMark> courseMarks;
  List<GrievanceAcademicCommunicatedTo> communicatedTo;
  List<GrievanceAcademicAcademicAdvisor> academicAdvisor;
  List<GrievanceAcademicCoordinator> coordinators;

  factory GrievanceAcademicForm.fromJson(Map<String, dynamic> json) => GrievanceAcademicForm(
    category: List<GrievanceAcademicCategory>.from(json["Category"].map((x) => GrievanceAcademicCategory.fromJson(x))),
    courses: List<GrievanceAcademicCourse>.from(json["Courses"].map((x) => GrievanceAcademicCourse.fromJson(x))),
    courseMarks: List<GrievanceAcademicCourseMark>.from(json["CourseMarks"].map((x) => GrievanceAcademicCourseMark.fromJson(x))),
    communicatedTo: List<GrievanceAcademicCommunicatedTo>.from(json["CommunicatedTo"].map((x) => GrievanceAcademicCommunicatedTo.fromJson(x))),
    academicAdvisor: List<GrievanceAcademicAcademicAdvisor>.from(json["AcademicAdvisor"].map((x) => GrievanceAcademicAcademicAdvisor.fromJson(x))),
    coordinators: List<GrievanceAcademicCoordinator>.from(json["Coordinators"].map((x) => GrievanceAcademicCoordinator.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "Category": List<dynamic>.from(category.map((x) => x.toJson())),
    "Courses": List<dynamic>.from(courses.map((x) => x.toJson())),
    "CourseMarks": List<dynamic>.from(courseMarks.map((x) => x.toJson())),
    "CommunicatedTo": List<dynamic>.from(communicatedTo.map((x) => x.toJson())),
    "AcademicAdvisor": List<dynamic>.from(academicAdvisor.map((x) => x.toJson())),
    "Coordinators": List<dynamic>.from(coordinators.map((x) => x.toJson())),
  };
}

class GrievanceAcademicAcademicAdvisor {
  GrievanceAcademicAcademicAdvisor({
    this.employeeId,
    this.name,
    this.advisorImage,
  });

  String employeeId;
  String name;
  String advisorImage;

  factory GrievanceAcademicAcademicAdvisor.fromJson(Map<String, dynamic> json) => GrievanceAcademicAcademicAdvisor(
    employeeId: json["EmployeeID"],
    name: json["Name"],
    advisorImage: json["AdvisorImage"],
  );

  Map<String, dynamic> toJson() => {
    "EmployeeID": employeeId,
    "Name": name,
    "AdvisorImage": advisorImage,
  };
}

class GrievanceAcademicCategory {
  GrievanceAcademicCategory({
    this.id,
    this.name,
    this.description,
  });

  int id;
  String name;
  String description;

  factory GrievanceAcademicCategory.fromJson(Map<String, dynamic> json) => GrievanceAcademicCategory(
    id: json["ID"],
    name: json["Name"],
    description: json["Description"],
  );

  Map<String, dynamic> toJson() => {
    "ID": id,
    "Name": name,
    "Description": description,
  };
}

class GrievanceAcademicCommunicatedTo {
  GrievanceAcademicCommunicatedTo({
    this.id,
    this.name,
  });

  int id;
  String name;

  factory GrievanceAcademicCommunicatedTo.fromJson(Map<String, dynamic> json) => GrievanceAcademicCommunicatedTo(
    id: json["ID"],
    name: json["Name"],
  );

  Map<String, dynamic> toJson() => {
    "ID": id,
    "Name": name,
  };
}

class GrievanceAcademicCoordinator {
  GrievanceAcademicCoordinator({
    this.employeeId,
    this.name,
  });

  String employeeId;
  String name;

  factory GrievanceAcademicCoordinator.fromJson(Map<String, dynamic> json) => GrievanceAcademicCoordinator(
    employeeId: json["EmployeeID"],
    name: json["Name"],
  );

  Map<String, dynamic> toJson() => {
    "EmployeeID": employeeId,
    "Name": name,
  };
}

class GrievanceAcademicCourseMark {
  GrievanceAcademicCourseMark({
    this.courseWorkId,
    this.name,
    this.achievedMarks,
    this.totalMarks,
    this.sectionId,
    this.courseId,
  });

  int courseWorkId;
  String name;
  double achievedMarks;
  double totalMarks;
  int sectionId;
  int courseId;

  factory GrievanceAcademicCourseMark.fromJson(Map<String, dynamic> json) => GrievanceAcademicCourseMark(
    courseWorkId: json["CourseWorkID"],
    name: json["Name"],
    achievedMarks: json["AchievedMarks"],
    totalMarks: json["TotalMarks"],
    sectionId: json["SectionID"],
    courseId: json["CourseID"],
  );

  Map<String, dynamic> toJson() => {
    "CourseWorkID": courseWorkId,
    "Name": name,
    "AchievedMarks": achievedMarks,
    "TotalMarks": totalMarks,
    "SectionID": sectionId,
    "CourseID": courseId,
  };
}

class GrievanceAcademicCourse {
  GrievanceAcademicCourse({
    this.sectionId,
    this.courseCode,
    this.courseName,
    this.faculty,
    this.facultyId,
    this.courseId,
    this.facultyImage,
    this.deanId,
    this.dean,
    this.deanImage,
  });

  int sectionId;
  String courseCode;
  String courseName;
  String faculty;
  String facultyId;
  int courseId;
  String facultyImage;
  String deanId;
  String dean;
  String deanImage;

  factory GrievanceAcademicCourse.fromJson(Map<String, dynamic> json) => GrievanceAcademicCourse(
    sectionId: json["SectionID"],
    courseCode: json["CourseCode"],
    courseName: json["CourseName"],
    faculty: json["Faculty"],
    facultyId: json["FacultyID"],
    courseId: json["CourseID"],
    facultyImage: json["FacultyImage"],
    deanId: json["DeanID"],
    dean: json["Dean"],
    deanImage: json["DeanImage"],
  );

  Map<String, dynamic> toJson() => {
    "SectionID": sectionId,
    "CourseCode": courseCode,
    "CourseName": courseName,
    "Faculty": faculty,
    "FacultyID": facultyId,
    "CourseID": courseId,
    "FacultyImage": facultyImage,
    "DeanID": deanId,
    "Dean": dean,
    "DeanImage": deanImage,
  };
}
