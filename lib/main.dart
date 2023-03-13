import 'package:flutter/material.dart';
import 'package:pianta/register/profile.dart';
import 'package:pianta/register/signup.dart';
import 'register/create_password.dart';
import 'register/login.dart';

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

