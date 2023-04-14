import 'dart:convert';
import 'package:demo/repository.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RegistrationPageWidget extends StatefulWidget {
  @override
  _RegistrationPageWidgetState createState() => _RegistrationPageWidgetState();
}

class _RegistrationPageWidgetState extends State<RegistrationPageWidget> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isCustomer = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registration'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Email',
              style: TextStyle(fontSize: 16.0),
            ),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: 'Enter your email',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Password',
              style: TextStyle(fontSize: 16.0),
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Enter your password',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Register as:',
              style: TextStyle(fontSize: 16.0),
            ),
            Row(
              children: [
                Radio(
                  value: true,
                  groupValue: _isCustomer,
                  onChanged: (value) {
                    setState(() {
                      _isCustomer = value as bool;
                    });
                  },
                ),
                Text('Customer'),
                SizedBox(width: 16.0),
                Radio(
                  value: false,
                  groupValue: _isCustomer,
                  onChanged: (value) {
                    setState(() {
                      _isCustomer = value as bool;
                    });
                  },
                ),
                Text('Manager'),
              ],
            ),
            SizedBox(height: 16.0),
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _isLoading = true;
                      });
                      _registerUser();
                    },
                    child: Text('Submit'),
                  ),
          ],
        ),
      ),
    );
  }

  Future<void> _registerUser() async {
    final email = _emailController.text;
    final password = _passwordController.text;
    final userType = _isCustomer ? 'customer' : 'manager';

    final ok = await Repository.register(email, password, userType);
    print(ok);

    setState(() {
      _isLoading = false;
    });
  }
}
