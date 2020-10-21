// To parse this JSON data, do
//
//     final grantDetail = grantDetailFromJson(jsonString);

import 'dart:convert';

GrantDetails grantDetailsFromJson(String str) => GrantDetails.fromJson(json.decode(str));

String grantDetailsToJson(GrantDetails data) => json.encode(data.toJson());

class GrantDetails {
  GrantDetails({
    this.details,
    this.semesterList,
  });

  List<Detail> details;
  List<SemesterList> semesterList;

  factory GrantDetails.fromJson(Map<String, dynamic> json) => GrantDetails(
    details: List<Detail>.from(json["Details"].map((x) => Detail.fromJson(x))),
    semesterList: List<SemesterList>.from(json["SemesterList"].map((x) => SemesterList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "Details": List<dynamic>.from(details.map((x) => x.toJson())),
    "SemesterList": List<dynamic>.from(semesterList.map((x) => x.toJson())),
  };
}

class Detail {
  Detail({
    this.percentage,
    this.discountTypeId,
    this.subTypeId,
    this.discountType,
    this.description,
    this.posterPhoto,
    this.showCompanyList,
    this.disclaimer,
    this.showPreviousAueidNumber,
    this.previousAueidNumberLabel,
    this.showFamilyAueidNumber,
    this.familyAueidNumberLabel,
  });

  double percentage;
  int discountTypeId;
  int subTypeId;
  String discountType;
  String description;
  dynamic posterPhoto;
  bool showCompanyList;
  String disclaimer;
  bool showPreviousAueidNumber;
  String previousAueidNumberLabel;
  bool showFamilyAueidNumber;
  String familyAueidNumberLabel;

  factory Detail.fromJson(Map<String, dynamic> json) => Detail(
    percentage: json["Percentage"],
    discountTypeId: json["DiscountTypeID"],
    subTypeId: json["SubTypeID"],
    discountType: json["DiscountType"],
    description: json["Description"],
    posterPhoto: json["PosterPhoto"],
    showCompanyList: json["ShowCompanyList"],
    disclaimer: json["Disclaimer"],
    showPreviousAueidNumber: json["ShowPreviousAUEIDNumber"],
    previousAueidNumberLabel: json["PreviousAUEIDNumberLabel"],
    showFamilyAueidNumber: json["ShowFamilyAUEIDNumber"],
    familyAueidNumberLabel: json["FamilyAUEIDNumberLabel"],
  );

  Map<String, dynamic> toJson() => {
    "Percentage": percentage,
    "DiscountTypeID": discountTypeId,
    "SubTypeID": subTypeId,
    "DiscountType": discountType,
    "Description": description,
    "PosterPhoto": posterPhoto,
    "ShowCompanyList": showCompanyList,
    "Disclaimer": disclaimer,
    "ShowPreviousAUEIDNumber": showPreviousAueidNumber,
    "PreviousAUEIDNumberLabel": previousAueidNumberLabel,
    "ShowFamilyAUEIDNumber": showFamilyAueidNumber,
    "FamilyAUEIDNumberLabel": familyAueidNumberLabel,
  };
}

class SemesterList {
  SemesterList({
    this.semesterId,
    this.semesterName,
  });

  int semesterId;
  String semesterName;

  factory SemesterList.fromJson(Map<String, dynamic> json) => SemesterList(
    semesterId: json["SemesterID"],
    semesterName: json["SemesterName"],
  );

  Map<String, dynamic> toJson() => {
    "SemesterID": semesterId,
    "SemesterName": semesterName,
  };
}
