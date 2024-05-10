import 'package:absensi_glagahwangi/utils/color_palette.dart';
import 'package:flutter/material.dart';

import '../../widget/custom_button.dart';

class PermissionForm extends StatelessWidget {
  const PermissionForm({Key? key}) : super(key: key);

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
          "Form Pengajuan Izin",
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
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Jenis Izin",
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: "Manrope",
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 3),
              DropdownButtonFormField(
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: ColorPalette.main_text, width: 2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: ColorPalette.stroke_menu, width: 2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: ColorPalette.stroke_menu, width: 2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) => value == null ? "Pilih Izin" : null,
                dropdownColor: Colors.white,
                items: dropdownItems,
                onChanged: (Object? value) {},
              ),
              SizedBox(height: 30),
              Text(
                "Deskripsi",
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: "Manrope",
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 3),
              SizedBox(
                width: double.infinity,
                height: 160,
                child: TextField(
                  maxLines: null,
                  expands: true,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                      BorderSide(color: ColorPalette.main_text, width: 2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                      BorderSide(color: ColorPalette.stroke_menu, width: 2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    border: OutlineInputBorder(
                      borderSide:
                      BorderSide(color: ColorPalette.stroke_menu, width: 2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30),
              const Text(
                "Foto Bukti",
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: "Manrope",
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 3),
              Container(
                width: double.infinity,
                height: 350,
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
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.camera_alt, size: 50, color: ColorPalette.main_text),
                        Text(
                          "Ambil Foto",
                          style: TextStyle(
                            color: ColorPalette.main_text,
                            fontFamily: "Manrope",
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30),
              CustomButton(text: "Kirim", onPressed: () {} )
            ],
          ),
        ),
      ),
    );
  }
}

List<DropdownMenuItem<String>> get dropdownItems {
  List<DropdownMenuItem<String>> menuItems = [
    DropdownMenuItem(child: Text("Sakit"), value: "Sakit"),
    DropdownMenuItem(child: Text("Izin"), value: "Izin"),
  ];
  return menuItems;
}
