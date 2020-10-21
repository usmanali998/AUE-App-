// To parse this JSON data, do
//
//     final announcementDetails = announcementDetailsFromJson(jsonString);

import 'dart:convert';

AnnouncementDetails announcementDetailsFromJson(String str) => AnnouncementDetails.fromJson(json.decode(str));

String announcementDetailsToJson(AnnouncementDetails data) => json.encode(data.toJson());

class AnnouncementDetails {
  AnnouncementDetails({
    this.announcement,
    this.images,
  });

  List<AnnouncementDetail> announcement;
  List<AnnouncementDetailImage> images;

  factory AnnouncementDetails.fromJson(Map<String, dynamic> json) => AnnouncementDetails(
    announcement: List<AnnouncementDetail>.from(json["Announcement"].map((x) => AnnouncementDetail.fromJson(x))),
    images: List<AnnouncementDetailImage>.from(json["Images"].map((x) => AnnouncementDetailImage.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "Announcement": List<dynamic>.from(announcement.map((x) => x.toJson())),
    "Images": List<dynamic>.from(images.map((x) => x.toJson())),
  };
}

class AnnouncementDetail {
  AnnouncementDetail({
    this.announcementTitle,
    this.announcementNotes,
    this.registrationUrl,
  });

  String announcementTitle;
  String announcementNotes;
  String registrationUrl;

  factory AnnouncementDetail.fromJson(Map<String, dynamic> json) => AnnouncementDetail(
    announcementTitle: json["AnnouncementTitle"],
    announcementNotes: json["AnnouncementNotes"],
    registrationUrl: json["RegistrationURL"],
  );

  Map<String, dynamic> toJson() => {
    "AnnouncementTitle": announcementTitle,
    "AnnouncementNotes": announcementNotes,
    "RegistrationURL": registrationUrl,
  };
}

class AnnouncementDetailImage {
  AnnouncementDetailImage({
    this.masterId,
    this.image,
  });

  int masterId;
  String image;

  factory AnnouncementDetailImage.fromJson(Map<String, dynamic> json) => AnnouncementDetailImage(
    masterId: json["MasterID"],
    image: json["Image"],
  );

  Map<String, dynamic> toJson() => {
    "MasterID": masterId,
    "Image": image,
  };
}
