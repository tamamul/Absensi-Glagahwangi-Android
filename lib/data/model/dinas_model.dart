import 'package:cloud_firestore/cloud_firestore.dart';

class DinasModel {
  final String id;
  final String uid;
  final String description;
  final String date;
  final String type;
  final String file;
  final String status;
  final bool checkedByAdmin;
  final Timestamp createdTimestamp;

  DinasModel({
    required this.id,
    required this.uid,
    required this.description,
    required this.date,
    required this.type,
    required this.file,
    required this.status,
    required this.checkedByAdmin,
    required this.createdTimestamp,
  });

  factory DinasModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return DinasModel(
      id: doc.id,
      uid: data['uid'] ?? '',
      description: data['description'] ?? '',
      date: data['date'] ?? '',
      type: data['type'] ?? '',
      file: data['file'] ?? '',
      status: data['status'] ?? '',
      checkedByAdmin: data['checked_by_admin'] ?? false,
      createdTimestamp: data['createdTimestamp'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'description': description,
      'date': date,
      'type': type,
      'file': file,
      'status': status,
      'checked_by_admin': checkedByAdmin,
      'createdTimestamp': createdTimestamp,
    };
  }
}
