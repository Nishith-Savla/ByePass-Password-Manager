import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:password_manager/constants.dart';
import 'package:password_manager/firebase/authentication.dart';
import 'package:password_manager/routes_generator.dart';
import 'package:password_manager/screens/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await dotenv.load(fileName: ".env");
  final auth = Authentication();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: const HomePage(),
    theme: ThemeData(
      fontFamily: GoogleFonts.poppins().fontFamily,
      primarySwatch: purpleMaterialColor,
    ),
    initialRoute: auth.isUserLoggedIn()
        ? auth.isEmailVerified()
            ? "/home"
            : "/verifyEmail"
        : "/login",
    onGenerateRoute: RoutesGenerator.generateRoute,
  ));
}
