import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entity/forget_attendance.dart';

class ForgetAttendanceModel {
  final String id;
  final String uid;
  final String date;
  final String fileUrl;
  final String description;
  final bool checkedByAdmin;
  final String status;
  final Timestamp createdTimestamp;

  ForgetAttendanceModel({
    required this.id,
    required this.uid,
    required this.date,
    required this.fileUrl,
    required this.description,
    required this.checkedByAdmin,
    required this.status,
    required this.createdTimestamp,
  });

  factory ForgetAttendanceModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return ForgetAttendanceModel(
      id: doc.id,
      uid: data['uid'] ?? '',
      date: data['date'] ?? '',
      fileUrl: data['file_url'] ?? '',
      description: data['description'] ?? '',
      checkedByAdmin: data['checked_by_admin'] ?? false,
      status: data['status'] ?? 'pending',
      createdTimestamp: data['createdTimestamp'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'uid': uid,
      'date': date,
      'file_url': fileUrl,
      'description': description,
      'checked_by_admin': checkedByAdmin,
      'status': status,
      'createdTimestamp': createdTimestamp,
    };
  }

  ForgetAttendanceEntity toEntity() {
    return ForgetAttendanceEntity(
      id: id,
      uid: uid,
      date: date,
      fileUrl: fileUrl,
      description: description,
      checkedByAdmin: checkedByAdmin,
      status: status,
      createdTimestamp: createdTimestamp,
    );
  }
}
