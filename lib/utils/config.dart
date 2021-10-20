import 'package:flutter/services.dart' show rootBundle;

Map<String, String> _parseConfigFile(String text) {
  Map<String, String> result = <String, String>{};
  RegExp regex = RegExp("^(?<key>\\w+)=(?<value>.*)", multiLine: true);
  for (RegExpMatch match in regex.allMatches(text)) {
    if (match.namedGroup("key") != null && match.namedGroup("value") != null) {
      result[match.namedGroup("key")!] = match.namedGroup("value")!;
    }
  }
  return result;
}

Future<Map<String, String>> get config async {
  String text = await rootBundle.loadString('assets/config.txt');
  return _parseConfigFile(text);
}