part of 'attendance_data_bloc.dart';

abstract class AttendanceDataEvent extends Equatable {
  const AttendanceDataEvent();

  @override
  List<Object> get props => [];
}

class FetchAttendanceForDate extends AttendanceDataEvent {
  final String uid;
  final DateTime date;

  const FetchAttendanceForDate(this.uid, this.date);

  @override
  List<Object> get props => [uid, date];
}

class FetchAttendanceList extends AttendanceDataEvent {
  final String uid;

  const FetchAttendanceList(this.uid);

  @override
  List<Object> get props => [uid];
}

class FetchAttendanceForMonth extends AttendanceDataEvent {
  final String uid;
  final String month;

  const FetchAttendanceForMonth(this.uid, this.month);

  @override
  List<Object> get props => [uid, month];
}
