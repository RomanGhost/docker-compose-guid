class Subject {
  final int id;
  final String name;
  final double price;
  String? _level;

  String get level => _level??"Уровень не определен";
  void set level(String level){
    _level = level;
  }

  Subject({
    String? level,
    this.id = 0,
    required this.name,
    required this.price
  }):_level=level;

  String toString(){
    return "${name}";
  }
}
