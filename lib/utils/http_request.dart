import 'dart:convert';
import 'package:http/http.dart' as http;

class HttpRequest {
  static Future<dynamic> get(String url) async {
    try {
      http.Response response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          'Access-Control_Allow_Origin': '*',
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      if (response.statusCode < 400) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed GET request to \'$url\'.');
      }
    } catch(err) {}
  }
  static Future<dynamic> post(String url, dynamic body) async {
    try {
      http.Response response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Access-Control_Allow_Origin': '*',
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(body),
      );
      if (response.statusCode < 400) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed POST request to \'$url\'.');
      }
    } catch(err) {}
  }
}