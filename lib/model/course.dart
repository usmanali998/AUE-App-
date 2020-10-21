import 'dart:convert';

class Course {
  final String courseCode;
  final String courseName;
  final int creditHours;
  final bool graded;
  final bool lab;
  final int courseID;
  final int coursePrice;
  final int sectionID;
  Course({
    this.courseCode,
    this.courseName,
    this.creditHours,
    this.graded,
    this.lab,
    this.courseID,
    this.coursePrice,
    this.sectionID,
  });

  Course copyWith({
    String courseCode,
    String courseName,
    int creditHours,
    bool graded,
    bool lab,
    int courseID,
    int coursePrice,
    int sectionID,
  }) {
    return Course(
      courseCode: courseCode ?? this.courseCode,
      courseName: courseName ?? this.courseName,
      creditHours: creditHours ?? this.creditHours,
      graded: graded ?? this.graded,
      lab: lab ?? this.lab,
      courseID: courseID ?? this.courseID,
      coursePrice: coursePrice ?? this.coursePrice,
      sectionID: sectionID ?? this.sectionID,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'CourseCode': courseCode,
      'CourseName': courseName,
      'CreditHours': creditHours,
      'Graded': graded,
      'Lab': lab,
      'CourseID': courseID,
      'CoursePrice': coursePrice,
      'SectionID': sectionID,
    };
  }

  static Course fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Course(
      courseCode: map['CourseCode'],
      courseName: map['CourseName'],
      creditHours: map['CreditHours']?.toInt(),
      graded: map['Graded'],
      lab: map['Lab'],
      courseID: map['CourseID']?.toInt(),
      coursePrice: map['CoursePrice']?.toInt(),
      sectionID: map['SectionID']?.toInt(),
    );
  }

  static List<Course> fromMapToList(List<dynamic> list) {
    if (list.isEmpty) return [];

    return list.map((map) => Course.fromMap(map)).toList();
  }

  String toJson() => json.encode(toMap());

  static Course fromJson(String source) => fromMap(json.decode(source));

  @override
  String toString() {
    return 'Course(CourseCode: $courseCode, CourseName: $courseName, CreditHours: $creditHours, Graded: $graded, Lab: $lab, CourseID: $courseID, CoursePrice: $coursePrice, SectionID: $sectionID)';
  }
}
