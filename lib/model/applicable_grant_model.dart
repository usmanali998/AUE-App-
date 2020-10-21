// To parse this JSON data, do
//
//     final applicableGrant = applicableGrantFromJson(jsonString);

import 'dart:convert';

List<ApplicableGrant> applicableGrantFromJson(String str) => List<ApplicableGrant>.from(json.decode(str).map((x) => ApplicableGrant.fromJson(x)));

String applicableGrantToJson(List<ApplicableGrant> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ApplicableGrant {
  ApplicableGrant({
    this.discountTypeId,
    this.discountType,
    this.subTypeId,
    this.percentage,
    this.description,
    this.category,
    this.posterPhoto,
  });

  int discountTypeId;
  String discountType;
  int subTypeId;
  double percentage;
  String description;
  int category;
  dynamic posterPhoto;

  factory ApplicableGrant.fromJson(Map<String, dynamic> json) => ApplicableGrant(
    discountTypeId: json["DiscountTypeID"],
    discountType: json["DiscountType"],
    subTypeId: json["SubTypeID"],
    percentage: json["Percentage"],
    description: json["Description"],
    category: json["Category"],
    posterPhoto: json["PosterPhoto"],
  );

  Map<String, dynamic> toJson() => {
    "DiscountTypeID": discountTypeId,
    "DiscountType": discountType,
    "SubTypeID": subTypeId,
    "Percentage": percentage,
    "Description": description,
    "Category": category,
    "PosterPhoto": posterPhoto,
  };
}
