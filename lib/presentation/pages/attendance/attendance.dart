import 'package:absensi_glagahwangi/presentation/pages/attendance/attendance_recap.dart';
import 'package:absensi_glagahwangi/presentation/pages/attendance/event_menu.dart';
import 'package:absensi_glagahwangi/presentation/pages/attendance/permission_form.dart';
import 'package:absensi_glagahwangi/presentation/widget/custom_button.dart';
import 'package:absensi_glagahwangi/utils/color_palette.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repository/event_repository.dart';
import '../../blocs/holiday/event_bloc.dart';
import '../../blocs/holiday/event_event.dart';
import '../../blocs/holiday/event_state.dart';
import 'attendance_menu.dart';

class Attendance extends StatelessWidget {
  const Attendance({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<EventBloc>(
          create: (context) => EventBloc(eventRepository: EventRepository())..add(FetchEvents()),
        ),
      ],
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.fromLTRB(12, 40, 12, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                CircleAvatar(
                  radius: 35,
                  // backgroundImage: AssetImage('assets/images/profile.png'),
                  backgroundColor: Colors.grey,
                  child: Icon(Icons.person, size: 35, color: Colors.white),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Nama Lengkap",
                      style: const TextStyle(
                        color: Colors.black,
                        fontFamily: "Manrope",
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      "Posisi",
                      style: const TextStyle(
                        color: Colors.black,
                        fontFamily: "Manrope",
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Text(
                  DateFormat("dd - MM - yyyy").format(DateTime.now()),
                  style: const TextStyle(
                    color: Colors.black,
                    fontFamily: "Manrope",
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ]),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Text(
                    "Kehadiran Hari Ini",
                    style: const TextStyle(
                      color: Colors.black,
                      fontFamily: "Manrope",
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AttendanceRecap(),
                        ),
                      );
                    },
                    child: Text(
                      "Rekap Absen",
                      style: const TextStyle(
                        color: ColorPalette.main_yellow,
                        fontFamily: "Manrope",
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(children: [
                Expanded(
                  child: Container(
                    height: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: ColorPalette.circle_menu),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(children: [
                            Container(
                              width: 40,
                              height: 30,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: ColorPalette.circle_menu,
                              ),
                              child: Icon(
                                Icons.input_rounded,
                                size: 20,
                                color: ColorPalette.main_green,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              "Masuk",
                              style: const TextStyle(
                                color: ColorPalette.main_text,
                                fontFamily: "Manrope",
                                fontSize: 18,
                              ),
                            ),
                          ]),
                          const SizedBox(width: 10),
                          Text(
                            "08:00",
                            style: const TextStyle(
                              color: ColorPalette.main_text,
                              fontFamily: "Manrope",
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            "Tepat Waktu",
                            style: const TextStyle(
                              color: ColorPalette.main_text,
                              fontFamily: "Manrope",
                              fontSize: 15,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Container(
                    height: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: ColorPalette.circle_menu),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(children: [
                            Container(
                              width: 40,
                              height: 30,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: ColorPalette.circle_menu,
                              ),
                              child: Icon(
                                Icons.output_rounded,
                                size: 20,
                                color: ColorPalette.main_green,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              "Keluar",
                              style: const TextStyle(
                                color: ColorPalette.main_text,
                                fontFamily: "Manrope",
                                fontSize: 18,
                              ),
                            ),
                          ]),
                          const SizedBox(width: 10),
                          Text(
                            "08:00",
                            style: const TextStyle(
                              color: ColorPalette.main_text,
                              fontFamily: "Manrope",
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            "Tepat Waktu",
                            style: const TextStyle(
                              color: ColorPalette.main_text,
                              fontFamily: "Manrope",
                              fontSize: 15,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ]),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.more_time_rounded,
                    color: ColorPalette.main_green,
                    size: 25,
                  ),
                  const SizedBox(width: 2),
                  Text(
                    "Aktifkan Status Lembur",
                    style: const TextStyle(
                      color: Colors.black,
                      fontFamily: "Manrope",
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 2),
                  Icon(
                    Icons.info_outline_rounded,
                    color: ColorPalette.main_text,
                    size: 20,
                  ),
                  const Spacer(),
                  Switch(
                    activeColor: ColorPalette.main_green,
                    activeTrackColor: ColorPalette.navbar_off,
                    inactiveThumbColor: Colors.blueGrey.shade600,
                    inactiveTrackColor: Colors.grey.shade400,
                    splashRadius: 50.0,
                    // boolean variable value
                    value: true,
                    // changes the state of the switch
                    onChanged: (bool value) {
                      // do something
                    },
                  ),
                ],
              ),
              const Spacer(),
              Row(
                children: [
                  Text(
                    "Hari Libur",
                    style: const TextStyle(
                      color: Colors.black,
                      fontFamily: "Manrope",
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Holiday(),
                        ),
                      );
                    },
                    child: Text(
                      "Lihat Semua",
                      style: const TextStyle(
                        color: ColorPalette.main_yellow,
                        fontFamily: "Manrope",
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              BlocBuilder<EventBloc, EventState>(
                builder: (context, state) {
                  if (state is EventLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is EventLoaded) {
                    return Column(
                      children: state.events.take(2).map((event) {
                        return Container(
                          width: double.infinity,
                          height: 70,
                          margin: const EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            border: Border.all(color: ColorPalette.stroke_menu),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Text(
                                  event.name,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontFamily: "Manrope",
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Text(
                                  event.date.toString(), // Format the date as needed
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontFamily: "Manrope",
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    );
                  } else if (state is EventError) {
                    return Center(child: Text('Error: ${state.message}'));
                  } else {
                    return Center(child: Text('No events found'));
                  }
                },
              ),
              const Spacer(),
              Text("Absensi",
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: "Manrope",
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  )),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                      child: Container(
                        height: 210,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: ColorPalette.circle_menu),
                          color: ColorPalette.main_green,
                        ),
                        child: Padding(
                            padding: const EdgeInsets.all(14.0),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Status Dinas",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontFamily: "Manrope",
                                      fontSize: 22,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    "Aktifkan untuk  tugas dinas atau pekerjaan terkait",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontFamily: "Manrope",
                                      fontSize: 18,
                                    ),
                                  ),
                                  const Spacer(),
                                  CustomButton(
                                      text: "Aktifkan",
                                      onPressed: () {},
                                      textSize: 18,
                                      textColor: ColorPalette.main_green,
                                      buttonColor: Colors.white)
                                ])),
                      )),
                  const SizedBox(width: 10),
                  Expanded(
                      child: Container(
                        height: 210,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: ColorPalette.circle_menu),
                          color: ColorPalette.navbar_off,
                        ),
                        child: Padding(
                            padding: const EdgeInsets.all(14.0),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Izin Absen",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontFamily: "Manrope",
                                      fontSize: 22,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    "Isi form untuk meminta izin absen",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontFamily: "Manrope",
                                      fontSize: 18,
                                    ),
                                  ),
                                  const Spacer(),
                                  CustomButton(
                                      text: "Ajukan Izin",
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                            const PermissionForm(),
                                          ),
                                        );
                                      },
                                      textSize: 18,
                                      textColor: ColorPalette.navbar_off,
                                      buttonColor: Colors.white)
                                ])),
                      )),
                ],
              ),
              const Spacer(),
              CustomButton(
                text: "\u25CF Tekan Untuk Presensi Masuk",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AttendanceMenu(),
                    ),
                  );
                },
                textSize: 15,
              )
            ],
          ),
        ),
      ),
    );
  }
}
