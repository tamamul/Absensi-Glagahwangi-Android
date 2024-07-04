import 'dart:io';

import 'package:absensi_glagahwangi/data/repository/holiday_repository.dart';
import 'package:absensi_glagahwangi/presentation/blocs/AppBlocObserver.dart';
import 'package:absensi_glagahwangi/presentation/pages/app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'data/repository/attendance_repository.dart';
import 'data/repository/auth_repository.dart';
import 'data/repository/dinas_repository.dart';
import 'data/repository/map_repository.dart';
import 'data/repository/overtime_repository.dart';
import 'data/repository/permission_repository.dart';
import 'data/repository/user_repository.dart';
import 'domain/use_case//automatic_task.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //Dev Only
  HttpClient().badCertificateCallback = (X509Certificate cert, String host, int port) => true;

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  Bloc.observer = const AppBlocObserver();

  final authRepository = AuthRepository();
  final userRepository = UserRepository();
  final mapRepository = MapRepository();
  final eventRepository = HolidayRepository();
  final attendanceRepository = AttendanceRepository();
  final overtimeRepository = OvertimeRepository();
  final dinasRepository = DinasRepository();
  final permissionRepository = PermissionsRepository();

  var user = await authRepository.user.first;

  AutomaticTask automaticTask = AutomaticTask(attendanceRepository,eventRepository);
  automaticTask.scheduleAutomaticAttendanceCheck(user.id);

  runApp(App(
    authRepository: authRepository,
    holidayRepository: eventRepository,
    userRepository: userRepository,
    mapRepository: mapRepository,
    attendanceRepository: attendanceRepository,
    overtimeRepository: overtimeRepository,
    dinasRepository: dinasRepository,
    permissionRepository: permissionRepository,
  ));
}
