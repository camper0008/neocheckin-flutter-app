import 'package:flutter/widgets.dart';
import 'package:neocheckin/models/timestamp.dart';
import 'package:neocheckin/utils/http_request.dart';

Future<Timestamp> getUpdatedLocalTimestamp(BuildContext errorContext) async {
  const url = "https://www.timeapi.io/api/Time/current/zone?timeZone=Europe/Copenhagen";
  Map<String, dynamic> json = await HttpRequest.httpGet(url, errorContext);
  return Timestamp.fromJson(json);
}
Future<Timestamp> getUpdatedUTCTimestamp(BuildContext errorContext) async {
  const url = "https://www.timeapi.io/api/Time/current/zone?timeZone=Europe/London";
  Map<String, dynamic> json = await HttpRequest.httpGet(url, errorContext);
  return Timestamp.fromJson(json);
}