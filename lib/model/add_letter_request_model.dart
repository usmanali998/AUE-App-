// To parse this JSON data, do
//
//     final addLetterRequestModel = addLetterRequestModelFromJson(jsonString);

import 'dart:convert';

AddLetterRequestModel addLetterRequestModelFromJson(String str) => AddLetterRequestModel.fromJson(json.decode(str));

String addLetterRequestModelToJson(AddLetterRequestModel data) => json.encode(data.toJson());

class AddLetterRequestModel {
  AddLetterRequestModel({
    this.studentId,
    this.language,
    this.typeId,
    this.subject,
    this.addressedTo,
    this.comments,
    this.copies,
  });

  String studentId;
  int language;
  int typeId;
  String subject;
  String addressedTo;
  String comments;
  int copies;

  factory AddLetterRequestModel.fromJson(Map<String, dynamic> json) => AddLetterRequestModel(
    studentId: json["StudentID"],
    language: json["Language"],
    typeId: json["TypeID"],
    subject: json["Subject"],
    addressedTo: json["AddressedTo"],
    comments: json["Comments"],
    copies: json["Copies"],
  );

  Map<String, dynamic> toJson() => {
    "StudentID": studentId,
    "Language": language,
    "TypeID": typeId,
    "Subject": subject,
    "AddressedTo": addressedTo,
    "Comments": comments,
    "Copies": copies,
  };
}
