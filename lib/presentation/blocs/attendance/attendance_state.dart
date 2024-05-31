part of 'attendance_bloc.dart';

abstract class AttendanceState extends Equatable {
  const AttendanceState();

  @override
  List<Object> get props => [];
}

class AttendanceInitial extends AttendanceState {}

class AttendanceLoading extends AttendanceState {}

class AttendanceSuccess extends AttendanceState {}

class AttendanceFailure extends AttendanceState {
  final String error;

  const AttendanceFailure(this.error);

  @override
  List<Object> get props => [error];
}

class AttendanceStatusChecked extends AttendanceState {
  final bool checkedIn;
  final bool checkedOut;
  final bool hasPermission;
  final bool hasDinas;
  final String permissionStatus;

  const AttendanceStatusChecked(this.checkedIn, this.checkedOut, this.hasPermission, this.hasDinas, this.permissionStatus);

  @override
  List<Object> get props => [checkedIn, checkedOut, hasPermission, hasDinas];
}

class AttendanceListFetched extends AttendanceState {
  final List<Map<String, dynamic>> attendanceList;

  const AttendanceListFetched(this.attendanceList);

  @override
  List<Object> get props => [attendanceList];
}