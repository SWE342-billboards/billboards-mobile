import 'dart:convert';
import 'package:demo/login.dart';
import 'package:demo/repository.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:email_validator/email_validator.dart';

class RegistrationScreen extends StatefulWidget {
  final bool isUpdateProfile;
  const RegistrationScreen({
    super.key,
    this.isUpdateProfile = false,
  });

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isCustomer = true;
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
        title: Text('Registration'),
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
                      _isValid = _emailController.text.isNotEmpty &&
                          _passwordController.text.isNotEmpty &&
                          EmailValidator.validate(_emailController.text);
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
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      'Only numerals, letters and: !, @, #, \$, %, ^, &, ',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: !_passwordVisible,
                    onChanged: (value) {
                      _isValid = _emailController.text.isNotEmpty &&
                          _passwordController.text.isNotEmpty &&
                          EmailValidator.validate(_emailController.text);
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
                  SizedBox(height: 16),
                  Text(
                    'User type:',
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
                  Row(
                    children: [
                      const Text('You have an account?'),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (context) => LoginScreen()));
                        },
                        child: const Text('Log in'),
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
                          onTap: _register,
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: _isValid ? null : Border.all(color: const Color(0xFF1976D2)),
                              color: _isValid ? const Color(0xFF1976D2) : null,
                            ),
                            child: Center(
                              child: Text(
                                'Submit',
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

  Future _register() async {
    if (_formKey.currentState?.validate() == true) {
      final email = _emailController.text;
      final password = _passwordController.text;
      final userType = _isCustomer ? 'customer' : 'manager';

      final ok = await Repository.register(email, password, userType);
      print(ok);

      if (ok) {
        Navigator.pop(context);
      } else {
        _errorText = 'Email is already in use!';
      }
    }

    setState(() {
      _isLoading = false;
    });
  }
}
