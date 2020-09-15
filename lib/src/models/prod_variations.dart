class Variation {
  String name;
  List<Option> options;
  Variation({this.name, this.options});

  bool isNull() {
    return (name == null && options == null);
  }

  Variation.fromMap(Map<String, dynamic> map)
      : name = map["name"],
        options = List.from(map["options"]);
}

class Option {
  double price;
  String name;

  bool selected = false;

  Option({this.name, this.selected});
}
