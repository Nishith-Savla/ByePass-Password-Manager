import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:password_manager/constants.dart';
import 'package:password_manager/screens/generate.dart';
import 'package:password_manager/screens/home.dart';
import 'package:password_manager/screens/signup.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await dotenv.load(fileName: ".env");
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: const HomePage(),
    theme: ThemeData(
      fontFamily: GoogleFonts.poppins().fontFamily,
      primarySwatch: purpleMaterialColor,
    ),
  ));
}
