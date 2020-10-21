// To parse this JSON data, do
//
//     final courseMaterial = courseMaterialFromJson(jsonString);

import 'dart:convert';

List<CourseMaterial> courseMaterialFromJson(String str) => List<CourseMaterial>.from(json.decode(str).map((x) => CourseMaterial.fromJson(x)));

String courseMaterialToJson(List<CourseMaterial> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CourseMaterial {
  CourseMaterial({
    this.weekNo,
    this.materialName,
    this.dateAdded,
    this.viewStartDate,
    this.materialFileName,
    this.downloadLink,
  });

  String weekNo;
  String materialName;
  DateTime dateAdded;
  DateTime viewStartDate;
  String materialFileName;
  String downloadLink;

  factory CourseMaterial.fromJson(Map<String, dynamic> json) => CourseMaterial(
    weekNo: json["WeekNo"],
    materialName: json["MaterialName"],
    dateAdded: DateTime.parse(json["DateAdded"]),
    viewStartDate: DateTime.parse(json["ViewStartDate"]),
    materialFileName: json["MaterialFileName"],
    downloadLink: json["DownloadLink"],
  );

  Map<String, dynamic> toJson() => {
    "WeekNo": weekNo,
    "MaterialName": materialName,
    "DateAdded": dateAdded.toIso8601String(),
    "ViewStartDate": viewStartDate.toIso8601String(),
    "MaterialFileName": materialFileName,
    "DownloadLink": downloadLink,
  };
}
