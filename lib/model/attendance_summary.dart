// To parse this JSON data, do
//
//     final attendanceSummary = attendanceSummaryFromJson(jsonString);

import 'dart:convert';

AttendanceSummary attendanceSummaryFromJson(String str) => AttendanceSummary.fromJson(json.decode(str));

String attendanceSummaryToJson(AttendanceSummary data) => json.encode(data.toJson());

class AttendanceSummary {
  AttendanceSummary({
    this.studentAttendanceSummary,
    this.rangeSlider,
  });

  List<StudentAttendanceSummary> studentAttendanceSummary;
  List<RangeSlider> rangeSlider;

  factory AttendanceSummary.fromJson(Map<String, dynamic> json) => AttendanceSummary(
    studentAttendanceSummary: List<StudentAttendanceSummary>.from(json["StudentAttendanceSummary"].map((x) => StudentAttendanceSummary.fromJson(x))),
    rangeSlider: List<RangeSlider>.from(json["RangeSlider"].map((x) => RangeSlider.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "StudentAttendanceSummary": List<dynamic>.from(studentAttendanceSummary.map((x) => x.toJson())),
    "RangeSlider": List<dynamic>.from(rangeSlider.map((x) => x.toJson())),
  };
}

class RangeSlider {
  RangeSlider({
    this.levelId,
    this.levelDescription,
    this.hoursMissed,
    this.hoursMissedLabel,
  });

  int levelId;
  String levelDescription;
  double hoursMissed;
  String hoursMissedLabel;

  factory RangeSlider.fromJson(Map<String, dynamic> json) => RangeSlider(
    levelId: json["LevelID"],
    levelDescription: json["LevelDescription"],
    hoursMissed: json["HoursMissed"].toDouble(),
    hoursMissedLabel: json["HoursMissedLabel"],
  );

  Map<String, dynamic> toJson() => {
    "LevelID": levelId,
    "LevelDescription": levelDescription,
    "HoursMissed": hoursMissed,
    "HoursMissedLabel": hoursMissedLabel,
  };
}

class StudentAttendanceSummary {
  StudentAttendanceSummary({
    this.levelId,
    this.hoursMissed,
  });

  int levelId;
  double hoursMissed;

  factory StudentAttendanceSummary.fromJson(Map<String, dynamic> json) => StudentAttendanceSummary(
    levelId: json["LevelID"],
    hoursMissed: json["HoursMissed"],
  );

  Map<String, dynamic> toJson() => {
    "LevelID": levelId,
    "HoursMissed": hoursMissed,
  };
}
