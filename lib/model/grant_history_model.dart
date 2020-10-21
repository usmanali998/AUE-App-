// To parse this JSON data, do
//
//     final grantHistory = grantHistoryFromJson(jsonString);

import 'dart:convert';

List<GrantHistory> grantHistoryFromJson(String str) => List<GrantHistory>.from(json.decode(str).map((x) => GrantHistory.fromJson(x)));

String grantHistoryToJson(List<GrantHistory> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GrantHistory {
  GrantHistory({
    this.semesterName,
    this.dateRequested,
    this.corporateName,
    this.requestStatus,
    this.reason,
    this.discountTypeName,
    this.discountPercentage,
  });

  String semesterName;
  DateTime dateRequested;
  dynamic corporateName;
  String requestStatus;
  String reason;
  String discountTypeName;
  int discountPercentage;

  factory GrantHistory.fromJson(Map<String, dynamic> json) => GrantHistory(
    semesterName: json["SemesterName"],
    dateRequested: DateTime.parse(json["DateRequested"]),
    corporateName: json["CorporateName"],
    requestStatus: json["RequestStatus"],
    reason: json["Reason"],
    discountTypeName: json["DiscountTypeName"],
    discountPercentage: json["DiscountPercentage"],
  );

  Map<String, dynamic> toJson() => {
    "SemesterName": semesterName,
    "DateRequested": dateRequested.toIso8601String(),
    "CorporateName": corporateName,
    "RequestStatus": requestStatus,
    "Reason": reason,
    "DiscountTypeName": discountTypeName,
    "DiscountPercentage": discountPercentage,
  };
}
