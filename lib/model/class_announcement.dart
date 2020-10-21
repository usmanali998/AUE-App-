// To parse this JSON data, do
//
//     final classAnnouncements = classAnnouncementsFromJson(jsonString);

import 'dart:convert';

List<ClassAnnouncement> classAnnouncementsFromJson(String str) => List<ClassAnnouncement>.from(json.decode(str).map((x) => ClassAnnouncement.fromJson(x)));

String classAnnouncementsToJson(List<ClassAnnouncement> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ClassAnnouncement {
  ClassAnnouncement({
    this.actionDate,
    this.message,
    this.postedByName,
    this.postedByImage,
  });

  DateTime actionDate;
  String message;
  String postedByName;
  String postedByImage;

  factory ClassAnnouncement.fromJson(Map<String, dynamic> json) => ClassAnnouncement(
    actionDate: DateTime.parse(json["ActionDate"]),
    message: json["Message"],
    postedByName: json["PostedByName"],
    postedByImage: json["PostedByImage"],
  );

  Map<String, dynamic> toJson() => {
    "ActionDate": actionDate.toIso8601String(),
    "Message": message,
    "PostedByName": postedByName,
    "PostedByImage": postedByImage,
  };
}
