// To parse this JSON data, do
//
//     final courseOutline = courseOutlineFromJson(jsonString);

import 'dart:convert';

List<CourseOutline> courseOutlineFromJson(String str) => List<CourseOutline>.from(json.decode(str).map((x) => CourseOutline.fromJson(x)));

String courseOutlineToJson(List<CourseOutline> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CourseOutline {
  CourseOutline({
    this.week,
    this.topics,
    this.delivery,
    this.readingMaterials,
  });

  String week;
  String topics;
  String delivery;
  String readingMaterials;

  factory CourseOutline.fromJson(Map<String, dynamic> json) => CourseOutline(
    week: json["Week"],
    topics: json["Topics"],
    delivery: json["Delivery"],
    readingMaterials: json["ReadingMaterials"],
  );

  Map<String, dynamic> toJson() => {
    "Week": week,
    "Topics": topics,
    "Delivery": delivery,
    "ReadingMaterials": readingMaterials,
  };
}
