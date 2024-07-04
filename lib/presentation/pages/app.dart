import 'package:absensi_glagahwangi/data/repository/attendance_repository.dart';
import 'package:absensi_glagahwangi/data/repository/auth_repository.dart';
import 'package:absensi_glagahwangi/data/repository/holiday_repository.dart';
import 'package:absensi_glagahwangi/data/repository/overtime_repository.dart';
import 'package:absensi_glagahwangi/presentation/blocs/attendance/attendance_bloc.dart';
import 'package:absensi_glagahwangi/presentation/blocs/attendance/attendance_data/attendance_data_bloc.dart';
import 'package:absensi_glagahwangi/presentation/blocs/holiday/holiday_bloc.dart';
import 'package:absensi_glagahwangi/presentation/blocs/maps/maps_bloc.dart';
import 'package:absensi_glagahwangi/presentation/blocs/user/user_bloc.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repository/dinas_repository.dart';
import '../../data/repository/map_repository.dart';
import '../../data/repository/permission_repository.dart';
import '../../data/repository/user_repository.dart';
import '../blocs/auth/auth_bloc.dart';
import '../config/routes.dart';

class App extends StatelessWidget {
  final AuthRepository _authRepository;
  final HolidayRepository _holidayRepository;
  final UserRepository _userRepository;
  final MapRepository _mapRepository;
  final AttendanceRepository _attendanceRepository;
  final OvertimeRepository _overtimeRepository;
  final DinasRepository _dinasRepository;
  final PermissionsRepository _permissionRepository;

  const App({
    super.key,
    required AuthRepository authRepository,
    required HolidayRepository holidayRepository,
    required UserRepository userRepository,
    required MapRepository mapRepository,
    required AttendanceRepository attendanceRepository,
    required OvertimeRepository overtimeRepository,
    required DinasRepository dinasRepository,
    required PermissionsRepository permissionRepository,

  })  : _authRepository = authRepository,
        _holidayRepository = holidayRepository,
        _userRepository = userRepository,
        _mapRepository = mapRepository,
        _attendanceRepository = attendanceRepository,
        _overtimeRepository = overtimeRepository,
        _dinasRepository = dinasRepository,
        _permissionRepository = permissionRepository;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: _authRepository),
        RepositoryProvider.value(value: _holidayRepository),
        RepositoryProvider.value(value: _userRepository),
        RepositoryProvider.value(value: _mapRepository),
        RepositoryProvider.value(value: _attendanceRepository)
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
            create: (context) => AuthBloc(authRepository: _authRepository),
          ),
          BlocProvider<HolidayBloc>(
            create: (context) => HolidayBloc(holidayRepository: _holidayRepository),
          ),
          BlocProvider<UserBloc>(
            create: (context) => UserBloc(userRepository: _userRepository),
          ),
          BlocProvider<MapsBloc>(
            create: (context) => MapsBloc(_mapRepository),
          ),
          BlocProvider<AttendanceBloc>(
            create: (context) => AttendanceBloc(attendanceRepository: _attendanceRepository, dinasRepository: _dinasRepository, permissionsRepository: _permissionRepository, overtimeRepository: _overtimeRepository),
          ),
          BlocProvider<AttendanceDataBloc>(
            create: (context) => AttendanceDataBloc(_attendanceRepository),
          )
        ],
        child: const AppView(),
      ),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FlowBuilder<AuthStatus>(
        state: context.select((AuthBloc bloc) => bloc.state.status),
        onGeneratePages: onGenerateAppViewPages,
      ),
    );
  }
}
