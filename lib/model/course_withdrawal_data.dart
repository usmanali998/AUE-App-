// To parse this JSON data, do
//
//     final courseWithdrawalData = courseWithdrawalDataFromJson(jsonString);

import 'dart:convert';

CourseWithdrawalData courseWithdrawalDataFromJson(String str) => CourseWithdrawalData.fromJson(json.decode(str));

String courseWithdrawalDataToJson(CourseWithdrawalData data) => json.encode(data.toJson());

class CourseWithdrawalData {
  CourseWithdrawalData({
    this.grade,
    this.refundPercentage,
    this.disclaimerTitle,
    this.disclaimerContent,
  });

  String grade;
  double refundPercentage;
  String disclaimerTitle;
  String disclaimerContent;

  factory CourseWithdrawalData.fromJson(Map<String, dynamic> json) => CourseWithdrawalData(
    grade: json["Grade"],
    refundPercentage: json["RefundPercentage"],
    disclaimerTitle: json["DisclaimerTitle"],
    disclaimerContent: json["DisclaimerContent"],
  );

  Map<String, dynamic> toJson() => {
    "Grade": grade,
    "RefundPercentage": refundPercentage,
    "DisclaimerTitle": disclaimerTitle,
    "DisclaimerContent": disclaimerContent,
  };
}
