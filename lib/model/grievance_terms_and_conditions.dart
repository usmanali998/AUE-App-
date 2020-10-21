// To parse this JSON data, do
//
//     final grievanceTermsAndConditions = grievanceTermsAndConditionsFromJson(jsonString);

import 'dart:convert';

List<GrievanceTermsAndConditions> grievanceTermsAndConditionsFromJson(String str) => List<GrievanceTermsAndConditions>.from(json.decode(str).map((x) => GrievanceTermsAndConditions.fromJson(x)));

String grievanceTermsAndConditionsToJson(List<GrievanceTermsAndConditions> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GrievanceTermsAndConditions {
  GrievanceTermsAndConditions({
    this.title,
    this.content,
    this.id,
    this.referenceId,
  });

  String title;
  String content;
  int id;
  dynamic referenceId;

  factory GrievanceTermsAndConditions.fromJson(Map<String, dynamic> json) => GrievanceTermsAndConditions(
    title: json["Title"],
    content: json["Content"],
    id: json["ID"],
    referenceId: json["ReferenceID"],
  );

  Map<String, dynamic> toJson() => {
    "Title": title,
    "Content": content,
    "ID": id,
    "ReferenceID": referenceId,
  };
}
