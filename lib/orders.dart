import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class BillboardOrder {
  final String orderId;
  final String startDate;
  final String endDate;
  final String location;
  final String cost;
  final String type;
  final String size;
  final String status;

  BillboardOrder({
    required this.orderId,
    required this.startDate,
    required this.endDate,
    required this.location,
    required this.cost,
    required this.type,
    required this.size,
    required this.status,
  });

  factory BillboardOrder.fromJson(Map<String, dynamic> json) {
    return BillboardOrder(
      orderId: json['orderId'],
      startDate: json['startDate'],
      endDate: json['endDate'],
      location: json['location'],
      cost: json['cost'],
      type: json['type'],
      size: json['size'],
      status: json['status'],
    );
  }
}

class BillboardOrderListScreen extends StatefulWidget {
  @override
  _BillboardOrderListScreenState createState() => _BillboardOrderListScreenState();
}

class _BillboardOrderListScreenState extends State<BillboardOrderListScreen> {
  List<BillboardOrder> orders = [];

  Future<List<BillboardOrder>> load() async {
    Map<String, String> headers = {"Accept": "application/json"};

    final response = await http.get(
      Uri.http('10.0.2.2:8005', '/api/orders'),
      headers: headers,
    );
    final l = json.decode(response.body);
    return List<BillboardOrder>.from(l.map((model) => BillboardOrder.fromJson(model)));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<BillboardOrder>>(
        future: load(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Scaffold(body: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          final orders = snapshot.data!;

          return Scaffold(
            appBar: AppBar(
              title: Text('Billboard Orders'),
            ),
            body: ListView.builder(
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
                          Text('Location: ${order.location}'),
                          Text('Cost: ${order.cost.toString()} KZT'),
                        ],
                      ),
                      trailing: Text('${order.status}'),
                    ),
                  ),
                );
              },
            ),
          );
        });
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
              Text('Location: ${order.location}'),
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
