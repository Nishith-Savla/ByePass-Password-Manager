import 'package:flutter/material.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';
import 'package:password_manager/components/textfield_container.dart';
import 'package:password_manager/constants.dart';

class RoundedTextFormField extends StatelessWidget {
  final bool disabled;
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
  final String tooltipMessage;

  final JustTheController? tooltipController;

  const RoundedTextFormField({
    Key? key,
    this.tooltipController,
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
    this.tooltipMessage = "",
    this.disabled = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextFormField(
        onChanged: onChanged,
        cursorColor: purpleMaterialColor,
        obscureText: obscureText,
        decoration: InputDecoration(
          isDense: true,
          icon: tooltipMessage.isNotEmpty && tooltipController != null
              ? JustTheTooltip(
                  preferredDirection: AxisDirection.down,
                  controller: tooltipController,
                  content: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(tooltipMessage),
                  ),
                  tailLength: 10.0,
                  tailBaseWidth: 15,
                  offset: -8,
                  triggerMode: TooltipTriggerMode.tap,
                  child: InkWell(
                    splashFactory: InkRipple.splashFactory,
                    radius: 5,
                    child: Icon(icon, size: 20, color: Colors.red),
                    onTap: () => tooltipController!.showTooltip(),
                  ),
                )
              : Icon(icon, size: 20, color: purpleMaterialColor),
          hintText: hintText,
          suffixIcon: suffixIcon,
          labelText: labelText,
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
        style: style,
        readOnly: disabled,
      ),
    );
  }
}
