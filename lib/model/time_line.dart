import 'dart:convert';

class Timeline {
  final DateTime dated;
  final String courseWorkTypeName;
  final String description;
  final String isRubricShared;
  final String courseWorkPatternDetailID;
  final String totalMark;
  final String weight;
  Timeline({
    this.dated,
    this.courseWorkTypeName,
    this.description,
    this.isRubricShared,
    this.courseWorkPatternDetailID,
    this.totalMark,
    this.weight,
  });

  Timeline copyWith({
    String dated,
    String courseWorkTypeName,
    String description,
    String isRubricShared,
    String courseWorkPatternDetailID,
    String totalMark,
    String weight,
  }) {
    return Timeline(
      dated: dated ?? this.dated,
      courseWorkTypeName: courseWorkTypeName ?? this.courseWorkTypeName,
      description: description ?? this.description,
      isRubricShared: isRubricShared ?? this.isRubricShared,
      courseWorkPatternDetailID: courseWorkPatternDetailID ?? this.courseWorkPatternDetailID,
      totalMark: totalMark ?? this.totalMark,
      weight: weight ?? this.weight,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'Dated': dated,
      'CourseWorkTypeName': courseWorkTypeName,
      'Description': description,
      'IsRubricShared': isRubricShared,
      'CourseWorkPatternDetailID': courseWorkPatternDetailID,
      'TotalMark': totalMark,
      'Weight': weight,
    };
  }

  static Timeline fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    final date = map['Dated'].replaceAll(":", "")?.replaceAll("-", "");

    return Timeline(
      dated: DateTime.parse(date),
      courseWorkTypeName: map['CourseWorkTypeName'],
      description: map['Description'],
      isRubricShared: map['IsRubricShared'],
      courseWorkPatternDetailID: map['CourseWorkPatternDetailID'],
      totalMark: map['TotalMark'],
      weight: map['Weight'],
    );
  }

  static List<Timeline> fromMapToList(List<dynamic> list) {
    if (list.isEmpty) return [];

    return list.map((map) => Timeline.fromMap(map)).toList();
  }

  String toJson() => json.encode(toMap());

  static Timeline fromJson(String source) => fromMap(json.decode(source));

  @override
  String toString() {
    return 'Timeline(Dated: $dated, CourseWorkTypeName: $courseWorkTypeName, Description: $description, IsRubricShared: $isRubricShared, CourseWorkPatternDetailID: $courseWorkPatternDetailID, TotalMark: $totalMark, Weight: $weight)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Timeline &&
        o.dated == dated &&
        o.courseWorkTypeName == courseWorkTypeName &&
        o.description == description &&
        o.isRubricShared == isRubricShared &&
        o.courseWorkPatternDetailID == courseWorkPatternDetailID &&
        o.totalMark == totalMark &&
        o.weight == weight;
  }

  @override
  int get hashCode {
    return dated.hashCode ^
        courseWorkTypeName.hashCode ^
        description.hashCode ^
        isRubricShared.hashCode ^
        courseWorkPatternDetailID.hashCode ^
        totalMark.hashCode ^
        weight.hashCode;
  }
}
