import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:password_manager/utils.dart';
import 'package:password_manager/pages/login.dart';

void main() async {
  await dotenv.load(fileName: ".env");

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: const Login(),
    theme: ThemeData(
      primarySwatch: purpleMaterialColor,
    ),
  ));
}
