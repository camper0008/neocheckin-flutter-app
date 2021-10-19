import 'package:neocheckin/models/option.dart';
import 'package:neocheckin/responses/abstract.dart';

class OptionsResponse implements Response {
  final List<Option> options;
  @override
  final String error;

  OptionsResponse({required this.options, this.error = 'none'});

  OptionsResponse.fromJson(Map<String, dynamic> json)
    : options = (json['options'].runtimeType != null.runtimeType) 
        ? (json['options'] as List<dynamic>)
          .map((dynamic optionJson) 
            => Option.fromJson(optionJson))
          .toList()
        : <Option>[],
      error = json['error'] ?? 'none';
}
