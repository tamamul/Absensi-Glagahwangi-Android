import 'dart:io';

import 'package:absensi_glagahwangi/presentation/pages/attendance/attendance_menu/maps.dart';
import 'package:absensi_glagahwangi/presentation/widget/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../data/repository/map_repository.dart';
import '../../../../utils/color_palette.dart';
import '../../../blocs/maps/maps_bloc.dart';

class AttendanceMenu extends StatefulWidget {
  const AttendanceMenu({Key? key}) : super(key: key);

  @override
  _AttendanceMenuState createState() => _AttendanceMenuState();
}

class _AttendanceMenuState extends State<AttendanceMenu> {
  final ImagePicker _picker = ImagePicker();
  XFile? _image;

  Future<void> _takePhoto() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        _image = image;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MapsBloc(MapRepository())..add(GetCurrentLocationEvent()),
      child: Scaffold(
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
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => const Maps(),
                ));
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
              BlocBuilder<MapsBloc, MapsState>(
                builder: (context, state) {
                  String locationText = "Loading...";
                  if (state is MapsInsideGeofence) {
                    locationText = state.locationName;
                  } else if (state is MapsOutsideGeofence) {
                    locationText = state.locationName;
                  } else if (state is MapsInitial) {
                    locationText = "Unable to fetch location";
                  }

                  return Container(
                    width: double.infinity,
                    height: 100, // Increased height of the container
                    decoration: BoxDecoration(
                      border: Border.all(color: ColorPalette.stroke_menu),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Align(
                        alignment: Alignment.centerLeft, // Align text to the center vertically
                        child: Text(
                          locationText,
                          maxLines: 5,
                          textAlign: TextAlign.start,
                          style: const TextStyle(
                            color: ColorPalette.main_text,
                            fontFamily: "Manrope",
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 30),
              GestureDetector(
                onTap: _takePhoto,
                child: Container(
                  width: double.infinity,
                  height: 550,
                  decoration: BoxDecoration(
                    border: Border.all(color: ColorPalette.stroke_menu),
                    borderRadius: BorderRadius.circular(10),
                    image: _image != null
                        ? DecorationImage(
                      image: FileImage(File(_image!.path)),
                      fit: BoxFit.cover,
                    )
                        : null,
                  ),
                  child: _image == null
                      ? Center(
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
                  )
                      : null,
                ),
              ),
              if (_image != null)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    "Klik gambar untuk mengambil ulang foto",
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: "Manrope",
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              const Spacer(),
              CustomButton(text: "Absen", onPressed: () {}),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
