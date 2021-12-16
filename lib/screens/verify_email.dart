import 'dart:async' show Timer;
import 'dart:io' show Platform;

import 'package:android_intent_plus/android_intent.dart' show AndroidIntent;
import 'package:android_intent_plus/flag.dart' show Flag;
import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth, User;
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify your email'),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Text('An verification link has been to ${user!.email}. \n'
                'Please open it and once done, switch back to the App'),
            ElevatedButton(
                child: const Text('Open Mail'),
                onPressed: () async {
                  if (Platform.isAndroid) {
                    AndroidIntent intent = const AndroidIntent(
                      action: 'android.intent.action.MAIN',
                      category: 'android.intent.category.APP_EMAIL',
                      flags: [Flag.FLAG_ACTIVITY_NEW_TASK],
                    );
                    await intent
                        .launch()
                        .then((_) => debugPrint("success"))
                        .catchError((e) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text(e.toString())));
                    });
                    // } else if (Platform.isIOS) {
                    //   launch("message://").catchError((e) {
                    //     ScaffoldMessenger.of(context)
                    //         .showSnackBar(SnackBar(content: e));
                    //   });
                  }
                })
          ],
        ),
      ),
    );
  }
}
