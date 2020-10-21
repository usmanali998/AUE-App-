class ElectiveColleges {
  var collegeId;
  var name;
  var collegeArabicName;

  ElectiveColleges({this.collegeId, this.name, this.collegeArabicName});

  factory ElectiveColleges.fromJson(Map<String, dynamic> parsedJson) {
    return ElectiveColleges(
      collegeId: parsedJson['CollegeID'],
      name: parsedJson['Name'],
      collegeArabicName: parsedJson['CollegeArabicName'],
    );
  }
}

class ElectiveCollegesList {
  List<ElectiveColleges> electiveCollegesList;
  ElectiveCollegesList({this.electiveCollegesList});

  factory ElectiveCollegesList.fromJson(List<dynamic> parsedJson) {
    List<ElectiveColleges> electiveColleges = List<ElectiveColleges>();
    electiveColleges =
        parsedJson.map((e) => ElectiveColleges.fromJson(e)).toList();
    return ElectiveCollegesList(electiveCollegesList: electiveColleges);
  }
}
