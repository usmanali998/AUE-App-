// To parse this JSON data, do
//
//     final rubricCriteria = rubricCriteriaFromJson(jsonString);

import 'dart:convert';

List<RubricCriteria> rubricCriteriaFromJson(String str) => List<RubricCriteria>.from(json.decode(str).map((x) => RubricCriteria.fromJson(x)));

String rubricCriteriaToJson(List<RubricCriteria> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class RubricCriteria {
  RubricCriteria({
    this.rubricId,
    this.rubricCriteriaId,
    this.criteriaSeq,
    this.criteria,
    this.weight,
    this.detailItemId,
    this.totalMarks,
    this.isArabic,
  });

  int rubricId;
  int rubricCriteriaId;
  int criteriaSeq;
  String criteria;
  dynamic weight;
  dynamic detailItemId;
  dynamic totalMarks;
  bool isArabic;
  bool selected = false;

  factory RubricCriteria.fromJson(Map<String, dynamic> json) => RubricCriteria(
    rubricId: json["RubricID"],
    rubricCriteriaId: json["RubricCriteriaID"],
    criteriaSeq: json["CriteriaSeq"],
    criteria: json["Criteria"],
    weight: json["Weight"],
    detailItemId: json["DetailItemID"],
    totalMarks: json["TotalMarks"],
    isArabic: json["IsArabic"],
  );

  Map<String, dynamic> toJson() => {
    "RubricID": rubricId,
    "RubricCriteriaID": rubricCriteriaId,
    "CriteriaSeq": criteriaSeq,
    "Criteria": criteria,
    "Weight": weight,
    "DetailItemID": detailItemId,
    "TotalMarks": totalMarks,
    "IsArabic": isArabic,
  };
}
