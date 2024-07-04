import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class ForgetAttendanceEntity extends Equatable {
  final String id;
  final String uid;
  final String date;
  final String fileUrl;
  final String description;
  final bool checkedByAdmin;
  final String status;
  final Timestamp createdTimestamp;

  const ForgetAttendanceEntity({
    required this.id,
    required this.uid,
    required this.date,
    required this.fileUrl,
    required this.description,
    required this.checkedByAdmin,
    required this.status,
    required this.createdTimestamp,
  });

  @override
  List<Object> get props => [
    id,
    uid,
    date,
    fileUrl,
    description,
    checkedByAdmin,
    status,
    createdTimestamp,
  ];

  ForgetAttendanceEntity copyWith({
    String? id,
    String? uid,
    String? date,
    String? fileUrl,
    String? description,
    bool? checkedByAdmin,
    String? status,
    Timestamp? createdTimestamp,
  }) {
    return ForgetAttendanceEntity(
      id: id ?? this.id,
      uid: uid ?? this.uid,
      date: date ?? this.date,
      fileUrl: fileUrl ?? this.fileUrl,
      description: description ?? this.description,
      checkedByAdmin: checkedByAdmin ?? this.checkedByAdmin,
      status: status ?? this.status,
      createdTimestamp: createdTimestamp ?? this.createdTimestamp,
    );
  }
}
