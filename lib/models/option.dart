enum OptionAvailable {
  notAvailable,
  available,
  priority,
  invalid,
}

class Option {
	final int id;
	final String name;
	final String displayName;
	final String category;
	final OptionAvailable available;

  Option.fromJson(Map<String, dynamic> json)
    : id = json['id'],
      name = json['name'],
      displayName = json['displayName'],
      category = json['category'],
      available = json['available'] == 0 ? OptionAvailable.notAvailable
        : json['available'] == 1 ? OptionAvailable.available
        : json['available'] == 2 ? OptionAvailable.priority
        : OptionAvailable.invalid;
}

class NullOption implements Option {
  @override
  final int id = -1;
  @override
  final String name = '';
  @override
  final String displayName = '';
  @override
  final String category = "";
  @override
  final OptionAvailable available = OptionAvailable.invalid;

  NullOption();
}