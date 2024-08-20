import 'package:cloud_firestore/cloud_firestore.dart';

class PermissionsModel {
  final String id;
  final String uid;
  final String description;
  final String type;
  final String status;
  final String date;
  final String file;
  final bool checkedByAdmin;
  final dynamic createdTimestamp;

  PermissionsModel({
    required this.id,
    required this.uid,
    required this.description,
    required this.type,
    required this.status,
    required this.date,
    required this.file,
    required this.checkedByAdmin,
    required this.createdTimestamp,
  });

  factory PermissionsModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return PermissionsModel(
      id: doc.id,
      uid: data['uid'] ?? '',
      description: data['description'] ?? '',
      type: data['type'] ?? '',
      status: data['status'] ?? '',
      date: data['date'] ?? '',
      file: data['file'] ?? '',
      checkedByAdmin: data['checked_by_admin'] ?? false,
      createdTimestamp: data['createdTimestamp'] is Timestamp ? data['createdTimestamp'] : Timestamp.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'description': description,
      'type': type,
      'status': status,
      'date': date,
      'file': file,
      'checked_by_admin': checkedByAdmin,
      'createdTimestamp': createdTimestamp,
    };
  }
}
