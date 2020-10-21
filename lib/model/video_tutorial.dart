// To parse this JSON data, do
//
//     final videoTutorial = videoTutorialFromJson(jsonString);

import 'dart:convert';

List<VideoTutorial> videoTutorialFromJson(String str) => List<VideoTutorial>.from(json.decode(str).map((x) => VideoTutorial.fromJson(x)));

String videoTutorialToJson(List<VideoTutorial> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class VideoTutorial {
  VideoTutorial({
    this.id,
    this.title,
    this.link,
    this.description,
    this.language,
    this.thumbnail,
  });

  int id;
  String title;
  String link;
  dynamic description;
  String language;
  String thumbnail;

  factory VideoTutorial.fromJson(Map<String, dynamic> json) => VideoTutorial(
    id: json["ID"],
    title: json["Title"],
    link: json["Link"],
    description: json["Description"],
    language: json["Language"],
    thumbnail: json["Thumbnail"],
  );

  Map<String, dynamic> toJson() => {
    "ID": id,
    "Title": title,
    "Link": link,
    "Description": description,
    "Language": language,
    "Thumbnail": thumbnail,
  };
}
