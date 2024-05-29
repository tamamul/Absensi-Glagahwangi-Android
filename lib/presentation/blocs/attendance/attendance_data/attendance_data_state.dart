part of 'attendance_data_bloc.dart';

abstract class AttendanceDataState extends Equatable {
  const AttendanceDataState();

  @override
  List<Object> get props => [];
}

class AttendanceDataInitial extends AttendanceDataState {}

class AttendanceDataLoading extends AttendanceDataState {}

class AttendanceDataLoaded extends AttendanceDataState {
  final Map<String, dynamic> attendanceData;

  const AttendanceDataLoaded(this.attendanceData);

  @override
  List<Object> get props => [attendanceData];
}

class AttendanceListFetched extends AttendanceDataState {
  final List<Map<String, dynamic>> attendanceList;

  const AttendanceListFetched(this.attendanceList);

  @override
  List<Object> get props => [attendanceList];
}

class AttendanceDataEmpty extends AttendanceDataState {}

class AttendanceDataFailure extends AttendanceDataState {
  final String error;

  const AttendanceDataFailure(this.error);

  @override
  List<Object> get props => [error];
}