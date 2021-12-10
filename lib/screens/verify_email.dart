import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:password_manager/firebase/authentication.dart';

class VerifyEmail extends StatefulWidget {
  const VerifyEmail({Key? key}) : super(key: key);

  @override
  _VerifyEmailState createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  late User? user;
  @override
  void initState() {
    super.initState();
    Authentication auth = Authentication();
    user = FirebaseAuth.instance.currentUser;
    auth.sendEmailVerification(user);

    Timer.periodic(const Duration(seconds: 3), (timer) {
      Authentication().isEmailVerified()
          ? Navigator.pushReplacementNamed(context, '/home')
          : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
          'An verification link has been to your ${user!.email} email account please verify it'),
    );
  }
}
