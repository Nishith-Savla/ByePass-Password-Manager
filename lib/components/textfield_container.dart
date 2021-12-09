import 'package:flutter/material.dart';
import 'package:password_manager/constants.dart';

class TextFieldContainer extends StatelessWidget {
  final Widget child;
  final double horizontalPadding;
  final double verticalPadding;
  final double horizontalMargin;
  final double verticalMargin;

  const TextFieldContainer({
    Key? key,
    required this.child,
    this.horizontalPadding = 20.0,
    this.verticalPadding = 1.0,
    this.horizontalMargin = 0.0,
    this.verticalMargin = 10.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: verticalMargin,
        horizontal: horizontalMargin,
      ),
      padding: EdgeInsets.symmetric(
        vertical: verticalPadding,
        horizontal: horizontalPadding,
      ),
      width: size.width * 0.9,
      decoration: BoxDecoration(
        color: purpleMaterialColor[100],
        borderRadius: BorderRadius.circular(29),
      ),
      child: child,
    );
  }
}
