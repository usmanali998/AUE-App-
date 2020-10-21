// To parse this JSON data, do
//
//     final studentRubric = studentRubricFromJson(jsonString);

import 'dart:convert';

StudentRubric studentRubricFromJson(String str) => StudentRubric.fromJson(json.decode(str));

String studentRubricToJson(StudentRubric data) => json.encode(data.toJson());

class StudentRubric {
  StudentRubric({
    this.measurement,
    this.criteria,
    this.cells,
  });

  List<StudentRubricMeasurement> measurement;
  List<StudentRubricCriteria> criteria;
  List<StudentRubricCell> cells;

  factory StudentRubric.fromJson(Map<String, dynamic> json) => StudentRubric(
    measurement: List<StudentRubricMeasurement>.from(json["Measurement"].map((x) => StudentRubricMeasurement.fromJson(x))),
    criteria: List<StudentRubricCriteria>.from(json["Criteria"].map((x) => StudentRubricCriteria.fromJson(x))),
    cells: List<StudentRubricCell>.from(json["Cells"].map((x) => StudentRubricCell.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "Measurement": List<dynamic>.from(measurement.map((x) => x.toJson())),
    "Criteria": List<dynamic>.from(criteria.map((x) => x.toJson())),
    "Cells": List<dynamic>.from(cells.map((x) => x.toJson())),
  };
}

class StudentRubricCell {
  StudentRubricCell({
    this.measurementId,
    this.criteriaId,
    this.description,
    this.isHighlighted,
    this.minScore,
    this.maxScore,
    this.studentScore,
  });

  int measurementId;
  int criteriaId;
  String description;
  bool isHighlighted;
  double minScore;
  double maxScore;
  double studentScore;

  factory StudentRubricCell.fromJson(Map<String, dynamic> json) => StudentRubricCell(
    measurementId: json["MeasurementID"],
    criteriaId: json["CriteriaID"],
    description: json["Description"],
    isHighlighted: json["IsHighlighted"],
    minScore: json["MinScore"].toDouble(),
    maxScore: json["MaxScore"].toDouble(),
    studentScore: json["StudentScore"] == null ? null : json["StudentScore"],
  );

  Map<String, dynamic> toJson() => {
    "MeasurementID": measurementId,
    "CriteriaID": criteriaId,
    "Description": description,
    "IsHighlighted": isHighlighted,
    "MinScore": minScore,
    "MaxScore": maxScore,
    "StudentScore": studentScore == null ? null : studentScore,
  };
}

class StudentRubricCriteria {
  StudentRubricCriteria({
    this.criteriaId,
    this.criteriaHeader,
    this.criteria,
  });

  int criteriaId;
  String criteriaHeader;
  String criteria;
  bool selected = false;

  factory StudentRubricCriteria.fromJson(Map<String, dynamic> json) => StudentRubricCriteria(
    criteriaId: json["CriteriaID"],
    criteriaHeader: json["CriteriaHeader"],
    criteria: json["Criteria"],
  );

  Map<String, dynamic> toJson() => {
    "CriteriaID": criteriaId,
    "CriteriaHeader": criteriaHeader,
    "Criteria": criteria,
  };
}

class StudentRubricMeasurement {
  StudentRubricMeasurement({
    this.measurementId,
    this.measurement,
  });

  int measurementId;
  String measurement;

  factory StudentRubricMeasurement.fromJson(Map<String, dynamic> json) => StudentRubricMeasurement(
    measurementId: json["MeasurementID"],
    measurement: json["Measurement"],
  );

  Map<String, dynamic> toJson() => {
    "MeasurementID": measurementId,
    "Measurement": measurement,
  };
}
