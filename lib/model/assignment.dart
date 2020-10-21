// To parse this JSON data, do
//
//     final assignment = assignmentFromJson(jsonString);

import 'dart:convert';

List<Assignment> assignmentFromJson(String str) => List<Assignment>.from(json.decode(str).map((x) => Assignment.fromJson(x)));

String assignmentToJson(List<Assignment> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Assignment {
  Assignment({
    this.assignmentId,
    this.datePosted,
    this.endDate,
    this.description,
    this.turnitinAssignmentId,
    this.attachmentPath,
    this.studentAssignmentId,
    this.submittedAssignmentPath,
    this.canSubmit,
    this.canDelete,
    this.turnitinSubmissionLink,
    this.attachmentName,
    this.submittedAssignmentName,
    this.submittedAssignmentByte,
    this.attachmentByte,
  });

  int assignmentId;
  DateTime datePosted;
  DateTime endDate;
  String description;
  String turnitinAssignmentId;
  String attachmentPath;
  int studentAssignmentId;
  String submittedAssignmentPath;
  bool canSubmit;
  bool canDelete;
  String turnitinSubmissionLink;
  String attachmentName;
  String submittedAssignmentName;
  String submittedAssignmentByte;
  String attachmentByte;

  factory Assignment.fromJson(Map<String, dynamic> json) => Assignment(
    assignmentId: json["AssignmentID"],
    datePosted: DateTime.parse(json["DatePosted"]),
    endDate: DateTime.parse(json["EndDate"]),
    description: json["Description"],
    turnitinAssignmentId: json["TurnitinAssignmentID"],
    attachmentPath: json["AttachmentPath"],
    studentAssignmentId: json["StudentAssignmentID"],
    submittedAssignmentPath: json["SubmittedAssignmentPath"],
    canSubmit: json["CanSubmit"],
    canDelete: json["CanDelete"],
    turnitinSubmissionLink: json["TurnitinSubmissionLink"],
    attachmentName: json["AttachmentName"],
    submittedAssignmentName: json["SubmittedAssignmentName"],
    submittedAssignmentByte: json["SubmittedAssignmentByte"],
    attachmentByte: json["AttachmentByte"],
  );

  Map<String, dynamic> toJson() => {
    "AssignmentID": assignmentId,
    "DatePosted": datePosted.toIso8601String(),
    "EndDate": endDate.toIso8601String(),
    "Description": description,
    "TurnitinAssignmentID": turnitinAssignmentId,
    "AttachmentPath": attachmentPath,
    "StudentAssignmentID": studentAssignmentId,
    "SubmittedAssignmentPath": submittedAssignmentPath,
    "CanSubmit": canSubmit,
    "CanDelete": canDelete,
    "TurnitinSubmissionLink": turnitinSubmissionLink,
    "AttachmentName": attachmentName,
    "SubmittedAssignmentName": submittedAssignmentName,
    "SubmittedAssignmentByte": submittedAssignmentByte,
    "AttachmentByte": attachmentByte,
  };
}
