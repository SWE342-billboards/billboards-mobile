import 'dart:convert';

import 'package:http/http.dart' as http;

import 'orders.dart';

class Repository {
  static int userId = 2;

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

  // static Future<bool> makeOrder(Map<String, dynamic> data) async {
  //   // Map<String, String> headers = {
  //   //   "Accept": "application/json",
  //   //   'Content-Type': 'application/json'
  //   // };

  //   // final response = await http.post(
  //   //   Uri.http('10.0.2.2:3005', '/api/make_order'),
  //   //   body: json.encode(data),
  //   //   headers: headers,
  //   // );
  //   // print('response : ${response.body}');
  //   // return response.statusCode == 200;
  // }

  // static Future<List<BillboardOrder>> getOrders() async {
  //   Map<String, String> headers = {"Accept": "application/json"};

  //   // // Decode JSON list to list of dynamic values
  //   // final List<dynamic> jsonValues = json.decode(response.body);

  //   // Map dynamic values to BillboardOrder objects
  //   // final List<BillboardOrder> orders =
  //   //     jsonValues.map((json) => BillboardOrder.fromJson(json)).toList();
  //   // print(orders.length);
  //   // return orders;
  // }

  static Future<List<String>> getLocations() async {
    Map<String, String> headers = {"Accept": "application/json"};

    final response = await http.get(
      Uri.http('10.0.2.2:3005', '/api/locations'),
      headers: headers,
    );
    if (response.statusCode == 200) {
      final jsonList = json.decode(response.body) as List<dynamic>;
      final cities = jsonList.map((json) => json['name'] as String).toList();
      return cities;
    } else {
      return [];
    }
  }
}
