import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'pages/login.dart';

const purpleMaterialColor = MaterialColor(0xFFA633FF, {
  50: Color.fromRGBO(166, 51, 255, .1),
  100: Color.fromRGBO(166, 51, 255, .2),
  200: Color.fromRGBO(166, 51, 255, .3),
  300: Color.fromRGBO(166, 51, 255, .4),
  400: Color.fromRGBO(166, 51, 255, .5),
  500: Color.fromRGBO(166, 51, 255, .6),
  600: Color.fromRGBO(166, 51, 255, .7),
  700: Color.fromRGBO(166, 51, 255, .8),
  800: Color.fromRGBO(166, 51, 255, .9),
  900: Color.fromRGBO(166, 51, 255, 1),
});

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
