import 'package:flutter/material.dart';
import 'package:password_manager/utils.dart';

class RoundedButton extends StatelessWidget {
  final String text;
  final Function() onPressed;
  final Color color, textColor;

  const RoundedButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.color = purpleMaterialColor,
    this.textColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      width: size.width * 0.9,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(
            color: textColor,
          ),
        ),
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          primary: color,
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
        ),
      ),
    );
  }
}
