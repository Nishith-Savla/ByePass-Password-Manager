import 'package:flutter/material.dart';
import 'package:password_manager/components/textfield_container.dart';
import 'package:password_manager/utils.dart';

class RoundedTextField extends StatelessWidget {
  final Color? color;
  final String? labelText;
  final String? hintText;
  final IconData? icon;
  final Widget? suffixIcon;
  final ValueChanged? onChanged;
  final TextStyle? style;
  final AutovalidateMode? autovalidateMode;
  final TextInputType? keyboardType;
  final int? maxLength;
  final Iterable<String>? autofillHints;
  final FormFieldSetter<String>? onSaved;
  final FormFieldValidator<String>? validator;
  final bool autofocus;
  final bool obscureText;
  final FocusNode? focusNode;

  const RoundedTextField({
    Key? key,
    this.labelText,
    this.hintText,
    this.color,
    this.icon,
    this.suffixIcon,
    this.onChanged,
    this.style,
    this.autovalidateMode,
    this.focusNode,
    this.keyboardType,
    this.maxLength,
    this.autofillHints,
    this.onSaved,
    this.validator,
    this.autofocus = false,
    this.obscureText = false,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextFormField(
        onChanged: onChanged,
        cursorColor: purpleMaterialColor,
        decoration: InputDecoration(
          fillColor: color ?? purpleMaterialColor[100],
          isDense: true,
          icon: icon != null
              ? Icon(
                  icon,
                  color: purpleMaterialColor,
                )
              : null,
          suffixIcon: suffixIcon,
          labelText: labelText,
          hintText: hintText,
          border: InputBorder.none,
        ),
        autovalidateMode: autovalidateMode,
        focusNode: focusNode,
        keyboardType: keyboardType,
        maxLength: maxLength,
        autofillHints: autofillHints,
        onSaved: onSaved,
        validator: validator,
        autofocus: autofocus,
        obscureText: obscureText,
        style: style,
      ),
    );
  }
}
