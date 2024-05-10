import 'package:flutter/material.dart';
import '../../utils/color_palette.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double? textSize;
  final Color? textColor;
  final Color? buttonColor;

  const CustomButton({
    super.key,
    this.buttonColor = ColorPalette.main_green,
    this.textColor = Colors.white,
    this.textSize = 20,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: const Size.fromHeight(50),
        backgroundColor: buttonColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: "Manrope",
          color: textColor,
          fontWeight: FontWeight.w700,
          fontSize: textSize,
        ),
      ),
    );
  }
}
