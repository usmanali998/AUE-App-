// To parse this JSON data, do
//
//     final grantDetailsSemesterCompany = grantDetailsSemesterCompanyFromJson(jsonString);

import 'dart:convert';

import 'grant_details_semester.dart';

GrantDetailsSemesterCompany grantDetailsSemesterCompanyFromJson(String str) => GrantDetailsSemesterCompany.fromJson(json.decode(str));

String grantDetailsSemesterCompanyToJson(GrantDetailsSemesterCompany data) => json.encode(data.toJson());

class GrantDetailsSemesterCompany {
  GrantDetailsSemesterCompany({
    this.details,
    this.semesterList,
    this.companyList,
  });

  List<Detail> details;
  List<SemesterList> semesterList;
  List<CompanyList> companyList;

  factory GrantDetailsSemesterCompany.fromJson(Map<String, dynamic> json) => GrantDetailsSemesterCompany(
    details: List<Detail>.from(json["Details"].map((x) => Detail.fromJson(x))),
    semesterList: List<SemesterList>.from(json["SemesterList"].map((x) => SemesterList.fromJson(x))),
    companyList: List<CompanyList>.from(json["CompanyList"].map((x) => CompanyList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "Details": List<dynamic>.from(details.map((x) => x.toJson())),
    "SemesterList": List<dynamic>.from(semesterList.map((x) => x.toJson())),
    "CompanyList": List<dynamic>.from(companyList.map((x) => x.toJson())),
  };
}

class CompanyList {
  CompanyList({
    this.id,
    this.name,
  });

  int id;
  String name;

  factory CompanyList.fromJson(Map<String, dynamic> json) => CompanyList(
    id: json["ID"],
    name: json["Name"],
  );

  Map<String, dynamic> toJson() => {
    "ID": id,
    "Name": name,
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

// class SemesterList {
//   SemesterList({
//     this.semesterId,
//     this.semesterName,
//   });
//
//   int semesterId;
//   String semesterName;
//
//   factory SemesterList.fromJson(Map<String, dynamic> json) => SemesterList(
//     semesterId: json["SemesterID"],
//     semesterName: json["SemesterName"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "SemesterID": semesterId,
//     "SemesterName": semesterName,
//   };
// }
