import 'package:cloud_firestore/cloud_firestore.dart';

class OvertimeRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  Future<bool> hasOvertime(String uid, DateTime date) async {
    String formattedDate = _formatDate(date);
    String documentId = '${uid}_$formattedDate';
    DocumentSnapshot snapshot = await _firestore.collection('attendance').doc(documentId).get();

    if (snapshot.exists) {
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      return data['attendanceStatus'] == 'lembur';
    } else {
      return false;
    }
  }

  Future<void> insertOvertime(String uid, DateTime date) async {
    String formattedDate = _formatDate(date);
    String documentId = '${uid}_$formattedDate';

    if (date.hour >= 11 && date.minute >= 50 && await _hasCheckedIn(uid, date) && !await _hasCheckedOut(uid,date)) {
      await _firestore.collection('attendance').doc(documentId).set({
        'out': {
          'status':"Pulang Lembur"
        },
        'attendanceStatus':'lembur',
        'description': 'Melakukan Lembur',
      }, SetOptions(merge: true));
    } else {
      throw Exception("Overtime can only be recorded after 11:50 and if the user has checked in and haven't checkout.");
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