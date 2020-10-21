class CourseCategories {
  var course_category_id;
  String name;
  var required_credits;
  var completed_credits;
  var sequence;

  CourseCategories({
    this.course_category_id,
    this.name,
    this.required_credits,
    this.completed_credits,
    this.sequence,
  });

  factory CourseCategories.fromJson(Map<String, dynamic> parsedJson) {
    return CourseCategories(
      course_category_id: parsedJson['CourseCategoryID'],
      name: parsedJson['Name'],
      required_credits: parsedJson['RequiredCredits'],
      completed_credits: parsedJson['CompletedCredits'],
      sequence: parsedJson['Sequence'],
    );
  }
}

class CourseCategoryList {
  List<CourseCategories> courseCategoryList;
  CourseCategoryList({this.courseCategoryList});

  factory CourseCategoryList.fromJson(List<dynamic> parsedJson) {
    List<CourseCategories> categories = List<CourseCategories>();
    categories = parsedJson.map((e) => CourseCategories.fromJson(e)).toList();
    return CourseCategoryList(courseCategoryList: categories);
  }
}
