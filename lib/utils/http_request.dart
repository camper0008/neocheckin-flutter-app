import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:neocheckin/utils/display_error.dart';

const String apiUrl = "http://10.220.220.13:6000/api";

class HttpRequest {
  static Future<Map<String, dynamic>> httpGet(String url, BuildContext errorContext) async {
    try {
      http.Response response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          'Access-Control_Allow_Origin': '*',
          'Content-Type': 'application/json; charset=UTF-8',
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
    } catch(err) {
      displayError(errorContext, err.toString());
      return json.decode("{ \"error\": \"$err\" }");
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
    } catch(err) {
      displayError(errorContext, err.toString());
      return json.decode("{ \"error\": \"$err\" }");
    }
  }
}