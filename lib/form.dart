import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import 'orders.dart';

class MyFormScreen extends StatefulWidget {
  @override
  _MyFormScreenState createState() => _MyFormScreenState();
}

class _MyFormScreenState extends State<MyFormScreen> {
  String _size = 'small';
  String _type = '1-sided';
  String _location = 'Almaty';
  DateTime? _startDate;
  DateTime? _endDate;
  int _minCost = 0;
  int _maxCost = 100;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Form Screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Select size:'),
            DropdownButton(
              value: _size,
              onChanged: (value) {
                setState(() {
                  _size = value.toString();
                });
              },
              items: [
                DropdownMenuItem(
                  value: 'small',
                  child: Text('small'),
                ),
                DropdownMenuItem(
                  value: 'medium',
                  child: Text('medium'),
                ),
                DropdownMenuItem(
                  value: 'large',
                  child: Text('large'),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Text('Select type:'),
            DropdownButton(
              value: _type,
              onChanged: (value) {
                setState(() {
                  _type = value.toString();
                });
              },
              items: [
                DropdownMenuItem(
                  value: '1-sided',
                  child: Text('1-side'),
                ),
                DropdownMenuItem(
                  value: '2-sided',
                  child: Text('2-side'),
                ),
                DropdownMenuItem(
                  value: '3-sided',
                  child: Text('3-side'),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Text('Select location:'),
            DropdownButton(
              value: _location,
              onChanged: (value) {
                setState(() {
                  _location = value.toString();
                });
              },
              items: [
                DropdownMenuItem(
                  value: 'Almaty',
                  child: Text('Almaty'),
                ),
                DropdownMenuItem(
                  value: 'Astana',
                  child: Text('Astana'),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Text('Select date range:'),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: _startDate ?? DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null && picked != _startDate) {
                        setState(() {
                          _startDate = picked;
                        });
                      }
                    },
                    child: AbsorbPointer(
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Start date',
                          suffixIcon: Icon(Icons.calendar_today),
                        ),
                        readOnly: true,
                        controller: TextEditingController(
                          text: _startDate == null ? '' : DateFormat.yMd().format(_startDate!),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16.0),
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: _endDate ?? DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null && picked != _endDate) {
                        setState(() {
                          _endDate = picked;
                        });
                      }
                    },
                    child: AbsorbPointer(
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'End date',
                          suffixIcon: Icon(Icons.calendar_today),
                        ),
                        readOnly: true,
                        controller: TextEditingController(
                          text: _endDate == null ? '' : DateFormat.yMd().format(_endDate!),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Text('Select cost range:'),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Min cost',
                      suffixText: 'KZT',
                    ),
                    onChanged: (value) {
                      _minCost = int.parse(value);
                    },
                  ),
                ),
                SizedBox(width: 16.0),
                Expanded(
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Max cost',
                      suffixText: 'KZT',
                    ),
                    onChanged: (value) {
                      _maxCost = int.parse(value);
                    },
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Center(
              child: ElevatedButton(
                child: Text('Submit'),
                onPressed: _submitForm,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submitForm() async {
    var order = {
      'start_date': '2023-05-01',
      'end_date': '2023-05-31',
      'user_id': 1.toString(),
      'location': _location,
      'size': _size,
      'type': _type,
      'material': 'digital',
      'min_cost': _minCost.toString(),
      'max_cost': _maxCost.toString(),
    };

    Map<String, String> headers = {"Accept": "application/json"};

    // Make the HTTP request
    final response = await http.post(
      Uri.http('10.0.2.2:3005', '/api/make_order'),
      body: order,
      headers: headers,
    );

    print('response : ${response.body}');
    Navigator.push(context, MaterialPageRoute(builder: (c) => BillboardOrderListScreen()));
  }
}