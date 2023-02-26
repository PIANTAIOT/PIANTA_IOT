import 'package:flutter/material.dart';
import 'package:pianta/profile.dart';
import 'package:pianta/signup.dart';
import 'create_password.dart';
import 'login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Login(),
    );
  }
}

