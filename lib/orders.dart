import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class BillboardOrder {
  final int orderId;
  final DateTime startDate;
  final DateTime endDate;
  final String status;
  final String city;
  final int cost;
  final String type;
  final String material;
  final String size;

  BillboardOrder({
    required this.orderId,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.city,
    required this.cost,
    required this.type,
    required this.material,
    required this.size,
  });

  factory BillboardOrder.fromJson(Map<String, dynamic> json) {
    return BillboardOrder(
      orderId: json['order_id'],
      startDate: DateTime.parse(json['start_date']),
      endDate: DateTime.parse(json['end_date']),
      status: json['status'],
      city: json['city'],
      cost: json['cost'],
      type: json['type'],
      material: json['material'],
      size: json['size'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'order_id': orderId,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'status': status,
      'city': city,
      'cost': cost,
      'type': type,
      'material': material,
      'size': size,
    };
  }
}

class BillboardOrderListScreen extends StatefulWidget {
  @override
  _BillboardOrderListScreenState createState() => _BillboardOrderListScreenState();
}

class _BillboardOrderListScreenState extends State<BillboardOrderListScreen> {
  List<BillboardOrder> orders = [];

  Future<List<BillboardOrder>> _loadOrders() async {
    Map<String, String> headers = {"Accept": "application/json"};

    final response = await http.post(
      Uri.http('10.0.2.2:3005', '/api/orders'),
      headers: headers,
      body: {'user_id': '1'},
    );

    // Decode JSON list to list of dynamic values
    final List<dynamic> jsonValues = json.decode(response.body);

    // Map dynamic values to BillboardOrder objects
    final List<BillboardOrder> orders =
        jsonValues.map((json) => BillboardOrder.fromJson(json)).toList();

    return orders;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _loadOrders(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }
        final orders = snapshot.data!;

        return Scaffold(
          appBar: AppBar(
            title: Text('Billboard Orders'),
          ),
          body: FutureBuilder<List<BillboardOrder>>(
            future: _loadOrders(),
            builder: ((context, snapshot) {
              if (!snapshot.hasData) {
                return CircularProgressIndicator();
              }

              final data = snapshot.data;

              return ListView.builder(
                itemCount: orders.length,
                itemBuilder: (BuildContext context, int index) {
                  final order = orders[index];
                  return InkWell(
                    onTap: () {
                      _showOrderDetails(order);
                    },
                    child: Card(
                      child: ListTile(
                        leading: Text('Order ${order.orderId}'),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Start date: ${order.startDate}'),
                            Text('End date: ${(order.endDate)}'),
                            Text('Location: ${order.city}'),
                            Text('Cost: ${order.cost.toString()} KZT'),
                          ],
                        ),
                        trailing: Text('${order.status}'),
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}.${date.month}.${date.year}';
  }

  void _showOrderDetails(BillboardOrder order) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Order ${order.orderId}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Start date: ${order.startDate}'),
              Text('End date: ${order.endDate}'),
              Text('Location: ${order.city}'),
              Text('Cost: ${order.cost.toString()} KZT'),
              Text('Type: ${order.type}'),
              Text('Size: ${order.size}'),
              Text('Status: ${order.status}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
