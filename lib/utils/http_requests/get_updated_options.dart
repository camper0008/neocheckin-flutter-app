import 'package:flutter/widgets.dart';
import 'package:neocheckin/models/option.dart';
import 'package:neocheckin/responses/options.dart';
import 'package:neocheckin/utils/config.dart';
import 'package:neocheckin/utils/http_request.dart';

Option getPriorityOption(List<Option> options) {
  Option priorityOption = NullOption();
  for (int i = 0; i < options.length; ++i) {
    if (options[i].available == OptionAvailable.priority) {
      priorityOption = options[i];
    }
  }
  return priorityOption;
}

bool optionsAreIdentical(List<Option> previous, List<Option> current) {
  bool isIdentical = (previous.length == current.length);
  if (isIdentical) {
    for (int i = 0; i < previous.length; ++i) {
      if (previous[i].available != current[i].available) {
        isIdentical = false;
      }
    }
  }
  return isIdentical;
}

Future<List<Option>> getUpdatedOptions(List<Option> previousOptions, BuildContext context) async {
  String url = await cacheUrl;

  Map<String, dynamic> body = await HttpRequest.httpGet(url + '/options', context);
  OptionsResponse response = OptionsResponse.fromJson(body);
  if (response.error == 'none') {
    return response.options;
  } else {
    return previousOptions;
  }
}