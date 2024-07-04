import 'package:equatable/equatable.dart';

class AttendanceEntity extends Equatable {
  final String id;
  final String uid;
  final String date;
  final Map<String, dynamic> inData;
  final Map<String, dynamic> outData;
  final String attendanceStatus;
  final String description;
  final DateTime timestamp;
  final String status;

  const AttendanceEntity({
    required this.id,
    required this.uid,
    required this.date,
    required this.inData,
    required this.outData,
    required this.attendanceStatus,
    required this.description,
    required this.timestamp,
    required this.status,
  });

  @override
  List<Object?> get props => [id, uid, date, inData, outData, attendanceStatus, description, timestamp, status];
}
