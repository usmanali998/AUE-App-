// To parse this JSON data, do
//
//     final eBook = eBookFromJson(jsonString);

import 'dart:convert';

List<EBook> eBookFromJson(String str) => List<EBook>.from(json.decode(str).map((x) => EBook.fromJson(x)));

String eBookToJson(List<EBook> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class EBook {
  EBook({
    this.title,
    this.author,
    this.isbn,
    this.accessLink,
    this.coverPhoto,
  });

  String title;
  String author;
  String isbn;
  String accessLink;
  String coverPhoto;

  factory EBook.fromJson(Map<String, dynamic> json) => EBook(
    title: json["Title"],
    author: json["Author"],
    isbn: json["ISBN"],
    accessLink: json["AccessLink"],
    coverPhoto: json["CoverPhoto"],
  );

  Map<String, dynamic> toJson() => {
    "Title": title,
    "Author": author,
    "ISBN": isbn,
    "AccessLink": accessLink,
    "CoverPhoto": coverPhoto,
  };
}
