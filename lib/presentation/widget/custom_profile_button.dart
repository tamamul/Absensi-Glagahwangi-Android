import 'package:absensi_glagahwangi/presentation/widget/custom_icons.dart';
import 'package:absensi_glagahwangi/utils/color_palette.dart';
import 'package:flutter/material.dart';

class CustomProfileButton extends StatelessWidget {
  final String text;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback onPressed;

  const CustomProfileButton({
    Key? key,
    required this.text,
    this.prefixIcon,
    this.suffixIcon,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
        padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.zero),
      ),
      child: Row(
        children: [
          if (prefixIcon != null)
            Icon(prefixIcon, color: ColorPalette.main_text),
          if (prefixIcon != null) const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontFamily: "Manrope",
                color: ColorPalette.main_text,
                fontWeight: FontWeight.w700,
                fontSize: 20,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          if (suffixIcon != null) const SizedBox(width: 8),
          if (suffixIcon != null)
            Icon(
              suffixIcon,
              color: ColorPalette.main_text,
            ),
        ],
      ),
    );
  }
}

class CustomLogoutButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const CustomLogoutButton({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
        padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.zero),
      ),
      child: Row(
        children: [
          const Icon(CustomIcons.logout, color: Colors.red),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontFamily: "Manrope",
                color: Colors.red,
                fontWeight: FontWeight.w700,
                fontSize: 20,
              ),
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
    );
  }
}
