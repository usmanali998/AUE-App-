import 'dart:convert';

class CurrentSemester {
  final String semesterID;
  final String semesterName;
  final String startDate;
  final String endDate;
  final int year;
  CurrentSemester({
    this.semesterID,
    this.semesterName,
    this.startDate,
    this.endDate,
    this.year,
  });

  CurrentSemester copyWith({
    String semesterID,
    String semesterName,
    String startDate,
    String endDate,
    int year,
  }) {
    return CurrentSemester(
      semesterID: semesterID ?? this.semesterID,
      semesterName: semesterName ?? this.semesterName,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      year: year ?? this.year,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'SemesterID': semesterID,
      'SemesterName': semesterName,
      'StartDate': startDate,
      'EndDate': endDate,
      'Year': year,
    };
  }

  static CurrentSemester fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return CurrentSemester(
      semesterID: map['SemesterID'],
      semesterName: map['SemesterName'],
      startDate: map['StartDate'],
      endDate: map['EndDate'],
      year: map['Year']?.toInt(),
    );
  }

  String toJson() => json.encode(toMap());

  static CurrentSemester fromJson(String source) => fromMap(json.decode(source));

  @override
  String toString() {
    return 'CurrentSemester(SemesterID: $semesterID, SemesterName: $semesterName, StartDate: $startDate, EndDate: $endDate, Year: $year)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is CurrentSemester &&
        o.semesterID == semesterID &&
        o.semesterName == semesterName &&
        o.startDate == startDate &&
        o.endDate == endDate &&
        o.year == year;
  }

  @override
  int get hashCode {
    return semesterID.hashCode ^
        semesterName.hashCode ^
        startDate.hashCode ^
        endDate.hashCode ^
        year.hashCode;
  }
}
