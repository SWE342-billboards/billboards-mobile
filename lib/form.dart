import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'orders.dart';
import 'repository.dart';

class MyFormScreen extends StatefulWidget {
  @override
  _MyFormScreenState createState() => _MyFormScreenState();
}

class _MyFormScreenState extends State<MyFormScreen> {
  String _size = 'Small';
  String _type = '1-sided';
  String _location = 'Almaty';
  String _material = 'digital';

  final _formKey = GlobalKey<FormState>();
  TextEditingController _minCostController = TextEditingController();
  TextEditingController _maxCostController = TextEditingController();
  TextEditingController _startDateController = TextEditingController();
  TextEditingController _endDateController = TextEditingController();

  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(Duration(days: 5));

  List<String> _cities = [
    'Almaty',
    'Nursultan',
    'Semei',
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order to Rent Billboard'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text('Size:   '),
                  DropdownButton(
                    value: _size,
                    onChanged: (value) {
                      setState(() {
                        _size = value.toString();
                      });
                    },
                    items: [
                      DropdownMenuItem(
                        value: 'Small',
                        child: Text('Small'),
                      ),
                      DropdownMenuItem(
                        value: 'Medium',
                        child: Text('Medium'),
                      ),
                      DropdownMenuItem(
                        value: 'Large',
                        child: Text('Large'),
                      ),
                    ],
                  ),
                  Spacer(),
                  Text('Type:   '),
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
                ],
              ),
              SizedBox(height: 16.0),
              Row(
                children: [
                  Text('Location:   '),
                  DropdownButton(
                      hint: Text('Select location:'),
                      value: _location,
                      onChanged: (value) {
                        setState(() {
                          _location = value.toString();
                        });
                      },
                      items: _cities
                          .map((e) => DropdownMenuItem(
                                value: e,
                                child: Text(e),
                              ))
                          .toList()),
                  Spacer(),
                  Text('Material:   '),
                  DropdownButton(
                    value: _material,
                    onChanged: (value) {
                      setState(() {
                        _material = value.toString();
                      });
                    },
                    items: [
                      DropdownMenuItem(
                        value: 'digital',
                        child: Text('digital'),
                      ),
                      DropdownMenuItem(
                        value: 'painted',
                        child: Text('painted'),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 30),
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
                            _startDateController.text = DateFormat.yMd().format(picked);
                          });
                        }
                      },
                      child: AbsorbPointer(
                        child: TextFormField(
                          controller: _startDateController,
                          keyboardType: TextInputType.datetime,
                          validator: (value) {
                            if (value?.isEmpty == true) {
                              return 'Please enter start date';
                            }
                            // if (DateTime.parse(value ?? '0')
                            //     .isAfter(DateTime.parse(_endDateController.text))) {
                            //   return 'Start date should be less than end date';
                            // }
                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: 'Start Date',
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 40),
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
                            _endDateController.text = DateFormat.yMd().format(picked);
                          });
                        }
                      },
                      child: AbsorbPointer(
                        child: TextFormField(
                          controller: _endDateController,
                          keyboardType: TextInputType.datetime,
                          validator: (value) {
                            if (value?.isEmpty == true) {
                              return 'Please enter end date';
                            }
                            if (_endDate.isBefore(_startDate)) {
                              return 'End date should be greater than start date';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: 'End Date',
                            errorMaxLines: 3,
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
                      controller: _minCostController,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value?.isEmpty == true) {
                          return 'Please enter minimum cost';
                        }
                        // if (double.parse(value ?? '0') >= double.parse(_maxCostController.text)) {
                        //   return 'Minimum cost should be less than maximum cost';
                        // }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Minimum Cost',
                      ),
                    ),
                  ),
                  SizedBox(width: 40),
                  Expanded(
                    child: TextFormField(
                      controller: _maxCostController,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value?.isEmpty == true) {
                          return 'Please enter maximum cost';
                        }
                        if (double.parse(value ?? '0') <= double.parse(_minCostController.text)) {
                          return 'Maximum cost should be greater than minimum cost';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Maximum Cost',
                        errorMaxLines: 3,
                      ),
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
      ),
    );
  }

  Future<void> _submitForm() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();

    // if (_formKey.currentState?.validate() == true) {
    //   print('valid');
    // }

    var data = {
      'status': 'pending',
      'orderId': now.microsecondsSinceEpoch.toString(),
      'start_date': DateFormat('yyyy-MM-dd').format(_startDate),
      'end_date': DateFormat('yyyy-MM-dd').format(_endDate),
      'user_id': prefs.getString('uid'),
      'location': _location,
      'size': _size,
      'type': _type,
      'material': _material,
      'min_cost': _minCostController.text,
      'max_cost': _maxCostController.text,
      'days': _endDate.difference(_startDate).inDays.toString(),
    };
    final CollectionReference _productss = FirebaseFirestore.instance.collection('orders');
    var datas = await _productss.add(data);
    print(datas);
    // final ok = await Repository.makeOrder(data);
    // print(ok);
    // if (ok) {
    Navigator.of(context).pop();
  }
}
