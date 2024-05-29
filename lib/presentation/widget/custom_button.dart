import 'package:flutter/material.dart';
import '../../utils/color_palette.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double? textSize;
  final Color? textColor;
  final Color? buttonColor;
  final bool dismissKeyboard;

  const CustomButton({
    super.key,
    this.buttonColor = ColorPalette.main_green,
    this.textColor = Colors.white,
    this.textSize = 20,
    this.dismissKeyboard = false,
    required this.text,
    required this.onPressed,
  });

  void _handleOnPressed(BuildContext context) {
    if (dismissKeyboard) {
      FocusScope.of(context).unfocus();
    }
    onPressed();
  }

  @override
  Widget build(BuildContext context) {
    final bool isButtonDisabled = dismissKeyboard;

    return Opacity(
      opacity: isButtonDisabled ? 0.5 : 1.0,
      child: AbsorbPointer(
        absorbing: isButtonDisabled,
        child: ElevatedButton(
          onPressed: () => _handleOnPressed(context),
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
        ),
      ),
    );
  }
}
