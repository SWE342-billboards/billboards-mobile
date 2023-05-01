import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/main.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  var uid;
  @override
  void initState() {
    super.initState();
    doSomeAsyncStuff();
  }

  Future<void> doSomeAsyncStuff() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    uid = prefs.getString('uid');
    print(uid);
  }

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
              onTap: () async {
                final SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setString('uid', '');
                Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                  return MyHomePage(uid: prefs.getString('uid').toString());
                }));
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
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('orders').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          var orders = snapshot.data?.docs ?? [];

          if (orders.length == 0) {
            return Center(child: Text('No orders'));
          }

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index].data();
              if (order['user_id'] == uid) {
                return InkWell(
                  onTap: () {
                    _showOrderDetails(order);
                  },
                  child: Card(
                    elevation: 5,
                    child: ListTile(
                      title: Text('Order #${order['orderId']}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (order['start_date'] != null)
                            Text(
                              '${order['start_date']} - ${order['end_date']}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 16,
                              ),
                            ),
                          Text(
                            'Cost: \$${order['min_cost']}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 15,
                            ),
                          ),
                          Text(
                            'Location: ${order['location']}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      trailing: Text(
                        '${order['status']}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                );
              }

              return Container();
            },
          );
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}.${date.month}.${date.year}';
  }

  void _showOrderDetails(Map<String, dynamic> order) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Order ${order['orderId']} - Status: ${order['status']}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Start date:' + order['start_date']),
              Text('End date: ' + order['end_date']),
              Text('Cost: \$${order['min_cost']}'),
              Text('Location: ${order['location']}'),
              Text('Type: ${order['type']}'),
              Text('Material: ${order['material']}'),
              Text('Size: ${order['size']}'),
            ],
          ),
        );
      },
    );
  }
}
