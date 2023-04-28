import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'auth.dart';
import 'form.dart';
import 'orders.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.getString('uid') == null) {
    prefs.setString('uid', '');
  }

  runApp(MyHomePage(
    uid: prefs.getString('uid').toString(),
  ));
}

class MyHomePage extends StatefulWidget {
  String uid;
  MyHomePage({super.key, required this.uid});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: BillboardOrderListScreen(),
      ),
    );
  }
}
