// To parse this JSON data, do
//
//     final whatsAppContact = whatsAppContactFromJson(jsonString);

import 'dart:convert';

List<WhatsAppContact> whatsAppContactFromJson(String str) =>
    List<WhatsAppContact>.from(
        json.decode(str).map((x) => WhatsAppContact.fromJson(x)));

String whatsAppContactToJson(List<WhatsAppContact> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class WhatsAppContact {
  WhatsAppContact({
    this.nameEn,
    this.nameAr,
    this.purposeEn,
    this.purposeAr,
    this.number,
    this.icon,
  });

  String nameEn;
  String nameAr;
  String purposeEn;
  String purposeAr;
  String number;
  String icon;

  factory WhatsAppContact.fromJson(Map<String, dynamic> json) =>
      WhatsAppContact(
        nameEn: json["NameEN"],
        nameAr: json["NameAR"],
        purposeEn: json["PurposeEN"],
        purposeAr: json["PurposeAR"],
        number: json["Number"],
        icon: json["Icon"],
      );

  Map<String, dynamic> toJson() => {
        "NameEN": nameEn,
        "NameAR": nameAr,
        "PurposeEN": purposeEn,
        "PurposeAR": purposeAr,
        "Number": number,
        "Icon": icon,
      };
}
