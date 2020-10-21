// To parse this JSON data, do
//
//     final grievanceHistory = grievanceHistoryFromJson(jsonString);

import 'dart:convert';

List<GrievanceHistory> grievanceHistoryFromJson(String str) => List<GrievanceHistory>.from(json.decode(str).map((x) => GrievanceHistory.fromJson(x)));

String grievanceHistoryToJson(List<GrievanceHistory> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GrievanceHistory {
  GrievanceHistory({
    this.referenceCode,
    this.categoryName,
    this.submittedDate,
    this.grievanceStatus,
  });

  String referenceCode;
  String categoryName;
  String submittedDate;
  String grievanceStatus;

  factory GrievanceHistory.fromJson(Map<String, dynamic> json) => GrievanceHistory(
    referenceCode: json["Referencecode"],
    categoryName: json["CategoryName"],
    submittedDate: json["SubmittedDate"],
    grievanceStatus: json["GrievanceStatus"],
  );

  Map<String, dynamic> toJson() => {
    "Referencecode": referenceCode,
    "CategoryName": categoryName,
    "SubmittedDate": submittedDate,
    "GrievanceStatus": grievanceStatus,
  };
}
