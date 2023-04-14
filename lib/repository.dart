import 'dart:convert';

import 'package:http/http.dart' as http;

import 'orders.dart';

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

  static Future<bool> makeOrder(Map<String, dynamic> data) async {
    Map<String, String> headers = {"Accept": "application/json"};

    final response = await http.post(
      Uri.http('10.0.2.2:3005', '/api/make_order'),
      body: data,
      headers: headers,
    );
    print('response : ${response.body}');
    return true;
  }

  static Future<List<BillboardOrder>> getOrders() async {
    Map<String, String> headers = {"Accept": "application/json"};

    final response = await http.post(
      Uri.http('10.0.2.2:3005', '/api/orders'),
      headers: headers,
      body: {
        'user_id': userId.toString(),
      },
    );

    // Decode JSON list to list of dynamic values
    final List<dynamic> jsonValues = json.decode(response.body);

    // Map dynamic values to BillboardOrder objects
    final List<BillboardOrder> orders =
        jsonValues.map((json) => BillboardOrder.fromJson(json)).toList();

    return orders;
  }
}