import 'package:flutter/material.dart';

class BillboardOrder {
  final String orderId;
  final DateTime startDate;
  final DateTime endDate;
  final String location;
  final double cost;
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
}

class BillboardOrderListScreen extends StatefulWidget {
  @override
  _BillboardOrderListScreenState createState() => _BillboardOrderListScreenState();
}

class _BillboardOrderListScreenState extends State<BillboardOrderListScreen> {
  final List<BillboardOrder> orders = [
    BillboardOrder(
      orderId: '001',
      startDate: DateTime(2023, 4, 15),
      endDate: DateTime(2023, 4, 20),
      location: 'Almaty',
      cost: 150000.0,
      type: 'Type 1',
      size: 'Large',
      status: 'Pending',
    ),
    BillboardOrder(
      orderId: '002',
      startDate: DateTime(2023, 4, 17),
      endDate: DateTime(2023, 4, 22),
      location: 'Astana',
      cost: 200000.0,
      type: 'Type 2',
      size: 'Medium',
      status: 'Success',
    ),
    BillboardOrder(
      orderId: '003',
      startDate: DateTime(2023, 4, 21),
      endDate: DateTime(2023, 4, 25),
      location: 'Almaty',
      cost: 100000.0,
      type: 'Type 3',
      size: 'Small',
      status: 'Canceled',
    ),
  ];

  @override
  Widget build(BuildContext context) {
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
                    Text('Start date: ${_formatDate(order.startDate)}'),
                    Text('End date: ${_formatDate(order.endDate)}'),
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
              Text('Start date: ${_formatDate(order.startDate)}'),
              Text('End date: ${_formatDate(order.endDate)}'),
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
