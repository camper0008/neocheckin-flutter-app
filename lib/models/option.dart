class Option {
  final int id;
  final String name;
  Option({required this.id, required this.name});

  Option.fromJson(Map<String, dynamic> json)
    : id = json['id'],
      name = json['name'];
}

class NullOption implements Option {
  @override
  final int id = -1;
  @override
  final String name = 'Normal';

  NullOption();
}