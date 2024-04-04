import 'package:flutter/material.dart';

import '../../utils/color_palette.dart';

Widget authButton({
  required String text,
  required Function onTap,
}) {
  return ElevatedButton(
    onPressed: () {
      onTap();
    },
    style: ElevatedButton.styleFrom(
        minimumSize: const Size.fromHeight(50),backgroundColor: ColorPalette.main_green,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
    child: Text(
      text,
      style: const TextStyle(
        fontFamily: "Manrope",
          color: Colors.white, fontWeight: FontWeight.w700, fontSize: 20),
    ),
  );
}
