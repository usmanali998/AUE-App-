// To parse this JSON data, do
//
//     final classUpdate = classUpdateFromJson(jsonString);

import 'dart:convert';

List<ClassUpdate> classUpdatesFromJson(String str) => List<ClassUpdate>.from(json.decode(str).map((x) => ClassUpdate.fromJson(x)));

String classUpdatesToJson(List<ClassUpdate> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ClassUpdate {
  ClassUpdate({
    this.message,
    this.senderId,
    this.sender,
    this.category,
    this.sectionId,
    this.sectionCode,
    this.actionDate,
  });

  String message;
  String senderId;
  String sender;
  String category;
  int sectionId;
  String sectionCode;
  DateTime actionDate;

  factory ClassUpdate.fromJson(Map<String, dynamic> json) => ClassUpdate(
    message: json["Message"],
    senderId: json["SenderID"],
    sender: json["Sender"],
    category: json["Category"],
    sectionId: json["SectionID"],
    sectionCode: json["SectionCode"],
    actionDate: DateTime.parse(json["ActionDate"]),
  );

  Map<String, dynamic> toJson() => {
    "Message": message,
    "SenderID": senderId,
    "Sender": sender,
    "Category": category,
    "SectionID": sectionId,
    "SectionCode": sectionCode,
    "ActionDate": actionDate.toIso8601String(),
  };
}
