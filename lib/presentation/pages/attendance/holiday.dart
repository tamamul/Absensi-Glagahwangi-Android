import 'package:absensi_glagahwangi/utils/color_palette.dart';
import 'package:flutter/material.dart';

class Holiday extends StatelessWidget {
  const Holiday({Key? key}) : super(key: key);

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
          "Hari Libur",
          style: TextStyle(
            color: Colors.black,
            fontFamily: "Manrope",
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 70,
                decoration: BoxDecoration(
                  border: Border.all(color: ColorPalette.stroke_menu),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: const Text(
                        "Hari raya Nyepi",
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: "Manrope",
                          fontSize: 20,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: const Text(
                        "18 Maret 202X",
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: "Manrope",
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
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
