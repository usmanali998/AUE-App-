// To parse this JSON data, do
//
//     final rubricMeasurement = rubricMeasurementFromJson(jsonString);

import 'dart:convert';

List<RubricMeasurement> rubricMeasurementFromJson(String str) => List<RubricMeasurement>.from(json.decode(str).map((x) => RubricMeasurement.fromJson(x)));

String rubricMeasurementToJson(List<RubricMeasurement> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class RubricMeasurement {
  RubricMeasurement({
    this.rubricId,
    this.rubricMeasurementId,
    this.measurementSeq,
    this.measurement,
    this.percentage,
    this.isArabic,
  });

  int rubricId;
  int rubricMeasurementId;
  int measurementSeq;
  String measurement;
  double percentage;
  bool isArabic;

  factory RubricMeasurement.fromJson(Map<String, dynamic> json) => RubricMeasurement(
    rubricId: json["RubricID"],
    rubricMeasurementId: json["RubricMeasurementID"],
    measurementSeq: json["MeasurementSeq"],
    measurement: json["Measurement"],
    percentage: json["Percentage"],
    isArabic: json["IsArabic"],
  );

  Map<String, dynamic> toJson() => {
    "RubricID": rubricId,
    "RubricMeasurementID": rubricMeasurementId,
    "MeasurementSeq": measurementSeq,
    "Measurement": measurement,
    "Percentage": percentage,
    "IsArabic": isArabic,
  };
}
