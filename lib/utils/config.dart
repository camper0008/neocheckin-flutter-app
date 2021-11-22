import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/widgets.dart';
import 'package:neocheckin/utils/display_error.dart';

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

configFileExists(BuildContext context) async {
  try {
    await rootBundle.loadString('assets/settings.conf');
  } catch(err) {
    displayError(context, "config file does not exist");
  }
}

Future<Map<String, String>> get config async {
  try {
    String text = await rootBundle.loadString('assets/settings.conf');
    return _parseConfigFile(text);
  } catch (err) {
    throw Exception("could not load settings.conf");
  }
}

Future <String> get cacheUrl async {
  String? url = (await config)["CACHE_URL"];
  if (url == null) {
    return "";
  } else {
    return url;
  }
}