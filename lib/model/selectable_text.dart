class SelectableTextModel {
  String text;
  bool selected;

  SelectableTextModel({this.text, this.selected = false});

  static List<SelectableTextModel> calendar = [
    SelectableTextModel(text: "Day", selected: true),
    SelectableTextModel(text: "Week"),
    SelectableTextModel(text: "Month"),
    SelectableTextModel(text: "Year"),
  ];

  static List<SelectableTextModel> clos = [
    SelectableTextModel(text: "CLO 1", selected: true),
    SelectableTextModel(text: "CLO 2"),
    SelectableTextModel(text: "CLO 3"),
    SelectableTextModel(text: "CLO 4"),
  ];
}
