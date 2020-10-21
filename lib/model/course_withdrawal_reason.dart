// To parse this JSON data, do
//
//     final courseWithdrawalReason = courseWithdrawalReasonFromJson(jsonString);

import 'dart:convert';

List<CourseWithdrawalReason> courseWithdrawalReasonFromJson(String str) => List<CourseWithdrawalReason>.from(json.decode(str).map((x) => CourseWithdrawalReason.fromJson(x)));

String courseWithdrawalReasonToJson(List<CourseWithdrawalReason> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CourseWithdrawalReason {
  CourseWithdrawalReason({
    this.id,
    this.reasonTypeEn,
    this.reasonTypeAr,
  });

  int id;
  String reasonTypeEn;
  String reasonTypeAr;

  factory CourseWithdrawalReason.fromJson(Map<String, dynamic> json) => CourseWithdrawalReason(
    id: json["ID"],
    reasonTypeEn: json["ReasonTypeEN"],
    reasonTypeAr: json["ReasonTypeAR"],
  );

  Map<String, dynamic> toJson() => {
    "ID": id,
    "ReasonTypeEN": reasonTypeEn,
    "ReasonTypeAR": reasonTypeAr,
  };
}
