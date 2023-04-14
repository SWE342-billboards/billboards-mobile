import 'dart:convert';

import 'package:http/http.dart' as http;

class Repository {
  static int userId = -1;

  static Future<bool> register(String email, String psw, String type) async {
    final url = Uri.http('10.0.2.2:3005', '/api/register');
    final response = await http.post(
      url,
      body: json.encode({
        'email': email,
        'password': psw,
        'type': type,
      }),
      headers: {'Content-Type': 'application/json'},
    ).catchError(() {
      return false;
    });

    userId = jsonDecode(response.body)['id'];
    return true;
  }

  static Future<bool> login(String email, String psw) async {
    final url = Uri.http('10.0.2.2:3005', '/api/login');
    final response = await http.post(
      url,
      body: json.encode({
        'email': email,
        'password': psw,
      }),
      headers: {'Content-Type': 'application/json'},
    ).catchError(() {
      return false;
    });

    userId = jsonDecode(response.body)['id'];
    return true;
  }
}
