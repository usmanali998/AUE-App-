import 'dart:convert';


import 'package:intl/intl.dart';

class Announcement {
  final String subject;
  final String body;
  final DateTime dateCreated;
  final String timeCreated;
  final String department;
  final String code;
  final String message;
  final bool readStatus;
  final int notificationID;
  final List<String> imageList;
  Announcement({
    this.subject,
    this.body,
    this.dateCreated,
    this.timeCreated,
    this.department,
    this.code,
    this.message,
    this.readStatus,
    this.notificationID,
    this.imageList,
  });

  Announcement copyWith({
    String subject,
    String body,
    String dateCreated,
    String timeCreated,
    String department,
    String code,
    String message,
    bool readStatus,
    int notificationID,
    List<String> imageList,
  }) {
    return Announcement(
      subject: subject ?? this.subject,
      body: body ?? this.body,
      dateCreated: dateCreated ?? this.dateCreated,
      timeCreated: timeCreated ?? this.timeCreated,
      department: department ?? this.department,
      code: code ?? this.code,
      message: message ?? this.message,
      readStatus: readStatus ?? this.readStatus,
      notificationID: notificationID ?? this.notificationID,
      imageList: imageList ?? this.imageList,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'subject': subject,
      'body': body,
      'dateCreated': dateCreated,
      'timeCreated': timeCreated,
      'department': department,
      'code': code,
      'message': message,
      'readStatus': readStatus,
      'notificationID': notificationID,
      'imageList': imageList,
    };
  }

  static Announcement fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    final dateString = map["DateCreated"] as String;

    final date = DateFormat("dd/M/yyyy hh:mm:ss a").parse(dateString);

    return Announcement(
      subject: map['Subject'],
      body: map['Body'],
      dateCreated: date,
      timeCreated: map['TimeCreated'],
      department: map['Department'],
      code: map['Code'],
      message: map['Message'],
      readStatus: map['ReadStatus'],
      notificationID: map['NotificationID']?.toInt(),
      imageList: ((map['ImageList'] as List)?.isEmpty) ?? true
          ? []
          : List<String>.from(map['imageList']),
    );
  }

  static List<Announcement> fromMapToList(List<dynamic> list) {
    if (list.isEmpty) return [];

    return list.map((map) => Announcement.fromMap(map)).toList();
  }

  String toJson() => json.encode(toMap());

  static Announcement fromJson(String source) => fromMap(json.decode(source));

  @override
  String toString() {
    return 'Announcement(subject: $subject, body: $body, dateCreated: $dateCreated, timeCreated: $timeCreated, department: $department, code: $code, message: $message, readStatus: $readStatus, notificationID: $notificationID, imageList: $imageList)';
  }
}
