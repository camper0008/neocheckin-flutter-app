import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:neocheckin/utils/config.dart';
import 'package:neocheckin/utils/display_error.dart';

class HttpRequest {
  static Future<Map<String, dynamic>> httpGet(String url, BuildContext errorContext) async {
    try {
      http.Response response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          'Access-Control_Allow_Origin': '*',
          'Content-Type': 'application/json; charset=UTF-8',
          'token': (await config)["CACHE_GET_KEY"]!,
        },
      );
      if (response.statusCode < 400) {
        Map<String, dynamic> decoded = json.decode(response.body);
        if (decoded['error'].runtimeType != null.runtimeType) {
          throw Exception(decoded['error']);
        }
        return decoded;
      } else {
        Map<String, dynamic> decoded = json.decode(response.body);
        throw Exception('GET \'$url\' failed: ' + decoded['error'].toString());
      }
    } catch(err, trace) {
      displayError(errorContext, "$err\n$trace");
      return json.decode("{ \"error\": \"error occured\" }");
    }
  }
  static Future<Map<String, dynamic>> httpPost(String url, dynamic body, BuildContext errorContext) async {
    try {
      http.Response response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Access-Control_Allow_Origin': '*',
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json'
        },
        body: json.encode(body),
      );
      if (response.statusCode < 400) {
        Map<String, dynamic> decoded = json.decode(response.body);
        if (decoded['error'].runtimeType != null.runtimeType) {
          throw Exception(decoded['error']);
        }
        return decoded;
      } else {
        Map<String, dynamic> decoded = json.decode(response.body);
        throw Exception('POST \'$url\' failed: ' + decoded['error'].toString());
      }
    } catch(err, trace) {
      displayError(errorContext, "$err\n$trace");
      return json.decode("{ \"error\": \"error occured\" }");
    }
  }
}