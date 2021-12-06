import 'package:flutter/material.dart' show Color, MaterialColor;

const emailRegex =
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

const nameRegex = r"^[^\W\d_]+(?:[-\s](?:[^\W\d_]|['])+)*$";

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

const Color darkBlueishColor = Color(0xff403b58);
