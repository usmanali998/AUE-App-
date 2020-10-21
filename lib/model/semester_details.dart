// To parse this JSON data, do
//
//     final semesterDetails = semesterDetailsFromJson(jsonString);

import 'dart:convert';

List<SemesterDetails> semesterDetailsFromJson(String str) => List<SemesterDetails>.from(json.decode(str).map((x) => SemesterDetails.fromJson(x)));

String semesterDetailsToJson(List<SemesterDetails> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SemesterDetails {
  SemesterDetails({
    this.label,
    this.date,
  });

  String label;
  DateTime date;

  factory SemesterDetails.fromJson(Map<String, dynamic> json) => SemesterDetails(
    label: json["Label"],
    date: DateTime.parse(json["Date"]),
  );

  Map<String, dynamic> toJson() => {
    "Label": label,
    "Date": date.toIso8601String(),
  };
}
