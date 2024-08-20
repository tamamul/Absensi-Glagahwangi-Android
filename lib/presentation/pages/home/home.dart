import 'package:absensi_glagahwangi/data/repository/overtime_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../data/repository/user_repository.dart';
import '../../../data/repository/attendance_repository.dart';
import '../../../domain/entity/user.dart';
import '../../blocs/attendance/attendance_data/attendance_data_bloc.dart';
import '../../blocs/attendance/overtime/overtime_data_bloc.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/user/user_bloc.dart';
import 'attendance_line_chart.dart';
import 'attendance_pie_chart.dart';
import 'overtime_data.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final authUser = context.select((UserBloc bloc) => bloc.state.user);

    return MultiBlocProvider(
      providers: [
        BlocProvider<UserBloc>(
          create: (context) => UserBloc(userRepository: UserRepository())
            ..add(getUser(authUser.id)),
        ),
        BlocProvider<AttendanceDataBloc>(
          create: (context) => AttendanceDataBloc(AttendanceRepository())
            ..add(GetAttendanceList(authUser.id)),
        ),
        BlocProvider<OvertimeDataBloc>(
          create: (context) => OvertimeDataBloc(OvertimeRepository())
            ..add(GetOvertimeDurationForMonth(authUser.id, DateFormat('yyyy-MM').format(DateTime.now()))),
        ),
      ],
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BlocBuilder<UserBloc, UserState>(
                    builder: (context, state) {
                      if (state is UserInitial || state is UserLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is UserLoaded) {
                        return Column(
                          children: [
                            Row(
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
                            ),
                            const SizedBox(height: 20),
                            BlocBuilder<AttendanceDataBloc, AttendanceDataState>(
                              builder: (context, state) {
                                if (state is AttendanceDataLoading) {
                                  return const Center(child: CircularProgressIndicator());
                                } else if (state is AttendanceListFetched) {
                                  return Column(
                                    children: [
                                      AttendancePieChart(state.attendanceList),
                                      const SizedBox(height: 20),
                                      BlocBuilder<OvertimeDataBloc, OvertimeDataState>(
                                        builder: (context, state) {
                                          return OvertimeDataWidget(
                                            overtimeDataBloc: context.read<OvertimeDataBloc>(),
                                            id: authUser.id,
                                          );
                                        },
                                      ),
                                      const SizedBox(height: 20),
                                      AttendanceLineChart(state.attendanceList),
                                    ],
                                  );
                                } else if (state is AttendanceDataFailure) {
                                  return Center(child: Text('Error: ${state.error}'));
                                } else {
                                  return const Center(child: Text('No attendance data found'));
                                }
                              },
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
