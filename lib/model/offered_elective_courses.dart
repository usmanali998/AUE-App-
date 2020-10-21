class OfferedElectiveCourses {
  var courseCode;
  var courseName;
  var creditHours;

  OfferedElectiveCourses({
    this.courseCode,
    this.courseName,
    this.creditHours,
  });

  factory OfferedElectiveCourses.fromJson(Map<String, dynamic> parsedJson) {
    return OfferedElectiveCourses(
      courseCode: parsedJson['CourseCode'],
      courseName: parsedJson['CourseName'],
      creditHours: parsedJson['CreditHours'],
    );
  }
}

class OfferedElectiveCoursesList {
  List<OfferedElectiveCourses> offeredElectiveCoursesList;
  OfferedElectiveCoursesList({this.offeredElectiveCoursesList});

  factory OfferedElectiveCoursesList.fromJson(List<dynamic> parsedJson) {
    List<OfferedElectiveCourses> offeredElectiveCourses =
        List<OfferedElectiveCourses>();
    offeredElectiveCourses =
        parsedJson.map((e) => OfferedElectiveCourses.fromJson(e)).toList();
    return OfferedElectiveCoursesList(
        offeredElectiveCoursesList: offeredElectiveCourses);
  }
}
