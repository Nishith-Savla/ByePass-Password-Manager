import 'package:flutter/material.dart';
import 'package:password_manager/constants.dart';

class TextFieldContainer extends StatelessWidget {
  final Widget child;
  const TextFieldContainer({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 20),
      width: size.width * 0.9,
      decoration: BoxDecoration(
        color: purpleMaterialColor[100],
        borderRadius: BorderRadius.circular(29),
      ),
      child: child,
    );
  }
}
