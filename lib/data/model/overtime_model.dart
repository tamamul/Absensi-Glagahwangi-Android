import 'package:cloud_firestore/cloud_firestore.dart';

class OvertimeModel {
  final String id;
  final String uid;
  final String date;
  final String status;
  final String finish;
  final int duration;

  OvertimeModel({
    required this.id,
    required this.uid,
    required this.date,
    required this.status,
    required this.finish,
    required this.duration,
  });

  factory OvertimeModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return OvertimeModel(
      id: doc.id,
      uid: data['uid'] ?? '',
      date: data['date'] ?? '',
      status: data['status'] ?? '',
      finish: data['description'] ?? '',
      duration: data['duration'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'date': date,
      'status': status,
      'description': finish,
      'duration': duration,
    };
  }
}
