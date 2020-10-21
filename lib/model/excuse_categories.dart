// To parse this JSON data, do
//
//     final excuseCategory = excuseCategoryFromJson(jsonString);

import 'dart:convert';

List<ExcuseCategory> excuseCategoryFromJson(String str) => List<ExcuseCategory>.from(json.decode(str).map((x) => ExcuseCategory.fromJson(x)));

String excuseCategoryToJson(List<ExcuseCategory> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ExcuseCategory {
  ExcuseCategory({
    this.id,
    this.name,
  });

  int id;
  String name;

  factory ExcuseCategory.fromJson(Map<String, dynamic> json) => ExcuseCategory(
    id: json["ID"],
    name: json["Name"],
  );

  Map<String, dynamic> toJson() => {
    "ID": id,
    "Name": name,
  };
}
