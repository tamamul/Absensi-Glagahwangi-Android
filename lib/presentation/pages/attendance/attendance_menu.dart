import 'package:absensi_glagahwangi/presentation/widget/custom_button.dart';
import 'package:flutter/material.dart';

import '../../../utils/color_palette.dart';

class AttendanceMenu extends StatelessWidget {
  const AttendanceMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          color: Colors.black,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Menu Absen",
          style: TextStyle(
            color: Colors.black,
            fontFamily: "Manrope",
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.location_pin),
            color: Colors.black,
            onPressed: () {
              // Add logout function here
            },
          ),
        ],
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Lokasi Sekarang",
              style: TextStyle(
                color: Colors.black,
                fontFamily: "Manrope",
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 3),
            Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                border: Border.all(color: ColorPalette.stroke_menu),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Align(
                  alignment: Alignment.centerLeft, // Align text to the center vertically
                  child: Text(
                    "Lokasi",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: ColorPalette.main_text,
                      fontFamily: "Manrope",
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Container(
              width: double.infinity,
              height: 600,
              decoration: BoxDecoration(
                border: Border.all(color: ColorPalette.stroke_menu),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Ambil Foto"),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  },
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.camera_alt,
                          size: 50, color: ColorPalette.main_text),
                      Text(
                        "Ambil Foto",
                        style: TextStyle(
                          color: ColorPalette.main_text,
                          fontFamily: "Manrope",
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
            const Spacer(),
            CustomButton(text: "Absen", onPressed: () {}),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
