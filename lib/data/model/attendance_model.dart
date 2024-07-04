import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entity/attendance.dart';

class AttendanceModel {
  final String id;
  final String uid;
  final String date;
  final Map<String, dynamic> inData;
  final Map<String, dynamic> outData;
  final String attendanceStatus;
  final String description;
  final Timestamp timestamp;
  final String status;

  AttendanceModel({
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

  factory AttendanceModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return AttendanceModel(
      id: doc.id,
      uid: data['uid'] ?? '',
      date: data['date'] ?? '',
      inData: data['in'] ?? {},
      outData: data['out'] ?? {},
      attendanceStatus: data['attendanceStatus'] ?? '',
      description: data['description'] ?? '',
      timestamp: data['timestamp'] ?? Timestamp.now(),
      status: data['status'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'date': date,
      'in': inData,
      'out': outData,
      'attendanceStatus': attendanceStatus,
      'description': description,
      'timestamp': timestamp,
      'status': status,
    };
  }

  AttendanceEntity toEntity() {
    return AttendanceEntity(
      id: id,
      uid: uid,
      date: date,
      inData: inData,
      outData: outData,
      attendanceStatus: attendanceStatus,
      description: description,
      timestamp: timestamp.toDate(),
      status: status,
    );
  }

  factory AttendanceModel.fromEntity(AttendanceEntity entity) {
    return AttendanceModel(
      id: entity.id,
      uid: entity.uid,
      date: entity.date,
      inData: entity.inData,
      outData: entity.outData,
      attendanceStatus: entity.attendanceStatus,
      description: entity.description,
      timestamp: Timestamp.fromDate(entity.timestamp),
      status: entity.status,
    );
  }
}
