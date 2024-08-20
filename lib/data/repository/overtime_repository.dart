import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/overtime_model.dart';

class OvertimeRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  Future<bool> hasOvertime(String uid, DateTime date) async {
    String formattedDate = _formatDate(date);
    String documentId = '${uid}_$formattedDate';
    DocumentSnapshot snapshot = await _firestore.collection('overtime').doc(documentId).get();

    if (snapshot.exists && snapshot.data() != null) {
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      return data['status'] == 'lembur' || data['status'] == "belum absen keluar";
    }
    return false;
  }

  Future<void> recordOvertime(String uid, DateTime date) async {
    String formattedDate = _formatDate(date);
    String documentId = '${uid}_$formattedDate';

    if (date.hour >= 11 && date.minute >= 50 && await _hasCheckedIn(uid, date) && !await _hasCheckedOut(uid,date)) {
      OvertimeModel overtimeModel = OvertimeModel(
        id: documentId,
        uid: uid,
        date: formattedDate,
        status: "belum absen keluar",
        finish: "0",
        duration: 0,
      );
      await _firestore.collection('overtime').doc(documentId).set(overtimeModel.toMap(), SetOptions(merge: true));
    } else {
      throw Exception("Overtime can only be recorded after 11:50 and if the user has checked in and haven't checkout.");
    }
  }

  Future<void> nullifyOvertime(String uid, DateTime date) async {
    String formattedDate = _formatDate(date);
    String documentId = '${uid}_$formattedDate';

    DocumentSnapshot snapshot = await _firestore.collection('overtime').doc(documentId).get();
    if (snapshot.exists && snapshot.data() != null) {
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      if (data['status'] == "belum absen keluar") {
        await _firestore.collection('overtime').doc(documentId).set({
          'status': 'dibatalkan',
        }, SetOptions(merge: true));
      }
    }

  }

  Future<bool> _hasCheckedIn(String uid, DateTime date) async {
    String formattedDate = _formatDate(date);
    String documentId = '${uid}_$formattedDate';
    DocumentSnapshot snapshot = await _firestore.collection('attendance').doc(documentId).get();
    if (snapshot.exists) {
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      return data.containsKey('in') && data['in']['in'] == true;
    }
    return false;
  }

  Future<bool> _hasCheckedOut(String uid, DateTime date) async {
    String formattedDate = _formatDate(date);
    String documentId = '${uid}_$formattedDate';
    DocumentSnapshot snapshot = await _firestore.collection('attendance').doc(documentId).get();
    if (snapshot.exists) {
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      return data.containsKey('out') && data['out']['out'] == true;
    }
    return false;
  }

  Future<int> getOvertimeDurationForMonth(String uid, String month) async {
    String startDate = '$month-01';
    String endDate = '$month-31';

    QuerySnapshot snapshot = await _firestore.collection('overtime')
        .where('uid', isEqualTo: uid)
        .where('date', isGreaterThanOrEqualTo: startDate)
        .where('date', isLessThanOrEqualTo: endDate)
        .orderBy('date', descending: true)
        .get();

    int totalDuration = snapshot.docs.fold(0, (total, doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return total + (data["duration"] ?? 0) as int;
    });

    return totalDuration;
  }
}