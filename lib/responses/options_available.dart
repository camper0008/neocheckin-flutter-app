import 'package:neocheckin/models/option.dart';
import 'package:neocheckin/responses/abstract.dart';

class OptionsAvailableResponse implements Response {
  final List<Option> options;
  @override
  final String error;

  OptionsAvailableResponse({required this.options, this.error = 'none'});

  OptionsAvailableResponse.fromJson(Map<String, dynamic> json)
    : options = (json['options'].runtimeType != null.runtimeType) 
        ? (json['options'] as List<dynamic>)
          .map((dynamic optionJson) 
            => Option.fromJson(optionJson))
          .toList()
        : <Option>[],
      error = json['error'] ?? 'none';
}
