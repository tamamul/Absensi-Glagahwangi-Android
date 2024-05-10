import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../utils/color_palette.dart';

class AttendanceRecap extends StatelessWidget {
  const AttendanceRecap({Key? key}) : super(key: key);

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
          "Rekap Absen",
          style: TextStyle(
            color: Colors.black,
            fontFamily: "Manrope",
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.print),
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
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 100,
                decoration: BoxDecoration(
                  border: Border.all(color: ColorPalette.stroke_menu),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: ColorPalette.circle_menu,
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "31",
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: "Manrope",
                                fontSize: 19,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "Feb",
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: "Manrope",
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const VerticalDivider(
                      indent: 10,
                      endIndent: 10,
                      color: Colors.black,
                      thickness: 0.2,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 35,
                              height: 30,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: ColorPalette.circle_menu,
                              ),
                              child: Icon(
                                Icons.input_rounded,
                                size: 20,
                                color: ColorPalette.main_green, // Color of the icon
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              "Masuk",
                              style: TextStyle(
                                color: ColorPalette.secondary_text,
                                fontFamily: "Manrope",
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          "07:00",
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: "Manrope",
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          "Tepat Waktu",
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: "Manrope",
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        )
                      ],
                    ),
                    const VerticalDivider(
                      indent: 10,
                      endIndent: 10,
                      color: Colors.black,
                      thickness: 0.2,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 35,
                              height: 30,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: ColorPalette.circle_menu,
                              ),
                              child: Icon(
                                Icons.output_rounded,
                                size: 20,
                                color: ColorPalette.main_green, // Color of the icon
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              "Keluar",
                              style: TextStyle(
                                color: ColorPalette.secondary_text,
                                fontFamily: "Manrope",
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          "12:00",
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: "Manrope",
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          "Pulang",
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: "Manrope",
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

      ),
    );
  }
}
