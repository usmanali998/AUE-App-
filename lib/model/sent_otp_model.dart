// To parse this JSON data, do
//
//     final sentOtpModel = sentOtpModelFromJson(jsonString);

import 'dart:convert';

SentOtpModel sentOtpModelFromJson(String str) => SentOtpModel.fromJson(json.decode(str));

String sentOtpModelToJson(SentOtpModel data) => json.encode(data.toJson());

class SentOtpModel {
  SentOtpModel({
    this.table,
  });

  List<Table> table;

  factory SentOtpModel.fromJson(Map<String, dynamic> json) => SentOtpModel(
    table: List<Table>.from(json["Table"].map((x) => Table.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "Table": List<dynamic>.from(table.map((x) => x.toJson())),
  };
}

class Table {
  Table({
    this.studentId,
    this.sentOtp,
    this.sentDttm,
    this.isOtpVerified,
    this.verifiedDttm,
  });

  String studentId;
  String sentOtp;
  DateTime sentDttm;
  bool isOtpVerified;
  DateTime verifiedDttm;

  factory Table.fromJson(Map<String, dynamic> json) => Table(
    studentId: json["StudentID"],
    sentOtp: json["SentOTP"],
    sentDttm: json['SentDTTM'] == null ? null : DateTime.parse(json["SentDTTM"]),
    isOtpVerified: json["IsOTPVerified"],
    verifiedDttm: json['VerifiedDTTM'] == null ? null : DateTime.parse(json["VerifiedDTTM"]),
  );

  Map<String, dynamic> toJson() => {
    "StudentID": studentId,
    "SentOTP": sentOtp,
    "SentDTTM": sentDttm.toIso8601String(),
    "IsOTPVerified": isOtpVerified,
    "VerifiedDTTM": verifiedDttm.toIso8601String(),
  };
}
