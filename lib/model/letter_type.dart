// To parse this JSON data, do
//
//     final letterType = letterTypeFromJson(jsonString);

import 'dart:convert';

List<LetterType> letterTypeFromJson(String str) => List<LetterType>.from(json.decode(str).map((x) => LetterType.fromJson(x)));

String letterTypeToJson(List<LetterType> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class LetterType {
  LetterType({
    this.id,
    this.name,
    this.pricePerCopy,
  });

  int id;
  String name;
  double pricePerCopy;

  factory LetterType.fromJson(Map<String, dynamic> json) => LetterType(
    id: json["ID"],
    name: json["Name"],
    pricePerCopy: json["PricePerCopy"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "ID": id,
    "Name": name,
    "PricePerCopy": pricePerCopy,
  };
}
