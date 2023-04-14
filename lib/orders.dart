
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'form.dart';
import 'repository.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Billboard Orders'),
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: InkWell(
              child: Icon(Icons.logout),
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.create),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return MyFormScreen();
          })).then((value) => setState(() {}));
        },
      ),
      body: FutureBuilder(
        future: Repository.getOrders(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          final orders = snapshot.data!;

          if (orders.length == 0) {
            return Center(child: Text('No orders'));
          }

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return InkWell(
                onTap: () {
                  _showOrderDetails(order);
                },
                child: Card(
                  elevation: 5,
                  child: ListTile(
                    title: Text('Order #${order.orderId}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${DateFormat.yMMMd().format(order.startDate)} - ${DateFormat.yMMMd().format(order.endDate)}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          'Cost: \$${order.cost}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          'Location: ${order.city}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    trailing: Text(
                      '${order.status}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
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
          title: Text('Order ${order.orderId} - Status: ${order.status}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Start date: ${DateFormat.yMMMd().format(order.startDate)}'),
              Text('End date: ${DateFormat.yMMMd().format(order.endDate)}'),
              Text('Cost: \$${order.cost}'),
              Text('Location: ${order.city}'),
              Text('Type: ${order.type}'),
              Text('Material: ${order.material}'),
              Text('Size: ${order.size}'),
            ],
          ),
        );
      },
    );
  }
}
