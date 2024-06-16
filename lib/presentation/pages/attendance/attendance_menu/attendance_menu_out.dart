import 'dart:io';
import 'package:absensi_glagahwangi/presentation/pages/attendance/attendance_menu/maps.dart';
import 'package:absensi_glagahwangi/presentation/widget/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../../../data/repository/attendance_repository.dart';
import '../../../../data/repository/map_repository.dart';
import '../../../../utils/color_palette.dart';
import '../../../blocs/auth/auth_bloc.dart';
import '../../../blocs/maps/maps_bloc.dart';
import '../../../blocs/attendance/attendance_bloc.dart';

class AttendanceMenuOut extends StatefulWidget {
  const AttendanceMenuOut({Key? key}) : super(key: key);

  @override
  _AttendanceMenuOutState createState() => _AttendanceMenuOutState();
}

class _AttendanceMenuOutState extends State<AttendanceMenuOut> {
  final ImagePicker _picker = ImagePicker();
  XFile? _image;
  String locationText = "Loading...";

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
    final authUser = context.select((AuthBloc bloc) => bloc.state.user);
    final attendanceRepository = AttendanceRepository();

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => MapsBloc(MapRepository())..add(GetCurrentLocationEvent()),
        ),
        BlocProvider(
          create: (context) => AttendanceBloc(attendanceRepository),
        ),
      ],
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
            "Menu Absen Keluar",
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
                  if (state is MapsInsideGeofence) {
                    locationText = state.locationName;
                  } else if (state is MapsOutsideGeofence) {
                    locationText = state.locationName;
                  } else if (state is MapsInitial) {
                    locationText = "Fetching Location.....";
                  }

                  return Container(
                    width: double.infinity,
                    height: 100,
                    decoration: BoxDecoration(
                      border: Border.all(color: ColorPalette.stroke_menu),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Align(
                        alignment: Alignment.centerLeft,
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
                  height: 450,
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
                    style: const TextStyle(
                      color: Colors.black,
                      fontFamily: "Manrope",
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              const Spacer(),
              BlocConsumer<AttendanceBloc, AttendanceState>(
                listener: (context, state) {
                  if (state is AttendanceSuccess) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Attendance recorded successfully!')),
                    );
                    Navigator.pop(context); // Navigate back to the previous page
                  } else if (state is AttendanceFailure) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: ${state.error}')),
                    );
                  }
                },
                builder: (context, state) {
                  final bool isButtonDisabled = _image == null || locationText == "Loading..." || locationText == "Unable to fetch location";

                  return CustomButton(
                    text: state is AttendanceLoading ? "Loading..." : "Absen Keluar",
                    onPressed: !isButtonDisabled
                        ? () {

                      context.read<AttendanceBloc>().add(RecordAttendanceOut(
                        authUser.id!,
                        DateTime.now(),
                        locationText,
                        _image!.path,
                      ));
                    }
                        : () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please take a photo and wait for the location to load before submitting.')),
                      );
                    },
                    buttonColor: isButtonDisabled ? Colors.grey : ColorPalette.main_green,
                  );
                },
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
