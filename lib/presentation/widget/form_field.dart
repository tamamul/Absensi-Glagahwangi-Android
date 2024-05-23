import 'package:absensi_glagahwangi/utils/color_palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomFormField extends StatefulWidget {
  final String fieldName;
  final String initialValue;
  final String label;
  final bool isPassword;
  final bool isPhone;
  final bool isEmail;
  final Function(String)? onChanged;

  const CustomFormField({
    super.key,
    required this.fieldName,
    required this.label,
    this.initialValue = "",
    this.onChanged,
    this.isPassword = false,
    this.isPhone = false,
    this.isEmail = false,
  });

  @override
  _CustomFormFieldState createState() => _CustomFormFieldState();
}

class _CustomFormFieldState extends State<CustomFormField> {

  bool isObscure = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: (value) => widget.onChanged?.call(value),
      obscureText: widget.isPassword && isObscure,
      initialValue: widget.initialValue,
      inputFormatters: widget.isPhone ? [FilteringTextInputFormatter.digitsOnly] : [],
      keyboardType: widget.isPhone
          ? TextInputType.phone
          : widget.isEmail
          ? TextInputType.emailAddress
          : TextInputType.text,
      decoration: inputDecoration(
        labelText: widget.label,
        suffixIcon: widget.isPassword
            ? IconButton(
          icon: Icon(
            isObscure ? Icons.visibility_off : Icons.visibility,
            color: Colors.black.withOpacity(0.9),
          ),
          onPressed: () {
            setState(() {
              isObscure = !isObscure;
            });
          },
        )
            : null,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please fill this field';
        }
        return null;
      },
    );
  }
}
InputDecoration inputDecoration({
  InputBorder? enabledBorder,
  InputBorder? border,
  InputBorder? focusedBorder,
  Color? fillColor,
  bool? filled,
  Widget? suffixIcon,
  String? labelText,
}) =>
    InputDecoration(
      enabledBorder: enabledBorder ??
          OutlineInputBorder(
            borderSide: const BorderSide(color: ColorPalette.main_text, width: 1.0),
            borderRadius: BorderRadius.circular(8.0),
          ),
      border: border ?? const OutlineInputBorder(borderSide: BorderSide()),
      focusedBorder: focusedBorder ?? OutlineInputBorder(
        borderSide: const BorderSide(width: 2.0),
        borderRadius: BorderRadius.circular(8.0),
      ),
      fillColor: fillColor ?? Colors.white,
      filled: filled ?? true,
      suffixIcon: suffixIcon,
      labelText: labelText,
      labelStyle: const TextStyle(
        fontFamily: "Manrope",
        color: ColorPalette.form_text,
        fontSize: 18,
        fontWeight: FontWeight.w700
      ),
    );