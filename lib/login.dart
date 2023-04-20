import 'package:demo/orders.dart';
import 'package:demo/register.dart';
import 'package:flutter/material.dart';

import 'repository.dart';

import 'dart:convert';
import 'package:demo/login.dart';
import 'package:demo/repository.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:email_validator/email_validator.dart';

class LoginScreen extends StatefulWidget {
  final bool isUpdateProfile;
  const LoginScreen({
    super.key,
    this.isUpdateProfile = false,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _passwordVisible = false;
  final _formKey = GlobalKey<FormState>();
  bool _isValid = false;
  String? _errorText;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Center(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 36,
                  ),
                  TextFormField(
                    controller: _emailController,
                    onChanged: (value) {
                      _isValid =
                          _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;
                      setState(() {});
                    },
                    decoration: InputDecoration(
                      hintText: 'Email',
                      hintStyle: const TextStyle(fontSize: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value?.isEmpty == true) {
                        return 'Please enter your email';
                      } else if (!EmailValidator.validate(value ?? '')) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: !_passwordVisible,
                    onChanged: (value) {
                      _isValid =
                          _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;
                      setState(() {});
                    },
                    validator: (value) {
                      if (value?.isEmpty == true) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        hintText: 'Password',
                        hintStyle: const TextStyle(fontSize: 16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(_passwordVisible ? Icons.visibility : Icons.visibility_off),
                          onPressed: () {
                            setState(() {
                              _passwordVisible = !_passwordVisible;
                            });
                          },
                        )),
                  ),
                  Row(
                    children: [
                      const Text('Not Registered Yet?'),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context)
                              .pushReplacement(MaterialPageRoute(builder: (context) => RegistrationScreen()));
                        },
                        child: const Text('Register'),
                      ),
                    ],
                  ),
                  if (_errorText != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Text(
                        _errorText!,
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  _isLoading
                      ? CircularProgressIndicator()
                      : InkWell(
                          onTap: _login,
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: _isValid ? null : Border.all(color: const Color(0xFF1976D2)),
                              color: _isValid ? const Color(0xFF1976D2) : null,
                            ),
                            child: Center(
                              child: Text(
                                'Login',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: _isValid ? Colors.white : Color(0xFF1976D2),
                                ),
                              ),
                            ),
                          ),
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future _login() async {
    if (_formKey.currentState?.validate() == true) {
      final email = _emailController.text;
      final password = _passwordController.text;
      // final ok = await Repository.login(email, password);
      // print(ok);
      // if (ok) {
      //   Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      //     return BillboardOrderListScreen();
      //   }));
      // } else {
      _errorText = 'Email or password is incorrect!';
      setState(() {});
      // }
    }
  }
}
