// To parse this JSON data, do
//
//     final rubricDescriptor = rubricDescriptorFromJson(jsonString);

import 'dart:convert';

List<RubricDescriptor> rubricDescriptorFromJson(String str) => List<RubricDescriptor>.from(json.decode(str).map((x) => RubricDescriptor.fromJson(x)));

String rubricDescriptorToJson(List<RubricDescriptor> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class RubricDescriptor {
  RubricDescriptor({
    this.rubricDescriptorId,
    this.rubricCriteriaId,
    this.rubricMeasurementId,
    this.descriptor,
    this.measurementSeq,
    this.minMark,
    this.maxMark,
    this.markRange,
  });

  int rubricDescriptorId;
  int rubricCriteriaId;
  int rubricMeasurementId;
  String descriptor;
  int measurementSeq;
  double minMark;
  double maxMark;
  String markRange;

  factory RubricDescriptor.fromJson(Map<String, dynamic> json) => RubricDescriptor(
    rubricDescriptorId: json["RubricDescriptorID"],
    rubricCriteriaId: json["RubricCriteriaID"],
    rubricMeasurementId: json["RubricMeasurementID"],
    descriptor: json["Descriptor"],
    measurementSeq: json["MeasurementSeq"],
    minMark: json["MinMark"],
    maxMark: json["MaxMark"],
    markRange: json["MarkRange"],
  );

  Map<String, dynamic> toJson() => {
    "RubricDescriptorID": rubricDescriptorId,
    "RubricCriteriaID": rubricCriteriaId,
    "RubricMeasurementID": rubricMeasurementId,
    "Descriptor": descriptor,
    "MeasurementSeq": measurementSeq,
    "MinMark": minMark,
    "MaxMark": maxMark,
    "MarkRange": markRange,
  };
}
