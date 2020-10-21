import 'package:aue/widgets/custom_widgets.dart';
import 'package:flutter/cupertino.dart';

class CoreCoursesObj {
  var courseCode;
  String courseName;
  String name;
  var courseCreditHours;
  String groupHeader;

  CoreCoursesObj({
    this.courseCode,
    this.courseName,
    this.name,
    this.courseCreditHours,
    this.groupHeader,
  });

  factory CoreCoursesObj.fromJson(Map<String, dynamic> parsedJson) {
    return CoreCoursesObj(
      courseCode: parsedJson['CourseCode'],
      courseName: parsedJson['CourseName'],
      courseCreditHours: parsedJson['CourseCreditHours'],
      name: parsedJson['Name'],
      groupHeader: parsedJson['GroupHeader'],
    );
  }
}

class CoreCoursesList {
  List<CoreCoursesObj> coreCoursesList;
  CoreCoursesList({this.coreCoursesList});

  factory CoreCoursesList.fromJson(List<dynamic> parsedJson) {
    List<CoreCoursesObj> coreCourses = List<CoreCoursesObj>();
    coreCourses = parsedJson.map((e) => CoreCoursesObj.fromJson(e)).toList();
    return CoreCoursesList(coreCoursesList: coreCourses);
  }
}

class SelectedCourseObj {
  var courseCode;
  String courseName;
  String name;
  var courseCreditHours;
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

  SelectedCourseObj({
    this.courseCode,
    this.courseName,
    this.name,
    this.courseCreditHours,
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
}

class Cart with ChangeNotifier {
  List<SelectedCourseObj> itemList = [];

  void addItem({
    var courseCode,
    var name,
    var courseName,
    var courseCreditHour,
    var sectionId,
    var sectionCode,
    var sun,
    var mon,
    var tue,
    var wed,
    var thu,
    var fri,
    var sat,
    var faculty,
    var imageThumbnail,
  }) {
    itemList.add(
      SelectedCourseObj(
        courseCode: courseCode,
        name: name,
        courseName: courseName,
        courseCreditHours: courseCreditHour,
        sectionId: sectionId,
        sectionCode: sectionCode,
        sunday: sun,
        monday: mon,
        tuesday: tue,
        wednesday: wed,
        thursday: thu,
        friday: fri,
        saturday: sat,
        faculty: faculty,
        imageThumbnail: imageThumbnail,
      ),
    );

    notifyListeners();
  }

  void removeItem(int index) {
    itemList.removeAt(index);

    notifyListeners();
  }
}
