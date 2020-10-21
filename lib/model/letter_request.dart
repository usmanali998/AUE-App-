// To parse this JSON data, do
//
//     final letterRequest = letterRequestFromJson(jsonString);

import 'dart:convert';

List<LetterRequest> letterRequestFromJson(String str) => List<LetterRequest>.from(json.decode(str).map((x) => LetterRequest.fromJson(x)));

String letterRequestToJson(List<LetterRequest> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class LetterRequest {
  LetterRequest({
    this.subject,
    this.dateSubmitted,
    this.statusName,
    this.addressedTo,
  });

  String subject;
  DateTime dateSubmitted;
  String statusName;
  String addressedTo;

  factory LetterRequest.fromJson(Map<String, dynamic> json) => LetterRequest(
    subject: json["Subject"],
    dateSubmitted: DateTime.parse(json["DateSubmitted"]),
    statusName: json["StatusName"],
    addressedTo: json["AddressedTo"],
  );

  Map<String, dynamic> toJson() => {
    "Subject": subject,
    "DateSubmitted": dateSubmitted.toIso8601String(),
    "StatusName": statusName,
    "AddressedTo": addressedTo,
  };
}
