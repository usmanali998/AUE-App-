// To parse this JSON data, do
//
//     final announcements = announcementsFromJson(jsonString);

import 'dart:convert';

Announcements announcementsFromJson(String str) => Announcements.fromJson(json.decode(str));

String announcementsToJson(Announcements data) => json.encode(data.toJson());

class Announcements {
  Announcements({
    this.announcement,
    this.images,
  });

  List<SingleAnnouncement> announcement;
  List<AnnouncementImage> images;

  factory Announcements.fromJson(Map<String, dynamic> json) => Announcements(
        announcement: List<SingleAnnouncement>.from(json["Announcement"].map((x) => SingleAnnouncement.fromJson(x))),
        images: List<AnnouncementImage>.from(json["Images"].map((x) => AnnouncementImage.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Announcement": List<dynamic>.from(announcement.map((x) => x.toJson())),
        "Images": List<dynamic>.from(images.map((x) => x.toJson())),
      };
}

class SingleAnnouncement {
  SingleAnnouncement({
    this.masterId,
    this.masterYear,
    this.author,
    this.announcementTitle,
    this.announcementNotes,
  });

  int masterId;
  int masterYear;
  String author;
  String announcementTitle;
  String announcementNotes;

  factory SingleAnnouncement.fromJson(Map<String, dynamic> json) => SingleAnnouncement(
        masterId: json["MasterID"],
        masterYear: json["MasterYear"],
        author: json["Author"],
        announcementTitle: json["AnnouncementTitle"],
        announcementNotes: json["AnnouncementNotes"],
      );

  Map<String, dynamic> toJson() => {
        "MasterID": masterId,
        "MasterYear": masterYear,
        "Author": author,
        "AnnouncementTitle": announcementTitle,
        "AnnouncementNotes": announcementNotes,
      };
}

class AnnouncementImage {
  AnnouncementImage({
    this.masterId,
    this.image,
  });

  int masterId;
  String image;

  factory AnnouncementImage.fromJson(Map<String, dynamic> json) => AnnouncementImage(
        masterId: json["MasterID"],
        image: json["Image"],
      );

  Map<String, dynamic> toJson() => {
        "MasterID": masterId,
        "Image": image,
      };
}
