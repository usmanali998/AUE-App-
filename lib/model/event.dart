import 'dart:convert';

class Event {
  final int iD;
  final String nameEN;
  final String nameAR;
  final String descriptionEN;
  final String descriptionAR;
  final int typeID;
  final String typeNameEN;
  final String typeNameAR;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime registrationStart;
  final DateTime registrationEnd;
  final int maxSlots;
  final String eventCode;
  final String coverPage;
  final bool showCoverPage;
  final String revenueAccountNumber;
  final bool isFree;
  final int participantCount;
  Event({
    this.iD,
    this.nameEN,
    this.nameAR,
    this.descriptionEN,
    this.descriptionAR,
    this.typeID,
    this.typeNameEN,
    this.typeNameAR,
    this.startDate,
    this.endDate,
    this.registrationStart,
    this.registrationEnd,
    this.maxSlots,
    this.eventCode,
    this.coverPage,
    this.showCoverPage,
    this.revenueAccountNumber,
    this.isFree,
    this.participantCount,
  });

  Map<String, dynamic> toMap() {
    return {
      'ID': iD,
      'NameEN': nameEN,
      'NameAR': nameAR,
      'DescriptionEN': descriptionEN,
      'DescriptionAR': descriptionAR,
      'TypeID': typeID,
      'TypeNameEN': typeNameEN,
      'TypeNameAR': typeNameAR,
      'StartDate': startDate,
      'EndDate': endDate,
      'RegistrationStart': registrationStart,
      'RegistrationEnd': registrationEnd,
      'MaxSlots': maxSlots,
      'EventCode': eventCode,
      'CoverPage': coverPage,
      'ShowCoverPage': showCoverPage,
      'RevenueAccountNumber': revenueAccountNumber,
      'IsFree': isFree,
      'ParticipantCount': participantCount,
    };
  }

  static Event fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Event(
      iD: map['ID']?.toInt(),
      nameEN: map['NameEN'],
      nameAR: map['NameAR'],
      descriptionEN: map['DescriptionEN'],
      descriptionAR: map['DescriptionAR'],
      typeID: map['TypeID']?.toInt(),
      typeNameEN: map['TypeNameEN'],
      typeNameAR: map['TypeNameAR'],
      startDate: DateTime.parse(map['StartDate']),
      endDate: DateTime.parse(map['EndDate']),
      registrationStart: DateTime.parse(map['RegistrationStart']),
      registrationEnd: DateTime.parse(map['RegistrationEnd']),
      maxSlots: map['MaxSlots']?.toInt(),
      eventCode: map['EventCode'],
      coverPage: map['CoverPage'],
      showCoverPage: map['ShowCoverPage'],
      revenueAccountNumber: map['RevenueAccountNumber'],
      isFree: map['IsFree'],
      participantCount: map['ParticipantCount']?.toInt(),
    );
  }

  static List<Event> fromMapToList(List<dynamic> list) {
    if (list.isEmpty) return [];

    return list.map((map) => Event.fromMap(map)).toList();
  }

  String toJson() => json.encode(toMap());

  static Event fromJson(String source) => fromMap(json.decode(source));

  @override
  String toString() {
    return 'Event(ID: $iD, NameEN: $nameEN, NameAR: $nameAR, DescriptionEN: $descriptionEN, DescriptionAR: $descriptionAR, TypeID: $typeID, TypeNameEN: $typeNameEN, TypeNameAR: $typeNameAR, StartDate: $startDate, EndDate: $endDate, RegistrationStart: $registrationStart, RegistrationEnd: $registrationEnd, MaxSlots: $maxSlots, EventCode: $eventCode, CoverPage: $coverPage, ShowCoverPage: $showCoverPage, RevenueAccountNumber: $revenueAccountNumber, IsFree: $isFree, ParticipantCount: $participantCount)';
  }
}
