import 'package:absensi_glagahwangi/presentation/widget/custom_icons.dart';
import 'package:absensi_glagahwangi/utils/color_palette.dart';
import 'package:flutter/material.dart';

class CustomProfileButton extends StatelessWidget {
  final String text;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback onPressed;

  const CustomProfileButton({
    super.key,
    required this.text,
    this.prefixIcon,
    this.suffixIcon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
        padding: WidgetStateProperty.all<EdgeInsets>(EdgeInsets.zero),
      ),
      child: Row(
        children: [
          if (prefixIcon != null)
            Icon(prefixIcon, color: ColorPalette.mainText),
          if (prefixIcon != null) const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontFamily: "Manrope",
                color: ColorPalette.mainText,
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
              color: ColorPalette.mainText,
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
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        _showConfirmationDialog(context);
      },
      style: ButtonStyle(
        padding: WidgetStateProperty.all<EdgeInsets>(EdgeInsets.zero),
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

  Future<void> _showConfirmationDialog(BuildContext context) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Log Out"),
          content: const Text("Apakah Anda Yakin Untuk Keluar?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                onPressed();
                Navigator.of(context).pop();
              },
              child: const Text("Log Out"),
            ),
          ],
        );
      },
    );
  }
}
