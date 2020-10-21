class CourseTiming {
  var sectionId;
  var sectionCode;
  var sunday;
  var monday;
  var tuesday;
  var wednesday;
  var thursday;
  var friday;
  var saturday;
  var faculty;
  var imageThumbnail;

  CourseTiming({
    this.sectionId,
    this.sectionCode,
    this.sunday,
    this.monday,
    this.tuesday,
    this.wednesday,
    this.thursday,
    this.friday,
    this.saturday,
    this.faculty,
    this.imageThumbnail,
  });

//   ElectiveColleges({this.collegeId, this.name, this.collegeArabicName});

  factory CourseTiming.fromJsonn(Map<String, dynamic> parsedJson) {
    return CourseTiming(
      sectionId: parsedJson['SectionID'],
      sectionCode: parsedJson['SectionCode'],
      sunday: parsedJson['Sunday'],
      monday: parsedJson['Monday'],
      tuesday: parsedJson['Tuesday'],
      wednesday: parsedJson['Wednesday'],
      thursday: parsedJson['Thursday'],
      friday: parsedJson['Friday'],
      saturday: parsedJson['Saturday'],
      faculty: parsedJson['Faculty'],
      imageThumbnail: parsedJson['ImageThumbnail'],
    );
  }
}

class CourseTimingList {
  List<CourseTiming> courseTimingList;
  CourseTimingList({this.courseTimingList});

  factory CourseTimingList.fromJson(List<dynamic> parsedJson) {
    List<CourseTiming> courseTimings = List<CourseTiming>();

    courseTimings = parsedJson.map((e) => CourseTiming.fromJsonn(e)).toList();

    return CourseTimingList(courseTimingList: courseTimings);
  }
}
