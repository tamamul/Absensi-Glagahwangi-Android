part of 'attendance_data_bloc.dart';

abstract class AttendanceDataEvent extends Equatable {
  const AttendanceDataEvent();

  @override
  List<Object> get props => [];
}

class GetAttendanceForDate extends AttendanceDataEvent {
  final String uid;
  final DateTime date;

  const GetAttendanceForDate(this.uid, this.date);

  @override
  List<Object> get props => [uid, date];
}

class GetAttendanceList extends AttendanceDataEvent {
  final String uid;

  const GetAttendanceList(this.uid);

  @override
  List<Object> get props => [uid];
}

class GetAttendanceForMonth extends AttendanceDataEvent {
  final String uid;
  final String month;

  const GetAttendanceForMonth(this.uid, this.month);

  @override
  List<Object> get props => [uid, month];
}

class ExportAttendanceToExcel extends AttendanceDataEvent {
  final String uid;
  final String outputPath;
  final DateTime date;

  const ExportAttendanceToExcel(this.uid, this.outputPath, this.date);

  @override
  List<Object> get props => [uid, outputPath];
}