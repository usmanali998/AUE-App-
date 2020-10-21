// To parse this JSON data, do
//
//     final notification = notificationFromJson(jsonString);

import 'dart:convert';

List<NotificationModel> notificationFromJson(String str) => List<NotificationModel>.from(json.decode(str).map((x) => NotificationModel.fromJson(x)));

String notificationToJson(List<NotificationModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class NotificationModel {
  NotificationModel({
    this.id,
    this.subject,
    this.body,
    this.notificationDate,
  });

  int id;
  String subject;
  String body;
  DateTime notificationDate;

  factory NotificationModel.fromJson(Map<String, dynamic> json) => NotificationModel(
    id: json["ID"],
    subject: json["Subject"],
    body: json["Body"],
    notificationDate: DateTime.parse(json["NotificationDate"]),
  );

  Map<String, dynamic> toJson() => {
    "ID": id,
    "Subject": subject,
    "Body": body,
    "NotificationDate": notificationDate.toIso8601String(),
  };
}
