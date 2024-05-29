part of 'attendance_bloc.dart';

abstract class AttendanceEvent extends Equatable {
  const AttendanceEvent();

  @override
  List<Object> get props => [];
}

class RecordAttendanceIn extends AttendanceEvent {
  final String uid;
  final DateTime date;
  final String location;
  final String imagePath;

  const RecordAttendanceIn(this.uid, this.date, this.location, this.imagePath);

  @override
  List<Object> get props => [uid, date, location, imagePath];
}

class RecordAttendanceOut extends AttendanceEvent {
  final String uid;
  final DateTime date;
  final String location;
  final String imagePath;

  const RecordAttendanceOut(this.uid, this.date, this.location, this.imagePath);

  @override
  List<Object> get props => [uid, date, location, imagePath];
}

class CheckAttendanceStatus extends AttendanceEvent {
  final String uid;
  final DateTime date;

  const CheckAttendanceStatus(this.uid, this.date);

  @override
  List<Object> get props => [uid, date];
}

class FetchAttendanceList extends AttendanceEvent {
  final String uid;

  const FetchAttendanceList(this.uid);

  @override
  List<Object> get props => [uid];
}
