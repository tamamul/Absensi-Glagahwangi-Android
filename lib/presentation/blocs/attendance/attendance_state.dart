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
  final bool hasOvertime;
  final String permissionStatus;
  final String dinasStatus;
  final bool isAlfa;

  const AttendanceStatusChecked(this.checkedIn, this.checkedOut, this.hasPermission, this.hasDinas, this.hasOvertime, this.dinasStatus, this.permissionStatus, this.isAlfa);

  @override
  List<Object> get props => [checkedIn, checkedOut, hasPermission, hasDinas, hasOvertime, dinasStatus, permissionStatus, isAlfa];
}