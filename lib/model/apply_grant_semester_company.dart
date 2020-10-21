// To parse this JSON data, do
//
//     final applyGrantSemesterCompany = applyGrantSemesterCompanyFromJson(jsonString);

import 'dart:convert';

ApplyGrantSemesterCompany applyGrantSemesterCompanyFromJson(String str) => ApplyGrantSemesterCompany.fromJson(json.decode(str));

String applyGrantSemesterCompanyToJson(ApplyGrantSemesterCompany data) => json.encode(data.toJson());

class ApplyGrantSemesterCompany {
  ApplyGrantSemesterCompany({
    this.studentId,
    this.discountTypeId,
    this.subTypeId,
    this.semesterId,
    this.discountPercentage,
    this.companyId,
    this.suggestedCompanyName,
    this.alumniId,
    this.familyStudentId,
    this.attachments,
  });

  String studentId;
  int discountTypeId;
  int subTypeId;
  int semesterId;
  int discountPercentage;
  int companyId;
  String suggestedCompanyName;
  String alumniId;
  String familyStudentId;
  List<Attachment> attachments;

  factory ApplyGrantSemesterCompany.fromJson(Map<String, dynamic> json) => ApplyGrantSemesterCompany(
    studentId: json["StudentID"],
    discountTypeId: json["DiscountTypeID"],
    subTypeId: json["SubTypeID"],
    semesterId: json["SemesterID"],
    discountPercentage: json["DiscountPercentage"],
    companyId: json["CompanyID"],
    suggestedCompanyName: json["SuggestedCompanyName"],
    alumniId: json["AlumniID"],
    familyStudentId: json["FamilyStudentID"],
    attachments: List<Attachment>.from(json["Attachments"].map((x) => Attachment.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "StudentID": studentId,
    "DiscountTypeID": discountTypeId,
    "SubTypeID": subTypeId,
    "SemesterID": semesterId,
    "DiscountPercentage": discountPercentage,
    "CompanyID": companyId,
    "SuggestedCompanyName": suggestedCompanyName,
    "AlumniID": alumniId,
    "FamilyStudentID": familyStudentId,
    "Attachments": List<dynamic>.from(attachments.map((x) => x.toJson())),
  };
}

class Attachment {
  Attachment({
    this.stringValue,
    this.byteValues,
  });

  String stringValue;
  String byteValues;

  factory Attachment.fromJson(Map<String, dynamic> json) => Attachment(
    stringValue: json["StringValue"],
    byteValues: json["ByteValues"],
  );

  Map<String, dynamic> toJson() => {
    "StringValue": stringValue,
    "ByteValues": byteValues,
  };
}
