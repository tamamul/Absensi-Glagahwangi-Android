import 'package:absensi_glagahwangi/data/repository/user_repository.dart';
import 'package:absensi_glagahwangi/presentation/blocs/auth/auth_bloc.dart';
import 'package:absensi_glagahwangi/presentation/blocs/user/user_bloc.dart';
import 'package:absensi_glagahwangi/presentation/pages/attendance/attendance_recap.dart';
import 'package:absensi_glagahwangi/presentation/pages/attendance/event_menu.dart';
import 'package:absensi_glagahwangi/presentation/pages/attendance/permission_form.dart';
import 'package:absensi_glagahwangi/presentation/widget/custom_button.dart';
import 'package:absensi_glagahwangi/utils/color_palette.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repository/attendance_repository.dart';
import '../../../data/repository/event_repository.dart';
import '../../blocs/attendance/attendance_data/attendance_data_bloc.dart';
import '../../blocs/holiday/event_bloc.dart';
import 'attendance_menu/attendance_menu_in.dart';
import 'attendance_menu/attendance_menu_out.dart';
import '../../blocs/attendance/attendance_bloc.dart';

class Attendance extends StatefulWidget {
  const Attendance({Key? key}) : super(key: key);

  @override
  _AttendanceState createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {
  bool _hasCheckedIn = false;
  bool _hasCheckedOut = false;

  @override
  void initState() {
    super.initState();
    _checkAttendanceStatus();
  }

  void _checkAttendanceStatus() {
    final authUser = context.read<AuthBloc>().state.user;
    context.read<AttendanceBloc>().add(CheckAttendanceStatus(authUser.id!, DateTime.now()));
    context.read<AttendanceDataBloc>().add(FetchAttendanceForDate(authUser.id!, DateTime.now()));
  }

  @override
  Widget build(BuildContext context) {
    final authUser = context.select((AuthBloc bloc) => bloc.state.user);
    return MultiBlocProvider(
      providers: [
        BlocProvider<EventBloc>(
          create: (context) => EventBloc(eventRepository: EventRepository())..add(FetchEvents()),
        ),
        BlocProvider<UserBloc>(
          create: (context) => UserBloc(userRepository: UserRepository())..add(FetchUser(authUser.id!)),
        ),
      ],
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.fromLTRB(12, 40, 12, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BlocBuilder<UserBloc, UserState>(
                builder: (context, state) {
                  if (state is UserInitial || state is UserLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is UserLoaded) {
                    return Row(
                      children: [
                        CircleAvatar(
                          radius: 35,
                          backgroundImage: NetworkImage(state.user.picture),
                          backgroundColor: Colors.grey,
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              state.user.name,
                              style: const TextStyle(
                                color: Colors.black,
                                fontFamily: "Manrope",
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              state.user.role,
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
                      ],
                    );
                  } else if (state is UserError) {
                    return Center(child: Text('Error: ${state.message}'));
                  } else {
                    return const Center(child: Text('No user found'));
                  }
                },
              ),
              const SizedBox(height: 20),
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
                          builder: (context) => AttendanceRecap(uid: authUser.id!),
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
              BlocBuilder<AttendanceDataBloc, AttendanceDataState>(
                builder: (context, state) {
                  if (state is AttendanceDataLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is AttendanceDataLoaded) {
                    final attendanceData = state.attendanceData;
                    final inData = attendanceData['in'];
                    final outData = attendanceData['out'];
                    final attendanceStatus = attendanceData['attendanceStatus'];

                    return Row(
                      children: [
                        _buildAttendanceCard(
                          "Masuk",
                          Icons.input_rounded,
                          attendanceStatus != null && attendanceStatus != 'absen'
                              ? attendanceStatus
                              : inData != null
                              ? inData['time'] ?? "Belum"
                              : "Belum",
                          attendanceStatus != null && attendanceStatus != 'absen'
                              ? "---"
                              : inData != null
                              ? inData['status'] ?? "---"
                              : "---",
                        ),
                        const SizedBox(width: 10),
                        _buildAttendanceCard(
                          "Keluar",
                          Icons.output_rounded,
                          attendanceStatus != null && attendanceStatus != 'absen'
                              ? attendanceStatus
                              : outData != null
                              ? outData['time'] ?? "Belum"
                              : "Belum",
                          attendanceStatus != null && attendanceStatus != 'absen'
                              ? "---"
                              : outData != null
                              ? "Pulang"
                              : "---",
                        ),
                      ],
                    );
                  } else if (state is AttendanceDataEmpty || state is AttendanceDataFailure) {
                    return Row(
                      children: [
                        _buildAttendanceCard("Masuk", Icons.input_rounded, "Belum", "---"),
                        const SizedBox(width: 10),
                        _buildAttendanceCard("Keluar", Icons.output_rounded, "Belum", "---"),
                      ],
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
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
                    value: true,
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
              const SizedBox(height: 8),
              BlocBuilder<EventBloc, EventState>(
                builder: (context, state) {
                  if (state is EventLoading) {
                    return const Center(child: CircularProgressIndicator());
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
                    return const Center(child: Text('No events found'));
                  }
                },
              ),
              const Spacer(),
              Text(
                "Absensi",
                style: const TextStyle(
                  color: Colors.black,
                  fontFamily: "Manrope",
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
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
                              "Aktifkan untuk tugas dinas atau pekerjaan terkait",
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
                              buttonColor: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
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
                                    builder: (context) => const PermissionForm(),
                                  ),
                                );
                              },
                              textSize: 18,
                              textColor: ColorPalette.navbar_off,
                              buttonColor: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              BlocBuilder<AttendanceBloc, AttendanceState>(
                builder: (context, state) {
                  if (state is AttendanceLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is AttendanceStatusChecked) {
                    _hasCheckedIn = state.checkedIn;
                    _hasCheckedOut = state.checkedOut;

                    if (_hasCheckedIn && _hasCheckedOut) {
                      return CustomButton(
                        text: "Sudah absen hari ini",
                        onPressed: () {},
                        textSize: 15,
                        textColor: Colors.white,
                        buttonColor: Colors.grey,
                      );
                    } else {
                      return CustomButton(
                        text: _hasCheckedIn ? "\u25CF Tekan Untuk Presensi Keluar" : "\u25CF Tekan Untuk Presensi Masuk",
                        onPressed: () {
                          if (_hasCheckedIn) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AttendanceMenuOut(),
                              ),
                            ).then((_) {
                              _checkAttendanceStatus(); // Update the state after coming back from AttendanceMenu or AttendanceMenuOut
                            });
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AttendanceMenuIn(),
                              ),
                            ).then((_) {
                              _checkAttendanceStatus(); // Update the state after coming back from AttendanceMenu or AttendanceMenuOut
                            });
                          }
                        },
                        textSize: 15,
                        textColor: _hasCheckedIn ? Colors.black : Colors.white,
                        buttonColor: _hasCheckedIn ? ColorPalette.main_yellow : ColorPalette.main_green,
                      );
                    }
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildAttendanceCard(String title, IconData icon, String time, String status) {
  return Expanded(
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
                child: Icon(icon, size: 20, color: ColorPalette.main_green),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  color: ColorPalette.main_text,
                  fontFamily: "Manrope",
                  fontSize: 18,
                ),
              ),
            ]),
            const SizedBox(width: 10),
            Text(
              time,
              style: const TextStyle(
                color: ColorPalette.main_text,
                fontFamily: "Manrope",
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              status,
              style: const TextStyle(
                color: ColorPalette.main_text,
                fontFamily: "Manrope",
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
