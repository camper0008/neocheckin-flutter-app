import 'dart:convert';
import 'package:http/http.dart' as http;

class HttpRequest {
  static Future<Map<String, dynamic>> get(String url, void Function(String) displayError) async {
    try {
      http.Response response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          'Access-Control_Allow_Origin': '*',
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      if (response.statusCode < 400) {
        return json.decode(response.body);
      } else {
        Map<String, dynamic> decoded = json.decode(response.body);
        throw Exception('GET \'$url\' failed: ' + decoded['error'].toString());
      }
    } catch(err) {
      displayError(err.toString());
      return json.decode("{ \"error\": \"$err\" }");
    }
  }
  static Future<Map<String, dynamic>> post(String url, dynamic body, void Function(String) displayError) async {
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
        return json.decode(response.body);
      } else {
        Map<String, dynamic> decoded = json.decode(response.body);
        throw Exception('POST \'$url\' failed: ' + decoded['error'].toString());
      }
    } catch(err) {
      displayError(err.toString());
      return json.decode("{ \"error\": \"$err\" }");
    }
  }
}