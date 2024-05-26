import 'package:absensi_glagahwangi/utils/color_palette.dart';
import 'package:flutter/material.dart';

class CustomFormField extends StatefulWidget {
  final String fieldName;
  final String label;
  final TextEditingController? controller;
  final TextEditingController? confirmPasswordController;
  final String initialValue;
  final bool isPassword;
  final bool isPhone;
  final bool isEmail;
  final bool isConfirmPassword;
  final Function(String)? onChanged;

  const CustomFormField({
    super.key,
    required this.fieldName,
    required this.label,
    this.controller,
    this.confirmPasswordController,
    this.initialValue = "",
    this.onChanged,
    this.isPassword = false,
    this.isPhone = false,
    this.isEmail = false,
    this.isConfirmPassword = false,
  });

  @override
  _CustomFormFieldState createState() => _CustomFormFieldState();
}

class _CustomFormFieldState extends State<CustomFormField> {
  late TextEditingController _controller;
  bool isObscure = true;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController(text: widget.initialValue);
  }

  String? _validateField(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please fill this field';
    }

    if (widget.isPhone) {
      if (!RegExp(r'^\+62\d{8,}$').hasMatch(value)) {
        return 'Phone number must start with +62 and be at least 9 digits long';
      }
    }

    if (widget.isEmail) {
      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
        return 'Please enter a valid email address';
      }
    }

    if (widget.isPassword) {
      if (value.length < 8) {
        return 'Password must be at least 8 characters long';
      }
      if (!RegExp(r'[A-Z]').hasMatch(value)) {
        return 'Password must contain at least one uppercase letter';
      }
      if (!RegExp(r'[a-z]').hasMatch(value)) {
        return 'Password must contain at least one lowercase letter';
      }
      if (!RegExp(r'[0-9]').hasMatch(value)) {
        return 'Password must contain at least one number';
      }
      if (!RegExp(r'[!@#\$&*~]').hasMatch(value)) {
        return 'Password must contain at least one special character';
      }
    }

    if (widget.isConfirmPassword && widget.confirmPasswordController != null) {
      if (value != widget.confirmPasswordController!.text) {
        return 'Passwords do not match';
      }
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      onChanged: (value) => widget.onChanged?.call(value),
      obscureText: widget.isPassword && isObscure,
      keyboardType: widget.isEmail ? TextInputType.emailAddress : TextInputType.text,
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
      validator: _validateField,
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
        fontWeight: FontWeight.w700,
      ),
    );
