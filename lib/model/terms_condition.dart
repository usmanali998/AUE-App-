class TermsCondition {
  int id;
  String title;
  String content;

  TermsCondition({this.id, this.title, this.content});

  factory TermsCondition.fromJson(Map<String, dynamic> parsedJson) {
    return TermsCondition(
      id: parsedJson['ID'],
      title: parsedJson['Title'],
      content: parsedJson['Content'],
    );
  }
}

class TermsConditionList {
  List<TermsCondition> termsConditionList;
  TermsConditionList({this.termsConditionList});

  factory TermsConditionList.fromJson(List<dynamic> parsedJson) {
    List<TermsCondition> termsCondition = List<TermsCondition>();
    termsCondition = parsedJson.map((e) => TermsCondition.fromJson(e)).toList();
    return TermsConditionList(termsConditionList: termsCondition);
  }
}
